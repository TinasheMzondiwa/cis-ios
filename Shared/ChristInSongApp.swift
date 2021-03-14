//
//  ChristInSongApp.swift
//  Shared
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

@main
struct ChristInSongApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }.onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        StoreManager.shared.startObserving()
        return true
    }
    func applicationWillTerminate(_ application: UIApplication) {
        StoreManager.shared.stopObserving()
    }
}


struct ChristInSongApp_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}
