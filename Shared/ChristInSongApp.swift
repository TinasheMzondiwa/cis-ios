//
//  ChristInSongApp.swift
//  Shared
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

@main
struct ChristInSongApp: App {

    let persistenceController = PersistenceController.shared
    let viewModel: CISAppViewModel

    init() {
        let store = CISCoreDataStore()
        viewModel = CISAppViewModel(store: store)
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                HymnsView()
                    .tabItem {
                        NavLabel(item: NavItem.hymns)
                    }
                CollectionsView()
                    .tabItem { NavLabel(item: NavItem.collections)
                    }
            }
            .environmentObject(viewModel)
        }
    }
}

// MARK: - Uncomment this to test compatibility
//@main
//struct ChristInSongApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//
//    @Environment(\.scenePhase) var scenePhase
//
//    let persistenceController = PersistenceController.shared
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//        }.onChange(of: scenePhase) { _ in
//            persistenceController.save()
//        }
//    }
//}


struct ChristInSongApp_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}
