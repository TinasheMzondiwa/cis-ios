//
//  TVVerseCardView.swift
//  tvOS
//

import SwiftUI

struct TVVerseCardView: View {
    let lyric: StoreLyric
    let refrainLabel: String?
    
    private var isChorus: Bool {
        lyric.type == "refrain"
    }
    
    private var headerText: String {
        if isChorus {
            return refrainLabel?.uppercased() ?? NSLocalizedString("Common.Chorus", comment: "")
        } else if let index = lyric.index {
            return String(format: NSLocalizedString("Common.VerseNumber", comment: ""), index)
        } else {
            return NSLocalizedString("Common.Verse", comment: "")
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 18) {
            // Stanza Category Badge (VERSE 1, CHORUS, etc.)
            Text(headerText)
                .font(TVStyle.uiFont(size: 18, weight: .bold))
                .tracking(2.5)
                .foregroundStyle(isChorus ? Color.white : Color.white.opacity(0.6))
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isChorus ? Color.white.opacity(0.18) : Color.white.opacity(0.08))
                )
            
            // Stanza Poetic Lines
            VStack(alignment: .center, spacing: 10) {
                ForEach(Array(lyric.lines.enumerated()), id: \.offset) { _, line in
                    Text(line)
                        .font(isChorus ? TVStyle.chorusFont(size: 40) : TVStyle.verseFont(size: 38))
                        .foregroundStyle(isChorus ? Color(white: 0.98) : Color.white)
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.vertical, isChorus ? 36 : 24)
        .padding(.horizontal, isChorus ? 48 : 32)
        .frame(maxWidth: 1300)
        .background(
            Group {
                if isChorus {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(TVStyle.chorusBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(TVStyle.chorusBorder, lineWidth: 2)
                        )
                        .shadow(color: TVStyle.accentGold.opacity(0.14), radius: 24, x: 0, y: 8)
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.025))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.04), lineWidth: 1)
                        )
                }
            }
        )
    }
}

#Preview {
    let sampleVerse = StoreLyric(
        type: "verse",
        index: 1,
        lines: [
            "Come, Thou Fount of every blessing,",
            "Tune my heart to sing Thy grace;",
            "Streams of mercy, never ceasing,",
            "Call for songs of loudest praise."
        ]
    )
    let sampleChorus = StoreLyric(
        type: "refrain",
        index: nil,
        lines: [
            "Praise the mount! I'm fixed upon it,",
            "Mount of Thy redeeming love."
        ]
    )
    return VStack(spacing: 30) {
        TVVerseCardView(lyric: sampleVerse, refrainLabel: "Chorus")
        TVVerseCardView(lyric: sampleChorus, refrainLabel: "Chorus")
    }
    .padding(50)
    .background(Color.black)
}
