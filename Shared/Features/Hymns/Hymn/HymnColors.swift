//
//  HymnColors.swift
//  iOS
//
//  Created by Tinashe Mzondiwa on 2026-04-12.
//

import Foundation
import SwiftUI

struct HymnColors {
    let scheme: ColorScheme

    var background: Color {
        Color(.systemBackground)
    }

    var onBackground: Color {
        Color.primary
    }

    var secondaryContainer: Color {
        scheme == .dark ? Color(hex: 0x53452A) : Color(hex: 0xD1E8D5)
    }

    var onSecondaryContainer: Color {
        scheme == .dark ? Color(hex: 0xF5E0BB) : Color(hex: 0x0C1F13)
    }

    var surfaceVariant: Color {
        scheme == .dark ? Color(hex: 0x4D4639) : Color(hex: 0xDCE5DB)
    }

    var onSurfaceVariant: Color {
        scheme == .dark ? Color(hex: 0xD0C5B4) : Color(hex: 0x414942)
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}
