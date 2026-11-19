import Foundation
import AVFoundation
import Combine
import MediaPlayer

#if canImport(UIKit)
import UIKit
#endif

@MainActor
final class TunePlayer: ObservableObject {

    // MARK: - Published State

    @Published var isPlaying = false
    @Published var progress: Double = 0
    @Published var duration: Double = 0
    @Published var currentTime: Double = 0

    @Published var activeBookKey: String?
    @Published var activeHymnNumber: Int?
    @Published var activeTitle: String?
    @Published var hasTrack = false

    // MARK: - Audio Engine

    private var midiPlayer: AVMIDIPlayer?
    private var timer: Timer?

    private var deferredURL: URL?
    private var lastNowPlayingUpdateTime: Double = 0.0
    @Published var isSoundBankReady = false
    @Published var isDownloadingSoundBank = false

    // MARK: - Init

    init() {
        setupAudioSession()
        setupRemoteTransportControls()
        checkAndDownloadSoundBank()
    }
    
    // MARK: - Integration
    
    private func setupAudioSession() {
        Task.detached(priority: .userInitiated) {
            do {
                let session = AVAudioSession.sharedInstance()
                try session.setCategory(.playback, mode: .default)
                try session.setActive(true)
            } catch {
                print("Failed to setup audio session:", error)
            }
        }
    }

