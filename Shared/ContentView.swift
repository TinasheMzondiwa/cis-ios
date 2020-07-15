//
//  ContentView.swift
//  Shared
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

#if os(macOS)
extension View {
    func navigationBarTitle(title: String) -> some View {
        self
    }
}
#endif

struct ContentView: View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            HymnsView()
                .tabItem {
                    VStack {
                        Image(systemName: "music.note.list")
                        Text("Hymns")
                    }
                }
                .tag(0)
            CollectionsView()
                .tabItem {
                    VStack {
                        Image(systemName: "doc.plaintext")
                        Text("Collections")
                    }
                }
                .tag(1)
            SupportView()
                .tabItem {
                    VStack {
                        Image(systemName: "hand.raised")
                        Text("Support")
                    }
                }
                .tag(2)
            InfoView()
                .tabItem {
                    VStack {
                        Image(systemName: "info.circle")
                        Text("Info")
                    }
                }
                .tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
