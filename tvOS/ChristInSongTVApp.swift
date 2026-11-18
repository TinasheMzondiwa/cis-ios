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
    }
    
    var body: some Scene {
        WindowGroup {
            TVRootView()
                .environmentObject(viewModel)
                .environmentObject(tunePlayer)
                .tint(Color.white)
        }
    }
}
