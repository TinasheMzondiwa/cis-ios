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

    var colors: HymnColors {
        HymnColors(scheme: colorScheme)
    }
    
    let index: Int
    let lines: [String]

    var body: some View {
        let typeface = AppTypeface(rawValue: selectedFontRaw) ?? .defaultTypeface
        
        HStack(alignment: .top) {
            // Index bubble
            Text("\(index)")
                .font(typeface.font(size: fontSize - 4, weight: .bold))
                .foregroundColor(colors.onSurfaceVariant)
                .frame(width: 28, height: 28)
                .background(colors.surfaceVariant)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                ForEach(lines, id: \.self) { line in
                    Text(line)
                        .font(typeface.font(size: fontSize, weight: .regular))
                        .foregroundColor(colors.onBackground)
                        .lineSpacing(6)
                }
            }
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
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
