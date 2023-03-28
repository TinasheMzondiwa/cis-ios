//
//  ChristInSongApp.swift
//  Shared
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

@main
struct ChristInSongApp: App {
    let viewModel: CISAppViewModel
    
    init() {
        let store = CISCoreDataStore()
        viewModel = CISAppViewModel(store: store)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}


struct ChristInSongApp_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}
