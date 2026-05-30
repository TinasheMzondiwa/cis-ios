import Foundation
import AVFoundation
import Combine
import MediaPlayer

#if os(iOS)
import UIKit
#endif

@MainActor
final class TunePlayer: ObservableObject {

    // MARK: - Published State

    @Published var isPlaying = false
    var progress: Double = 0
    var duration: Double = 0
    var currentTime: Double = 0

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
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session:", error)
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
        
        #if os(iOS)
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

    private func load(url: URL) {

        stop()

        guard isSoundBankReady else {
            print("Soundbank is not ready yet. Deferring MIDI load.")
            deferredURL = url
            return
        }

        do {
            let fileManager = FileManager.default
            guard let appSupportDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
                hasTrack = false
                return
            }
            let soundbankURL = appSupportDirectory.appendingPathComponent("TimGM6mb.sf2")

            midiPlayer = try AVMIDIPlayer(contentsOf: url, soundBankURL: soundbankURL)
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
        let fileManager = FileManager.default
        guard let appSupportDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return
        }

        // Ensure the directory exists
        try? fileManager.createDirectory(at: appSupportDirectory, withIntermediateDirectories: true)
        
        let soundbankURL = appSupportDirectory.appendingPathComponent("TimGM6mb.sf2")

        if fileManager.fileExists(atPath: soundbankURL.path) {
            self.isSoundBankReady = true
            return
        }

        self.isDownloadingSoundBank = true
        let downloadURL = URL(string: "https://raw.githubusercontent.com/craffel/pretty-midi/master/pretty_midi/TimGM6mb.sf2")!
        
        let task = URLSession.shared.downloadTask(with: downloadURL) { [weak self] localURL, response, error in
            guard let self = self else { return }
            
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
                if fileManager.fileExists(atPath: soundbankURL.path) {
                    try fileManager.removeItem(at: soundbankURL)
                }
                try fileManager.moveItem(at: tempURL, to: soundbankURL)
                
                Task { @MainActor [weak self] in
                    guard let self = self else { return }
                    self.isDownloadingSoundBank = false
                    self.isSoundBankReady = true
                    print("Soundbank successfully downloaded and saved.")
                    if let deferred = self.deferredURL {
                        self.load(url: deferred)
                        self.deferredURL = nil
                    }
                }
            } catch {
                print("Failed to move downloaded soundbank:", error)
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

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
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
