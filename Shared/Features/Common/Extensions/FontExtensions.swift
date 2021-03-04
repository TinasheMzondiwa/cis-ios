//
//  FontExtensions.swift
//  ChristInSong
//
//  Created by Tinashe  on 2021/03/03.
//

import Foundation
import SwiftUI

extension View {
    func headLineStyle(selected: Bool = true) -> some View {
        return self.modifier(FontModifier(style: .headline))
            .foregroundColor(Color.primary.opacity(selected ? 1 : 0.7))
    }
    
    func subHeadLineStyle() -> some View {
        return self.modifier(FontModifier(style: .subheadline))
            .foregroundColor(.secondary)
    }
    
    func footNoteStyle() -> some View {
        return self.modifier(FontModifier(style: .footnote))
            .foregroundColor(.secondary)
    }
}

struct FontModifier: ViewModifier {
    let style: Font.TextStyle
    func body(content: Content) -> some View {
        content
            .font(.system(style, design: .rounded))

    }
}
