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
            .imageScale(.small)
            .foregroundColor(.primary)
            .padding(.all, 10)
            .background(Color.gray.opacity(0.1))
            .clipShape(Circle())
    }
}
