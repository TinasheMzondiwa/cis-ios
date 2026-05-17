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

    private let engine = AVAudioEngine()
    private let sampler = AVAudioUnitSampler()
    private var sequencer: AVAudioSequencer!

    private var timer: Timer?

    // MARK: - Init

    init() {
        setupAudioSession()
        setupAudioGraph()
        sequencer = AVAudioSequencer(audioEngine: engine)
        setupRemoteTransportControls()
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
            nowPlayingInfo[MPMediaItemPropertyArtist] = "Hymn \(number)"
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

    // MARK: - Setup (ONE TIME ONLY)

    private func setupAudioGraph() {
        engine.attach(sampler)

        engine.connect(
            sampler,
            to: engine.mainMixerNode,
            format: nil
        )
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

        do {
            try sequencer.load(from: url)

            // Route ALL tracks to sampler
            for track in sequencer.tracks {
                track.destinationAudioUnit = sampler
            }

            duration = sequencer.tracks
                .map(\.lengthInSeconds)
                .max() ?? 0

            currentTime = 0
            progress = 0
            hasTrack = true

        } catch {
            print("MIDI load failed:", error)
            hasTrack = false
        }
    }

    // MARK: - Playback

    func play() {
        guard !isPlaying else { return }
        guard hasTrack else { return }

        do {
            if !engine.isRunning {
                try engine.start()
            }

            try sequencer.start()

            isPlaying = true
            updateNowPlayingInfo(isPause: false)
            startTimer()

        } catch {
            print("Play failed:", error)
        }
    }

    func pause() {
        guard isPlaying else { return }

        sequencer.stop()
        engine.pause()
        
        isPlaying = false
        updateNowPlayingInfo(isPause: true)
        stopTimer()
    }

    func stop() {

        sequencer?.stop()
        engine.stop()

        sequencer.currentPositionInSeconds = 0

        isPlaying = false
        currentTime = 0
        progress = 0

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        stopTimer()
    }

    func seek(to progress: Double) {

        guard duration > 0 else { return }

        let time = duration * progress
        sequencer.currentPositionInSeconds = time

        currentTime = time
        self.progress = progress

        if isPlaying {
            do {
                try sequencer.start()
                updateNowPlayingInfo(isPause: false)
            } catch {
                print("Seek restart failed:", error)
            }
        } else {
            updateNowPlayingInfo(isPause: true)
        }
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
        let t = sequencer.currentPositionInSeconds

        currentTime = t

        if duration > 0 {
            progress = t / duration
        }

        if t >= duration, duration > 0 {
            isPlaying = false
            stopTimer()
            progress = 1
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        }
    }
}
