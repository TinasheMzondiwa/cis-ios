//
//  ChristInSongApp.swift
//  Shared
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

@main
struct ChristInSongApp: App {
    var data = HymnalAppData()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(data)
        }
    }
}


struct ChristInSongApp_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
