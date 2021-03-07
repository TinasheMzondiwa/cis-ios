//
//  CustomStyles.swift
//  iOS
//
//  Created by Tinashe  on 2021/03/07.
//

import Foundation
import SwiftUI

extension View {
    func navButtonStyle() -> some View {
        return self.modifier(SfSymbolModifier())
    }
}

struct SfSymbolModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.all, 12)
            .background(Color.white.opacity(0.1))
            .clipShape(Circle())
    }
}
