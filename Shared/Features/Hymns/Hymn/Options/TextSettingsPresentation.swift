//
//  TextSettingsPresentation.swift
//  iOS
//
//  Created by Tinashe Mzondiwa on 2026-04-19.
//

import SwiftUI

struct TextSettingsPresentation : ViewModifier {
    @Binding var isPresented: Bool
    
    let isCompact: Bool
    
    func body(content: Content) -> some View {
        content
            .adaptiveSheet(isPresent: isCompact ? $isPresented : .constant(false)) {
                ViewThatFits(in: .vertical) {
                    TextSettingsView()
                        .presentationDragIndicator(.visible)
                }
            }
            .popover(isPresented: isCompact ? .constant(false) : $isPresented) {
                TextSettingsView()
                    .frame(width: 350, height: 300)
            }
    }
    
}
