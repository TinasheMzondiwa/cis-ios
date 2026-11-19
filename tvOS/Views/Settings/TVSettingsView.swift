//
//  TVSettingsView.swift
//  tvOS
//

import SwiftUI

// MARK: - TVSettingsView
struct TVSettingsView: View {
    @AppStorage("tv_background_theme") private var themeRaw: String = TVTheme.pine.rawValue
    
    private var currentTheme: TVTheme {
        TVTheme(rawValue: themeRaw) ?? .pine
    }
    
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 48) {
                // Header Bar with Title
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(LocalizedStringKey("Settings.Title"))
                            .font(TVStyle.titleFont(size: 46))
                            .foregroundStyle(Color.white)
                        
                        Text("Customize your worship and reading experience")
                            .font(TVStyle.uiFont(size: 20, weight: .regular))
                            .foregroundStyle(Color.white.opacity(0.6))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, TVStyle.horizontalPadding)
                .padding(.top, 40)
                
                // Section 1: Background Themes
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 12) {
                        Image(systemName: "paintpalette.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.white.opacity(0.85))
                        
                        Text("Background Theme")
                            .font(TVStyle.uiFont(size: 28, weight: .bold))
                            .foregroundStyle(Color.white)
                    }
                    
                    // 3 Theme Cards
                    HStack(spacing: 32) {
                        ForEach(TVTheme.allCases) { theme in
                            TVThemeCard(
                                theme: theme,
                                isSelected: currentTheme == theme
                            ) {
                                withAnimation(.easeInOut(duration: 0.35)) {
                                    themeRaw = theme.rawValue
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, TVStyle.horizontalPadding)
                
                Divider()
                    .background(Color.white.opacity(0.12))
                    .padding(.horizontal, TVStyle.horizontalPadding)
                
                // Section 2: About, Tagline, Version & Credits
                VStack(spacing: 24) {
                    // Emblem / Icon
                    Image(systemName: "music.quarternote.3")
                        .font(.system(size: 42))
                        .foregroundStyle(Color.white.opacity(0.9))
                    
                    // Tagline
                    Text("“Sing, learn, and grow in faith through timeless hymns.”")
                        .font(TVStyle.chorusFont(size: 32))
                        .foregroundStyle(Color.white.opacity(0.95))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 900)
                    
                    // Version & Build
                    Text(String(format: NSLocalizedString("Settings.Version", comment: ""), appVersion, buildNumber))
                        .font(TVStyle.uiFont(size: 18, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.55))
                    
                    // Dedication / Author
                    HStack(spacing: 6) {
                        Text("Made with")
                            .font(TVStyle.uiFont(size: 19, weight: .regular))
                            .foregroundStyle(Color.white.opacity(0.75))
                        
                        Image(systemName: "heart.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(Color(red: 0.95, green: 0.25, blue: 0.35))
                        
                        Text("by Tinashe Mzondiwa")
                            .font(TVStyle.uiFont(size: 19, weight: .semibold))
                            .foregroundStyle(Color.white.opacity(0.9))
                    }
                    .padding(.top, 4)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, TVStyle.horizontalPadding)
                .padding(.bottom, 60)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tvAmbientBackground()
    }
}

// MARK: - TVThemeCard
private struct TVThemeCard: View {
    let theme: TVTheme
    let isSelected: Bool
    let action: () -> Void
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 14) {
                // Mini Visual Gradient Preview
                ZStack(alignment: .topTrailing) {
                    themePreview
                        .frame(height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 26))
                            .foregroundStyle(Color.white)
                            .background(Circle().fill(Color.black.opacity(0.4)))
                            .padding(10)
                    }
                }
                
                // Titles
                VStack(alignment: .leading, spacing: 4) {
                    Text(theme.title)
                        .font(TVStyle.uiFont(size: 22, weight: .bold))
                        .foregroundStyle(Color.white)
                    
                    Text(theme.subtitle)
                        .font(TVStyle.uiFont(size: 16, weight: .regular))
                        .foregroundStyle(isFocused ? Color.white.opacity(0.9) : Color.white.opacity(0.6))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(isSelected ? 0.12 : 0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        isSelected ? Color.white.opacity(0.8) : Color.white.opacity(0.15),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(.card)
        .focused($isFocused)
    }
    
    @ViewBuilder
    private var themePreview: some View {
        switch theme {
        case .slate:
            ZStack {
                Color(red: 6/255, green: 9/255, blue: 17/255)
                
                Circle()
                    .fill(Color(red: 135/255, green: 65/255, blue: 82/255).opacity(0.45))
                    .frame(width: 80, height: 80)
                    .offset(x: -60, y: -30)
                    .blur(radius: 20)
                
                Ellipse()
                    .fill(Color(red: 20/255, green: 82/255, blue: 145/255).opacity(0.6))
                    .frame(width: 120, height: 90)
                    .offset(x: 10, y: 0)
                    .blur(radius: 24)
                
                Circle()
                    .fill(Color(red: 90/255, green: 125/255, blue: 160/255).opacity(0.35))
                    .frame(width: 70, height: 70)
                    .offset(x: 60, y: -25)
                    .blur(radius: 18)
            }
        case .pine:
            ZStack {
                Color(red: 4/255, green: 9/255, blue: 6/255)
                
                Circle()
                    .fill(Color(red: 155/255, green: 115/255, blue: 32/255).opacity(0.40))
                    .frame(width: 80, height: 80)
                    .offset(x: -60, y: -30)
                    .blur(radius: 20)
                
                Ellipse()
                    .fill(Color(red: 16/255, green: 52/255, blue: 30/255).opacity(0.7))
                    .frame(width: 120, height: 90)
                    .offset(x: 10, y: 0)
                    .blur(radius: 24)
                
                Circle()
                    .fill(Color(red: 135/255, green: 105/255, blue: 40/255).opacity(0.35))
                    .frame(width: 70, height: 70)
                    .offset(x: 60, y: -25)
                    .blur(radius: 18)
            }
        case .black:
            ZStack {
                Color.black
                
                LinearGradient(
                    colors: [Color.white.opacity(0.04), Color.clear],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
}
