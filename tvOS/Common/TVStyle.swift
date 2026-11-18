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
    static let accent = Color.white
    static let accentGold = Color.white
    static let deepBackground = Color(red: 10/255, green: 14/255, blue: 24/255)
    static let cardBackground = Color.white.opacity(0.06)
    static let cardBorder = Color.white.opacity(0.12)
    static let chorusBackground = Color.white.opacity(0.12)
    static let chorusBorder = Color.white.opacity(0.30)
    
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

// MARK: - Ambient Apple-Style Fluid Mesh Background
struct TVAmbientBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Base atmospheric deep navy
            Color(red: 8/255, green: 12/255, blue: 22/255)
                .ignoresSafeArea()
            
            // Fluid Apple-style ambient color mesh
            GeometryReader { proxy in
                let w = proxy.size.width
                let h = proxy.size.height
                
                ZStack {
                    // 1. Top-Left: Warm Coral / Rose Orb
                    Circle()
                        .fill(Color(red: 215/255, green: 110/255, blue: 135/255).opacity(0.48))
                        .frame(width: w * 0.58, height: w * 0.58)
                        .position(x: animate ? w * 0.22 : w * 0.17, y: animate ? h * 0.24 : h * 0.18)
                        .blur(radius: 110)
                    
                    // 2. Top-Center: Electric Azure / Sky Blue Orb
                    Ellipse()
                        .fill(Color(red: 0/255, green: 148/255, blue: 235/255).opacity(0.60))
                        .frame(width: w * 0.68, height: h * 0.72)
                        .position(x: animate ? w * 0.53 : w * 0.47, y: animate ? h * 0.28 : h * 0.33)
                        .blur(radius: 120)
                    
                    // 3. Top-Right: Pearlescent / Pale Sky Mist Orb
                    Circle()
                        .fill(Color(red: 180/255, green: 210/255, blue: 238/255).opacity(0.45))
                        .frame(width: w * 0.52, height: w * 0.52)
                        .position(x: animate ? w * 0.83 : w * 0.77, y: animate ? h * 0.19 : h * 0.25)
                        .blur(radius: 110)
                    
                    // 4. Center-Lower: Luminous Cerulean / Aqua Body
                    Ellipse()
                        .fill(Color(red: 45/255, green: 140/255, blue: 225/255).opacity(0.52))
                        .frame(width: w * 0.78, height: h * 0.62)
                        .position(x: animate ? w * 0.47 : w * 0.53, y: animate ? h * 0.68 : h * 0.62)
                        .blur(radius: 130)
                }
                .drawingGroup()
            }
            .ignoresSafeArea()
            
            // Atmospheric Vignette & Contrast Scrim for Apple HIG Legibility
            LinearGradient(
                stops: [
                    .init(color: Color.black.opacity(0.18), location: 0.0),
                    .init(color: Color.clear, location: 0.28),
                    .init(color: Color.black.opacity(0.38), location: 0.75),
                    .init(color: Color.black.opacity(0.68), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

extension View {
    func tvAmbientBackground() -> some View {
        self.background(TVAmbientBackground())
    }
}
