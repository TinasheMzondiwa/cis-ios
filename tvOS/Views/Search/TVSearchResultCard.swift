//
//  TVSearchResultCard.swift
//  tvOS
//

import SwiftUI

struct TVSearchResultCard: View {
    let hymn: StoreHymn
    let book: StoreBook?
    let searchQuery: String
    let action: () -> Void
    
    @FocusState private var isFocused: Bool
    
    private var isSDAH: Bool {
        hymn.book == "sdah"
    }
    
    private var snippet: String? {
        let trimmed = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            for lyric in hymn.lyrics {
                for line in lyric.lines {
                    if line.localizedCaseInsensitiveContains(trimmed) {
                        return line.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                }
            }
        }
        return hymn.lyrics.first?.lines.first?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center, spacing: 12) {
                    Text("\(hymn.number)")
                        .font(TVStyle.uiFont(size: 20, weight: .bold))
                        .foregroundStyle(isFocused ? Color.black : TVStyle.accentGold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule().fill(isFocused ? TVStyle.accentGold : TVStyle.accentGold.opacity(0.18))
                        )
                    
                    if let bookTitle = book?.title {
                        Text(bookTitle)
                            .font(TVStyle.uiFont(size: 17, weight: .medium))
                            .foregroundStyle(isFocused ? Color.white.opacity(0.9) : Color.white.opacity(0.6))
                    }
                    
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
                            Capsule().fill(isFocused ? Color.white.opacity(0.9) : Color.white.opacity(0.14))
                        )
                    }
                }
                
                Spacer(minLength: 4)
                
                Text(hymn.title)
                    .font(TVStyle.titleFont(size: 24))
                    .foregroundStyle(Color.white)
                    .lineLimit(1)
                
                if let snippet = snippet, !snippet.isEmpty {
                    Text(snippet)
                        .font(TVStyle.verseFont(size: 18))
                        .foregroundStyle(isFocused ? Color.white.opacity(0.9) : Color.white.opacity(0.55))
                        .lineLimit(2)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, minHeight: 160, maxHeight: 160, alignment: .topLeading)
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
