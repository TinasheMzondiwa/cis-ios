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
                    TabContentView(icon: "music.note.list", title: "Hymns")
                }
                .tag(0)
            CollectionsView()
                .tabItem {
                    TabContentView(icon: "doc.plaintext", title: "Collections")
                }
                .tag(1)
            SupportView()
                .tabItem {
                    TabContentView(icon: "hand.raised", title: "Support")
                }
                .tag(2)
            InfoView()
                .tabItem {
                    TabContentView(icon: "info.circle", title: "Info")
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

struct TabContentView: View {
    var icon: String
    var title: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
            Text(title)
        }
    }
}
