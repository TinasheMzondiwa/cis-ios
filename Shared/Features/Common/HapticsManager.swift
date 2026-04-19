//
//  HapticsManager.swift
//  iOS
//
//  Created by Tinashe Mzondiwa on 2026-04-19.
//

import Foundation
import SwiftUI
import UIKit

enum HapticType {
    // Standard UI Interactions
    case buttonPress
    case toggleSwitch
    case gestureEnd
    
    // Notifications
    case success
    case warning
    case error
    
    // Physical Sensations
    case light
    case medium
    case heavy
    case soft
    case rigid
}

class HapticsManager {
    static let instance = HapticsManager()
    
    func trigger(_ type: HapticType) {
        switch type {
        case .buttonPress, .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
        case .toggleSwitch, .soft:
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.impactOccurred()
            
        case .gestureEnd, .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
        case .rigid:
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            generator.impactOccurred()
            
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
    }
}

