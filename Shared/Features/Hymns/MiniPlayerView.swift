//
//  MiniPlayerView.swift
//  ChristInSong
//
//  Created by Tinashe Mzondiwa on 2026-05-17.
//

import SwiftUI

struct MiniPlayerView: View {
    @EnvironmentObject var tunePlayer: TunePlayer
    @Environment(\.tabViewBottomAccessoryPlacement) var placement
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            
            ZStack {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.accentColor, Color.accentColor.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 28, height: 28)
                    .shadow(color: Color.accentColor.opacity(0.3), radius: 4, x: 0, y: 2)
                
                Image(systemName: "music.note")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                if let title = tunePlayer.activeTitle {
                    MarqueeText(
                        text: title,
                        font: .subheadline.weight(.semibold),
                        isPlaying: tunePlayer.isPlaying
                    )
                }
                if let number = tunePlayer.activeHymnNumber {
                    Text("SDAH \(number)")
                        .font(.caption2)
                        .foregroundColor(.primary)
                }
            }
            
            Spacer()
            
            Button {
                HapticsManager.instance.trigger(.light)
                
                if tunePlayer.isPlaying {
                    tunePlayer.pause()
                } else {
                    tunePlayer.play()
                }
            } label: {
                if tunePlayer.isDownloadingSoundBank {
                    ProgressView()
                        .frame(width: 30, height: 30)
                } else {
                    Image(systemName: tunePlayer.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title2)
                        .foregroundColor(tunePlayer.isSoundBankReady ? .primary : .secondary)
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                }
            }
            .disabled(!tunePlayer.isSoundBankReady)
            
            if placement != .inline {
                Button {
                    HapticsManager.instance.trigger(.light)
                    tunePlayer.hasTrack = false
                    tunePlayer.stop()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(.primary)
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}

#Preview {
    MiniPlayerView()
        .environmentObject(TunePlayer())
}

extension View {
    @ViewBuilder
    func applyMiniPlayerAccessory(hasTrack: Bool) -> some View {
#if os(iOS)
        if #available(iOS 26.1, *) {
            self.ios26Accessory(hasTrack: hasTrack)
        } else {
            self
        }
#else
        self
#endif
    }
}

@available(iOS 26.1, *)
extension View {
    func ios26Accessory(hasTrack: Bool) -> some View {
        self.tabViewBottomAccessory(isEnabled: hasTrack) {
            MiniPlayerView()
        }
    }
}

