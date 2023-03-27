//
//  ChristInSongApp.swift
//  Shared
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

//@main
//struct ChristInSongApp: App {
//
//    let viewModel: CISAppViewModel
//
//    init() {
//        let store = CISCoreDataStore()
//        viewModel = CISAppViewModel(store: store)
//    }
//
//    var body: some Scene {
//        WindowGroup {
//            TabView {
//                HymnsView()
//                    .tabItem {
//                        NavLabel(item: NavItem.hymns)
//                    }
//                    .tag(0)
//                CollectionsView()
//                    .tabItem { NavLabel(item: NavItem.collections)
//                    }
//                    .tag(1)
//                SupportView()
//                    .tabItem {
//                        NavLabel(item: NavItem.support)
//                    }
//                    .tag(2)
//                InfoView()
//                    .tabItem {
//                        NavLabel(item: NavItem.info)
//                    }
//                    .tag(3)
//            }
//            .environmentObject(viewModel)
//        }
//    }
//}

// MARK: - Uncomment this to test compatibility
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
