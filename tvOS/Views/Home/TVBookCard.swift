//
//  TVBookCard.swift
//  tvOS
//

import SwiftUI

struct TVBookCard: View {
    let book: StoreBook
    let hymnCount: Int
    let action: () -> Void
    
    private var isSDAH: Bool {
        book.key == "sdah"
    }
    
    // Distinct sacred cover color per hymnal
    private var coverColor: Color {
        switch book.key {
        case "sdah":
            return Color(red: 0.36, green: 0.10, blue: 0.14) // Deep Royal Maroon
        case "cis":
            return Color(red: 0.10, green: 0.18, blue: 0.32) // Deep Navy
        case "tswana", "sotho":
            return Color(red: 0.10, green: 0.28, blue: 0.20) // Deep Forest Green
        case "chichewa", "tonga":
            return Color(red: 0.32, green: 0.16, blue: 0.08) // Warm Leather Amber
        case "ndebele", "shona":
            return Color(red: 0.22, green: 0.12, blue: 0.30) // Regal Purple
        default:
            return Color(red: 0.14, green: 0.16, blue: 0.22) // Classic Midnight Obsidian
        }
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Book Base with Spine & Page Edges
                RoundedRectangle(cornerRadius: 14)
                    .fill(coverColor)
                
                // Gilded Page Edges on Right Side
                HStack {
                    Spacer()
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.85, green: 0.78, blue: 0.60),
                                    Color(red: 0.95, green: 0.90, blue: 0.75),
                                    Color(red: 0.75, green: 0.68, blue: 0.50)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 8)
                        .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 12,
                                topTrailingRadius: 12
                            )
                        )
                }
                
                // Spine Crease & Shadow on Left Edge
                HStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.black.opacity(0.45),
                                    Color.black.opacity(0.15),
                                    Color.white.opacity(0.08),
                                    Color.black.opacity(0.25)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 18)
                        .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 12,
                                bottomLeadingRadius: 12,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 0
                            )
                        )
                    Spacer()
                }
                
                // Gold Foil Embossed Frame & Cover Content with generous interior padding
                VStack(spacing: 12) {
                    VStack(spacing: 12) {
                        // Top Header: Language Tag & Tune Icon
                        HStack {
                            Text(book.language.uppercased())
                                .font(TVStyle.uiFont(size: 13, weight: .bold))
                                .tracking(2)
                                .foregroundStyle(TVStyle.accentGold)
                            
                            Spacer()
                            
                            if isSDAH {
                                Image(systemName: "music.note")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(TVStyle.accentGold)
                            }
                        }
                        
                        Spacer()
                        
                        // Sacred Emblem
                        Image(systemName: isSDAH ? "music.quarternote.3" : "books.vertical.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(TVStyle.accentGold.opacity(0.9))
                        
                        // Book Title (Serif Gold Lettering)
                        Text(book.title)
                            .font(TVStyle.titleFont(size: 23))
                            .foregroundStyle(Color.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                            .shadow(color: Color.black.opacity(0.6), radius: 4, x: 0, y: 2)
                        
                        Spacer()
                        
                        // Bottom: Hymn Count Stamp
                        Text(String(format: NSLocalizedString("Collections.HymnsCount", comment: ""), hymnCount))
                            .font(TVStyle.uiFont(size: 14, weight: .semibold))
                            .tracking(1)
                            .foregroundStyle(TVStyle.accentGold.opacity(0.9))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(TVStyle.accentGold.opacity(0.35), lineWidth: 1)
                    )
                }
                .padding(.leading, 22)
                .padding(.trailing, 14)
                .padding(.vertical, 14)
            }
            .frame(width: 220, height: 310)
        }
        .buttonStyle(.card)
    }
}
