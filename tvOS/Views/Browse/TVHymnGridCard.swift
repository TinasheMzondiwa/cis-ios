//
//  TVHymnGridCard.swift
//  tvOS
//

import SwiftUI

struct TVHymnGridCard: View {
    let hymn: StoreHymn
    let bookTitle: String?
    let action: () -> Void
    
    @FocusState private var isFocused: Bool
    
    private var isSDAH: Bool {
        hymn.book == "sdah"
    }
    
    private var previewLine: String? {
        if let english = hymn.titleEnglish, !english.isEmpty, english != hymn.title {
            return english
        }
        return hymn.lyrics.first?.lines.first
    }
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                // Top Row: Hymn Number Badge & Tune Badge
                HStack(alignment: .center) {
                    Text("\(hymn.number)")
                        .font(TVStyle.uiFont(size: 20, weight: .bold))
                        .foregroundStyle(isFocused ? Color.black : TVStyle.accentGold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(isFocused ? TVStyle.accentGold : TVStyle.accentGold.opacity(0.18))
                        )
                    
                    Spacer()
                    
                    if isSDAH {
                        HStack(spacing: 5) {
                            Image(systemName: "music.note")
                                .font(.system(size: 13, weight: .bold))
                            Text(LocalizedStringKey("Common.Tune"))
                                .font(TVStyle.uiFont(size: 15, weight: .semibold))
                        }
                        .foregroundStyle(isFocused ? Color.black.opacity(0.85) : Color.white.opacity(0.9))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(isFocused ? Color.white.opacity(0.9) : Color.white.opacity(0.14))
                        )
                    }
                }
                
                Spacer(minLength: 4)
                
                // Hymn Title
                Text(hymn.title)
                    .font(TVStyle.titleFont(size: 24))
                    .foregroundStyle(Color.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Lyric or English Preview snippet
                if let preview = previewLine, !preview.isEmpty {
                    Text(preview)
                        .font(TVStyle.uiFont(size: 17, weight: .regular))
                        .foregroundStyle(isFocused ? Color.white.opacity(0.9) : Color.white.opacity(0.55))
                        .lineLimit(1)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, minHeight: 180, maxHeight: 180, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: TVStyle.cardCornerRadius)
                    .fill(TVStyle.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: TVStyle.cardCornerRadius)
                    .stroke(TVStyle.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(.card)
        .focused($isFocused)
    }
}
