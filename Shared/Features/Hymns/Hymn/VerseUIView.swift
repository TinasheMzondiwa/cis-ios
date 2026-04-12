//
//  VerseUIView.swift
//  iOS
//
//  Created by Tinashe Mzondiwa on 2026-04-12.
//

import SwiftUI

struct VerseUIView: View {
    
    @Environment(\.colorScheme) private var colorScheme

    var colors: HymnColors {
        HymnColors(scheme: colorScheme)
    }
    
    let index: Int
    let lines: [String]

    var body: some View {
        HStack(alignment: .top) {
            // Index bubble
            Text("\(index)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(colors.onSurfaceVariant)
                .frame(width: 28, height: 28)
                .background(colors.surfaceVariant)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                ForEach(lines, id: \.self) { line in
                    Text(line)
                        .font(.system(size: 17))
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
