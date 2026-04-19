//
//  ChorusUiView.swift
//  iOS
//
//  Created by Tinashe Mzondiwa on 2026-04-12.
//

import SwiftUI

struct ChorusUiView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @AppStorage("hymnalFontSize") private var fontSize: Double = 22.0
    @AppStorage("hymnalTypeface") private var selectedFontRaw: String = AppTypeface.defaultTypeface.rawValue
    
    var colors: HymnColors {
        HymnColors(scheme: colorScheme)
    }
    
    let lines: [String]
    let refrainLabel: String?
    
    var body: some View {
        let typeface = AppTypeface(rawValue: selectedFontRaw) ?? .defaultTypeface
        
        VStack(alignment: .leading, spacing: 10) {
            
            // Header
            HStack(spacing: 8) {
                Image(systemName: "music.note")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(colors.onSecondaryContainer)
                    .frame(width: 32, height: 32)
                    .background(colors.secondaryContainer)
                    .clipShape(Circle())
                
                Text(refrainLabel ?? "Chorus")
                    .font(typeface.font(size: fontSize - 2, weight: .semibold))
                    .foregroundColor(colors.onSurfaceVariant)
                
                Spacer()
            }
            
            // Content container
            HStack(spacing: 0) {
                
                // Left accent bar
                RoundedRectangle(cornerRadius: 4)
                    .fill(colors.onSecondaryContainer)
                    .frame(width: 6)
                
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(lines, id: \.self) { line in
                        Text(line)
                            .font(typeface.font(size: fontSize, weight: .regular))
                            .foregroundColor(colors.onSecondaryContainer)
                            .lineSpacing(6)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .background(colors.secondaryContainer)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.leading, 32)
        .padding(.bottom, 16)
    }
}

#Preview {
    ChorusUiView(lines: [
        "So I'll cherish the old rugged cross",
        "Till my trophies at last I lay down",
        "I will cling to the old rugged cross",
        "And exchange it someday for a crown",
    ], refrainLabel: nil)
}
