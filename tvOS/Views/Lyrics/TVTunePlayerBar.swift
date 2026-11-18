//
//  TVTunePlayerBar.swift
//  tvOS
//

import SwiftUI

struct TVTunePlayerBar: View {
    let hymn: StoreHymn
    @EnvironmentObject private var tunePlayer: TunePlayer
    
    private var isSDAH: Bool {
        hymn.book == "sdah"
    }
    
    private func formatTime(_ time: Double) -> String {
        guard time.isFinite && !time.isNaN else { return "0:00" }
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var body: some View {
        Group {
            if isSDAH {
                HStack(spacing: 24) {
                    // Play / Pause Button
                    Button {
                        if tunePlayer.isPlaying {
                            tunePlayer.pause()
                        } else {
                            tunePlayer.play()
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: tunePlayer.isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 22, weight: .bold))
                            Text(tunePlayer.isPlaying ? LocalizedStringKey("Tune.Pause") : LocalizedStringKey("Tune.Play"))
                                .font(TVStyle.uiFont(size: 20, weight: .bold))
                        }
                        .padding(.horizontal, 22)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.white)
                    .foregroundStyle(Color.black)
                    
                    if tunePlayer.isDownloadingSoundBank {
                        HStack(spacing: 12) {
                            ProgressView()
                            Text(LocalizedStringKey("Tune.PreparingSoundbank"))
                                .font(TVStyle.uiFont(size: 18))
                                .foregroundStyle(Color.white.opacity(0.7))
                        }
                    } else if tunePlayer.hasTrack {
                        // Progress Bar & Time
                        VStack(spacing: 6) {
                            ProgressView(value: max(0, min(1, tunePlayer.progress)))
                                .tint(Color.white)
                                .frame(width: 420)
                            
                            HStack {
                                Text(formatTime(tunePlayer.currentTime))
                                    .font(TVStyle.uiFont(size: 16))
                                    .foregroundStyle(Color.white.opacity(0.6))
                                Spacer()
                                Text(formatTime(tunePlayer.duration))
                                    .font(TVStyle.uiFont(size: 16))
                                    .foregroundStyle(Color.white.opacity(0.6))
                            }
                            .frame(width: 420)
                        }
                    } else {
                        Text(LocalizedStringKey("Tune.Ready"))
                            .font(TVStyle.uiFont(size: 18))
                            .foregroundStyle(Color.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    // Remote hint
                    HStack(spacing: 8) {
                        Image(systemName: "playpause.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.white.opacity(0.85))
                        Text(LocalizedStringKey("Tune.RemoteHint"))
                            .font(TVStyle.uiFont(size: 16))
                            .foregroundStyle(Color.white.opacity(0.65))
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.6), radius: 24, x: 0, y: 10)
                )
                .onPlayPauseCommand {
                    if tunePlayer.isPlaying {
                        tunePlayer.pause()
                    } else {
                        tunePlayer.play()
                    }
                }
            }
        }
    }
}
