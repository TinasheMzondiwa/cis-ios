//
//  AnalyticsManager.swift
//  ChristInSong
//
//  Created by Tinashe Mzondiwa on 2026-06-05.
//

import Foundation
#if !os(tvOS)
import FirebaseAnalytics
#endif

final class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    /// Log a custom event with optional parameters
    /// - Parameters:
    ///   - name: The name of the event (e.g. "read_chapter")
    ///   - parameters: A dictionary of parameters (e.g. ["book": "Genesis", "chapter": 1])
    func logEvent(_ name: String, parameters: [String: Any]? = nil) {
        #if DEBUG || os(tvOS)
        print("Analytics Event: \(name), Parameters: \(String(describing: parameters))")
        #else
        Analytics.logEvent(name, parameters: parameters)
        #endif
    }
    
    /// Log a screen view manually
    /// - Parameters:
    ///   - name: The name of the screen (e.g. "ReadUIView")
    func logScreen(name: String) {
        #if DEBUG || os(tvOS)
        print("Analytics Screen: \(name)")
        #else
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: name,
        ])
        #endif
    }
}
