//
//  BannerManager.swift
//  ChristInSong
//
//  Created by Tinashe Mzondiwa on 2026-06-04.
//

import Foundation
import SwiftUI
import FirebaseRemoteConfig

@MainActor
class BannerManager: ObservableObject {
    static let shared = BannerManager()
    private static let showSupportBannerKey = "cfg_show_support_banner"
    
    @Published var shouldShowRemoteBanner: Bool = false
    @AppStorage("hasDismissedSupportBanner") private var hasDismissed: Bool = false
    
    // Final computed property to determine if the banner actually renders
    var isBannerVisible: Bool {
        shouldShowRemoteBanner && !hasDismissed
    }
    
    private init() {
        configureRemoteConfig()
    }
    
    private func configureRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        // Reduce fetch interval for testing if needed, default is 12 hours
        settings.minimumFetchInterval = 3600
        remoteConfig.configSettings = settings
        
        // Set default values
        remoteConfig.setDefaults([Self.showSupportBannerKey: false as NSObject])
    }
    
    func fetchBannerStatus() async {
        let remoteConfig = RemoteConfig.remoteConfig()
        do {
            let status = try await remoteConfig.fetchAndActivate()
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                self.shouldShowRemoteBanner = remoteConfig[Self.showSupportBannerKey].boolValue
            }
        } catch {
            print("Error fetching Firebase Remote Config: \(error.localizedDescription)")
        }
    }
    
    func dismissBanner() {
        hasDismissed = true
        // Instantly triggers UI updates since isBannerVisible depends on it
        objectWillChange.send()
    }
}
