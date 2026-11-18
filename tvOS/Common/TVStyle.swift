//
//  TVStyle.swift
//  tvOS
//

import SwiftUI

enum TVStyle {
    // Sizing constants for 10-foot viewing experience
    static let horizontalPadding: CGFloat = 80
    static let verticalPadding: CGFloat = 40
    static let cardCornerRadius: CGFloat = 18
    static let pillCornerRadius: CGFloat = 12
    
    // Ambient Worship Colors
    static let accentGold = Color(red: 245/255, green: 196/255, blue: 75/255)
    static let deepBackground = Color(red: 10/255, green: 12/255, blue: 18/255)
    static let cardBackground = Color.white.opacity(0.06)
    static let cardBorder = Color.white.opacity(0.10)
    static let chorusBackground = Color(red: 245/255, green: 196/255, blue: 75/255).opacity(0.08)
    static let chorusBorder = Color(red: 245/255, green: 196/255, blue: 75/255).opacity(0.25)
    
    // Typography helpers using project's EB Garamond or system serif/rounded fonts
    static func titleFont(size: CGFloat = 48) -> Font {
        AppTypeface.garamond.font(size: Double(size), weight: .bold)
    }
    
    static func verseFont(size: CGFloat = 38) -> Font {
        AppTypeface.garamond.font(size: Double(size), weight: .regular)
    }
    
    static func chorusFont(size: CGFloat = 38) -> Font {
        AppTypeface.garamond.font(size: Double(size), weight: .regular, italic: true)
    }
    
    static func uiFont(size: CGFloat = 24, weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}

// MARK: - Ambient Sacred Background
struct TVAmbientBackground: View {
    var body: some View {
        ZStack {
            TVStyle.deepBackground.ignoresSafeArea()
            
            // Soft atmospheric glow at top center
            RadialGradient(
                colors: [
                    Color(red: 30/255, green: 38/255, blue: 60/255).opacity(0.7),
                    Color(red: 18/255, green: 22/255, blue: 34/255).opacity(0.3),
                    Color.clear
                ],
                center: .top,
                startRadius: 40,
                endRadius: 900
            )
            .ignoresSafeArea()
        }
    }
}

extension View {
    func tvAmbientBackground() -> some View {
        self.background(TVAmbientBackground())
    }
}
