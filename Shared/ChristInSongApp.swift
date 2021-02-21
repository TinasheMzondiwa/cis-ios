//
//  ChristInSongApp.swift
//  Shared
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

@main
struct ChristInSongApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Environment(\.scenePhase) var scenePhase

    var data = HymnalAppData()
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(data)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }.onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}


struct ChristInSongApp_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