    private func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [weak self] event in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                if !self.isPlaying {
                    self.play()
                }
            }
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] event in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                if self.isPlaying {
                    self.pause()
                }
            }
            return .success
        }
    }

    private func updateNowPlayingInfo(isPause: Bool = false) {
        var nowPlayingInfo = [String: Any]()
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = activeTitle ?? "Christ In Song"
        
        if let number = activeHymnNumber {
            nowPlayingInfo[MPMediaItemPropertyArtist] = "SDAH \(number)"
        }
        
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPause ? 0.0 : 1.0
        
        #if canImport(UIKit)
        if let image = UIImage(named: "logo") {
            let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        }
        #endif
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    // MARK: - Load

    func load(bookKey: String, hymnNumber: Int, title: String) {

        activeBookKey = bookKey
        activeHymnNumber = hymnNumber
        activeTitle = title

        guard bookKey == "sdah" else {
            hasTrack = false
            stop()
            return
        }

        let filename = String(format: "%03d", hymnNumber)

        guard let url = Bundle.main.url(forResource: filename, withExtension: "mid") else {
            hasTrack = false
            stop()
            return
        }

        load(url: url)
    }

    private var soundbankURL: URL? {
        let fm = FileManager.default
        #if os(tvOS)
        // On tvOS, Caches directory is the only permitted writable location for downloaded media assets
        guard let baseDir = fm.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return baseDir.appendingPathComponent("TimGM6mb.sf2")
        #else
        // On iOS, check Application Support first (for existing installs), else use Caches
        if let appSupport = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.appendingPathComponent("TimGM6mb.sf2"),
           fm.fileExists(atPath: appSupport.path) {
            return appSupport
        }
        let baseDir = fm.urls(for: .cachesDirectory, in: .userDomainMask).first
            ?? fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        return baseDir?.appendingPathComponent("TimGM6mb.sf2")
        #endif
    }

    private func load(url: URL) {
        stop()

        guard isSoundBankReady else {
            print("Soundbank is not ready yet. Deferring MIDI load.")
            deferredURL = url
            return
        }

        guard let targetURL = soundbankURL, FileManager.default.fileExists(atPath: targetURL.path) else {
            print("Soundbank file missing at path.")
            hasTrack = false
            return
        }

        do {
            midiPlayer = try AVMIDIPlayer(contentsOf: url, soundBankURL: targetURL)
            midiPlayer?.prepareToPlay()
            
            duration = midiPlayer?.duration ?? 0
            currentTime = 0
            progress = 0
            hasTrack = true
        } catch {
            print("MIDI load failed:", error)
            hasTrack = false
        }
    }

    // MARK: - SoundBank Manager
    
    private func checkAndDownloadSoundBank() {
        guard let targetURL = soundbankURL else { return }
        let targetDir = targetURL.deletingLastPathComponent()
        let fileManager = FileManager.default

        // Ensure target directory exists
        try? fileManager.createDirectory(at: targetDir, withIntermediateDirectories: true)

        if fileManager.fileExists(atPath: targetURL.path) {
            self.isSoundBankReady = true
            return
        }

        self.isDownloadingSoundBank = true
        let downloadURL = URL(string: "https://raw.githubusercontent.com/craffel/pretty-midi/master/pretty_midi/TimGM6mb.sf2")!
        
        let task = URLSession.shared.downloadTask(with: downloadURL) { [weak self] localURL, response, error in
            guard let self = self else { return }
            let fm = FileManager.default
            
            if let error = error {
                print("Soundbank download failed:", error)
                Task { @MainActor [weak self] in
                    self?.isDownloadingSoundBank = false
                }
                return
            }
            
            guard let tempURL = localURL else {
                Task { @MainActor [weak self] in
                    self?.isDownloadingSoundBank = false
                }
                return
            }
            
            do {
                try fm.createDirectory(at: targetDir, withIntermediateDirectories: true)
                if fm.fileExists(atPath: targetURL.path) {
                    try? fm.removeItem(at: targetURL)
                }
                
                // Attempt move, fallback to copy if cross-volume move fails
                do {
                    try fm.moveItem(at: tempURL, to: targetURL)
                } catch {
                    print("moveItem failed, falling back to copyItem:", error)
                    if fm.fileExists(atPath: targetURL.path) {
                        try? fm.removeItem(at: targetURL)
                    }
                    try fm.copyItem(at: tempURL, to: targetURL)
                }
                
                Task { @MainActor [weak self] in
                    guard let self = self else { return }
                    self.isDownloadingSoundBank = false
                    self.isSoundBankReady = true
                    print("Soundbank successfully downloaded and saved to:", targetURL.path)
                    if let deferred = self.deferredURL {
                        self.load(url: deferred)
                        self.deferredURL = nil
                    }
                }
            } catch {
                print("Failed to save downloaded soundbank:", error)
                Task { @MainActor [weak self] in
                    self?.isDownloadingSoundBank = false
                }
            }
        }
        task.resume()
    }

    // MARK: - Playback

    func play() {
        guard !isPlaying else { return }
        guard hasTrack else { return }

        // If we are at the end of the track, reset position to start
        if let player = midiPlayer, player.currentPosition >= player.duration - 0.5 {
            player.currentPosition = 0
            currentTime = 0
            progress = 0
        }

        isPlaying = true
        lastNowPlayingUpdateTime = midiPlayer?.currentPosition ?? 0
        updateNowPlayingInfo(isPause: false)
        startTimer()
        
        AnalyticsManager.shared.logEvent("click_play_tune", parameters: ["number": "\(activeHymnNumber ?? 0)"])

        midiPlayer?.play { [weak self] in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                guard self.isPlaying else { return }
                print("Finished playing")
                self.isPlaying = false
                self.currentTime = self.duration
                self.progress = 1.0
                self.midiPlayer?.currentPosition = 0
                self.stopTimer()
                self.updateNowPlayingInfo(isPause: true)
            }
        }
    }

    func pause() {
        guard isPlaying else { return }

        midiPlayer?.stop()
        
        isPlaying = false
        updateNowPlayingInfo(isPause: true)
        stopTimer()
    }

    func stop() {
        midiPlayer?.stop()
        midiPlayer?.currentPosition = 0

        isPlaying = false
        currentTime = 0
        progress = 0

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        stopTimer()
    }

    // MARK: - Timer

    private func startTimer() {
        stopTimer()

        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.update()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func update() {
        let t = midiPlayer?.currentPosition ?? 0

        currentTime = t

        if duration > 0 {
            progress = t / duration
        }

        // Update now playing info every 1 second during playback to sync Lock Screen progress
        if isPlaying && (t - lastNowPlayingUpdateTime >= 1.0 || t < lastNowPlayingUpdateTime) {
            updateNowPlayingInfo(isPause: false)
            lastNowPlayingUpdateTime = t
        }

        if t >= duration, duration > 0 {
            isPlaying = false
            stopTimer()
            progress = 1
            midiPlayer?.currentPosition = 0
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        }
    }
}
