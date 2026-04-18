//
//  SwiftUi+Font.swift
//  iOS
//
//  Created by Tinashe Mzondiwa on 2026-04-18.
//

import SwiftUI

extension Font.TextStyle {
    /// Provides a common CGFloat size for each Font.TextStyle.
    /// This can be useful for consistent sizing when working with custom fonts
    /// or when you need explicit size values based on SwiftUI's text styles.
    var size: CGFloat {
        switch self {
        case .largeTitle: return 34
        case .title: return 30
        case .title2: return 22
        case .title3: return 20
        case .headline: return 18
        case .body: return 16
        case .callout: return 15
        case .subheadline: return 14
        case .footnote: return 13
        case .caption: return 12
        case .caption2: return 11
        @unknown default:
            // Provides a fallback size for any future text styles introduced by Apple
            // that are not explicitly handled above.
            print("Warning: Unknown Font.TextStyle encountered. Returning default size.")
            return 8
        }
    }
}

enum CustomFont : String {
    case regular = "EBGaramond-Regular"
    case medium = "EBGaramond-Medium"
    case italic = "EBGaramond-Italic"
    case boldItalic = "EBGaramond-BoldItalic"
    case bold = "EBGaramond-Bold"
    case semiBold = "EBGaramond-SemiBold"
    case extraBold = "EBGaramond-ExtraBold"
    
    init(weight: Font.Weight) {
        switch(weight) {
        case .regular: self = .regular
        case .medium: self = .medium
        case .semibold: self = .semiBold
        case .thin: self = .italic
        case .black: self = .extraBold
        case .bold: self = .bold
        default: self = .regular
        }
    }
}

enum AppTypeface: String, CaseIterable {
    case baskerville = "Baskerville"
    case cormorantGaramond = "Cormorant Garamond"
    case garamond = "EB Garamond"
    case googleSans = "Google Sans"
    case lato = "Lato"
    case newsreader = "Newsreader"
    case sfRounded = "SF Rounded"
    
    static let defaultTypeface = AppTypeface.garamond
    
    /// Maps the display name to the PostScript base name of your font files
    private var fontBaseName: String {
        switch self {
        case .baskerville: return "LibreBaskerville"
        case .cormorantGaramond : return "CormorantGaramond"
        case .garamond: return "EBGaramond"
        case .googleSans: return "GoogleSans"
        case .lato: return "Lato"
        case .newsreader: return "Newsreader"
        case .sfRounded: return "System"
        }
    }
    
    /// Logic to determine the correct weight suffix for your font files
    private func suffix(for weight: Font.Weight, italic: Bool) -> String {
        let weightStr: String
        switch weight {
        case .regular: weightStr = "Regular"
        case .medium:  weightStr = "Medium"
        case .semibold: weightStr = "SemiBold"
        case .bold:    weightStr = "Bold"
        case .black:
            switch self {
            case .garamond: weightStr = "ExtraBold"
            case .lato, .newsreader: weightStr = "Black"
            default: weightStr = "Bold"
            }
        default:       weightStr = "Regular"
        }
        
        if weightStr == "Regular" && italic {
            // There is no "RegularItalic"
            return "Italic"
        }
        
        return italic ? "\(weightStr)Italic" : weightStr
    }
    
    /// The primary function to use in your SwiftUI Views
    func font(size: Double, weight: Font.Weight = .regular, italic: Bool = false) -> Font {
        if self == .sfRounded {
            var font = Font.system(size: CGFloat(size), weight: weight, design: .rounded)
            if italic {
                font = font.italic()
            }
            return font
        }
        
        let styleSuffix = suffix(for: weight, italic: italic)
        let fullFontName = "\(self.fontBaseName)-\(styleSuffix)"
        
        return Font.custom(fullFontName, size: CGFloat(size))
    }
}
