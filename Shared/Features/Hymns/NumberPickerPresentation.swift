//
//  NumberPickerPresentation.swift
//  ChristInSong
//

import SwiftUI

struct NumberPickerPresentation : ViewModifier {
    @Binding var isPresented: Bool
    
    let maxNumber: Int
    let onSelect: (Int) -> Void
    
    func body(content: Content) -> some View {
        content
            .adaptiveSheet(isPresent: $isPresented) {
                ViewThatFits(in: .vertical) {
                    NumberPickerView(maxNumber: maxNumber, onSelect: onSelect)
                        .presentationDragIndicator(.visible)
                }
            }
    }
}
