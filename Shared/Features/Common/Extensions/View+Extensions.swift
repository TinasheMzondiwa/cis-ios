//
//  View+Extensions.swift
//  ChristInSong
//
//  Created by George Nyakundi on 19/06/2022.
//

import SwiftUI

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        modifier(ResignKeyboardOnDragGesture())
    }
}
