//
//  UIApplication+Extensions.swift
//  ChristInSong
//
//  Created by George Nyakundi on 19/06/2022.
//

import SwiftUI

extension UIApplication {
    func endEditing(_ force: Bool) {
        // Iterate through connected scenes to find the key window and end editing
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.compactMap { $0 as? UIWindowScene }

        // Prefer the foreground active scene, but fall back to any scene
        let preferredScene = windowScenes.first(where: { $0.activationState == .foregroundActive }) ?? windowScenes.first

        let keyWindow = preferredScene?.windows.first(where: { $0.isKeyWindow })
        keyWindow?.endEditing(force)
    }
}
