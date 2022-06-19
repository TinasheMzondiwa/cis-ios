//
//  ViewModifier+Extensions.swift
//  ChristInSong
//
//  Created by George Nyakundi on 19/06/2022.
//

import SwiftUI

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}
