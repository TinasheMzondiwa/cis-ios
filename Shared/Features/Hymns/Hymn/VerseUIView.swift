//
//  VerseUIView.swift
//  iOS
//
//  Created by Tinashe Mzondiwa on 2026-04-12.
//

import SwiftUI

struct VerseUIView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @AppStorage("hymnalFontSize") private var fontSize: Double = 22.0
    @AppStorage("hymnalTypeface") private var selectedFontRaw: String = AppTypeface.defaultTypeface.rawValue
    @AppStorage("hymnalTextAlignment") private var textAlignment: HymnalTextAlignment = .leading

    var colors: HymnColors {
        HymnColors(scheme: colorScheme)
    }
    
    let index: Int
    let lines: [String]

    @ViewBuilder
    private func indexBubble(font: Font) -> some View {
        Text("\(index)")
            .font(font)
            .foregroundColor(colors.onSurfaceVariant)
            .frame(width: fontSize + 6, height: fontSize + 6)
            .background(colors.surfaceVariant)
            .clipShape(Circle())
    }
    
    @ViewBuilder
    private func linesView(font: Font) -> some View {
        VStack(alignment: textAlignment.horizontalAlignment) {
            ForEach(lines, id: \.self) { line in
                Text(line)
                    .font(font)
                    .foregroundColor(colors.onBackground)
                    .lineSpacing(6)
            }
        }
        .multilineTextAlignment(textAlignment.textAlignment)
    }

    var body: some View {
        let typeface = AppTypeface(rawValue: selectedFontRaw) ?? .defaultTypeface
        let titleFont = typeface.font(size: fontSize - 4, weight: .bold)
        let bodyFont = typeface.font(size: fontSize, weight: .regular)
        
        Group {
            if textAlignment == .center {
                VStack(alignment: .center, spacing: 12) {
                    indexBubble(font: titleFont)
                    linesView(font: bodyFont)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            } else {
                HStack(alignment: .top) {
                    if textAlignment == .leading {
                        indexBubble(font: titleFont)
                    }
                    
                    linesView(font: bodyFont)
                        .frame(maxWidth: .infinity, alignment: textAlignment.frameAlignment)
                    
                    if textAlignment == .trailing {
                        indexBubble(font: titleFont)
                    }
                }
            }
        }
    }
}

#Preview {
    VerseUIView(
        index: 1,
        lines: [
            "On a hill far away",
            "Stood an old rugged cross",
            "The emblem of suffering and shame",
            "And I love that old cross",
            "Where the dearest and best",
            "For a world of lost sinners was slain",
        ],
    ).padding()
}
