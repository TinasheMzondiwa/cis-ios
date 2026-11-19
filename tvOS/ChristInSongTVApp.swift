//
//  ChristInSongTVApp.swift
//  tvOS
//

import SwiftUI

@main
struct ChristInSongTVApp: App {
    @StateObject private var viewModel: CISAppViewModel
    @StateObject private var tunePlayer: TunePlayer
    
    init() {
        let store = CISCoreDataStore()
        _viewModel = StateObject(wrappedValue: CISAppViewModel(store: store))
        _tunePlayer = StateObject(wrappedValue: TunePlayer())
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(white: 1.0, alpha: 0.75)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(white: 1.0, alpha: 0.75)]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().tintColor = .white
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .black
    }
    
    var body: some Scene {
        WindowGroup {
            TVRootView()
                .environmentObject(viewModel)
                .environmentObject(tunePlayer)
        }
    }
}
