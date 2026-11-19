//
//  TVDailyScriptureCard.swift
//  tvOS
//
//

import SwiftUI

struct TVDailyScriptureCard: View {
    var scripture: TVScripture = TVScriptureCatalog.todayScripture()
    var isSabbath: Bool = TVScriptureCatalog.isSabbathHours()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header: Category Badge
            HStack(spacing: 8) {
                Image(systemName: isSabbath ? "sparkles" : "quote.opening")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(isSabbath ? Color(red: 1.0, green: 0.85, blue: 0.4) : Color.white.opacity(0.7))
                
                Text(scripture.category.badgeTitle.uppercased())
                    .font(TVStyle.uiFont(size: 13, weight: .bold))
                    .tracking(1.4)
                    .foregroundStyle(isSabbath ? Color(red: 1.0, green: 0.85, blue: 0.4) : Color.white.opacity(0.7))
                
                Spacer()
                
                if isSabbath {
                    Text("Sabbath")
                        .font(TVStyle.uiFont(size: 11, weight: .semibold))
                        .foregroundStyle(Color(red: 1.0, green: 0.9, blue: 0.5))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color.yellow.opacity(0.18)))
                }
            }
            .padding(.bottom, 2)
            
            // Scripture Text
            Text("“\(scripture.text)”")
                .font(.system(size: 19, weight: .regular, design: .serif).italic())
                .lineSpacing(4)
                .foregroundStyle(Color.white.opacity(0.92))
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(4)
            
            // Reference
            HStack {
                Spacer()
                Text(scripture.reference)
                    .font(TVStyle.uiFont(size: 14, weight: .semibold))
                    .foregroundStyle(isSabbath ? Color(red: 1.0, green: 0.88, blue: 0.5) : Color.white.opacity(0.75))
            }
            .padding(.top, 2)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 18)
        .frame(maxWidth: 520, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: isSabbath ? [
                            Color(red: 0.15, green: 0.13, blue: 0.08).opacity(0.65),
                            Color(red: 0.08, green: 0.10, blue: 0.15).opacity(0.75)
                        ] : [
                            Color.white.opacity(0.10),
                            Color.white.opacity(0.04)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(
                    isSabbath ?
                        LinearGradient(
                            colors: [Color.yellow.opacity(0.45), Color.yellow.opacity(0.10)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [Color.white.opacity(0.25), Color.white.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(0.35), radius: 16, y: 8)
    }
}

// MARK: - Previews
#Preview("Daily Verse") {
    ZStack {
        TVAmbientBackground()
        
        TVDailyScriptureCard(
            scripture: TVScripture(
                id: "preview_1",
                text: "I will sing unto the Lord as long as I live: I will sing praise to my God while I have my being.",
                reference: "Psalm 104:33",
                category: .praise
            ),
            isSabbath: false
        )
        .padding(40)
    }
}

#Preview("Sabbath Praise") {
    ZStack {
        TVAmbientBackground()
        
        TVDailyScriptureCard(
            scripture: TVScripture(
                id: "preview_2",
                text: "It is a good thing to give thanks unto the Lord, and to sing praises unto Thy name, O Most High.",
                reference: "Psalm 92:1",
                category: .sabbath
            ),
            isSabbath: true
        )
        .padding(40)
    }
}
