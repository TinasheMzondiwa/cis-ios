//
//  UIApplication+Extensions.swift
//  ChristInSong
//
//  Created by George Nyakundi on 19/06/2022.
//

import SwiftUI

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}
