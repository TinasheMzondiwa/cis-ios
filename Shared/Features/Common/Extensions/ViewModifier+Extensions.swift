//
//  ViewModifier+Extensions.swift
//  ChristInSong
//
//  Created by George Nyakundi on 19/06/2022.
//

import SwiftUI

#if !os(tvOS)
struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}
#else
struct ResignKeyboardOnDragGesture: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}
#endif
