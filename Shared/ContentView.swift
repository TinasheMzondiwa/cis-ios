//
//  ContentView.swift
//  Shared
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct ContentView: View {
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    @State private var selection = 0
    
    @ViewBuilder
    var body: some View {
        
        if (idiom == .phone) {
            TabView(selection: $selection) {
                HymnsView()
                    .tabItem {
                        Label("Hymns", systemImage: "music.note.list")
                            .accessibility(label: Text("Hymns"))
                    }
                    .tag(0)
                CollectionsView()
                    .tabItem {
                        Label("Collections", systemImage: "doc.plaintext")
                            .accessibility(label: Text("Collections"))
                    }
                    .tag(1)
                SupportView()
                    .tabItem {
                        Label("Support", systemImage: "hand.raised")
                            .accessibility(label: Text("Support"))
                    }
                    .tag(2)
                InfoView()
                    .tabItem {
                        Label("Info", systemImage: "info.circle")
                            .accessibility(label: Text("Info"))
                    }
                    .tag(3)
            }
        } else {
            NavigationView {
                #if os(iOS)
                    sidebarContent
                        .navigationTitle("")
                #else
                    sidebarContent
                        .frame(minWidth: 200, idealWidth: 250, maxWidth: 300)
                #endif
               
                HymnsView()
            }
        }
        
    }
    
    var sidebarContent: some View {
        List {
            NavigationLink(destination: HymnsView()) {
                Label("Hymns", systemImage: "music.note.list")
            }
            
            NavigationLink(destination: CollectionsView()) {
                Label("Collections", systemImage: "doc.plaintext")
            }
           
            NavigationLink(destination: SupportView()) {
                Label("Support", systemImage: "hand.raised")
            }
            
            NavigationLink(destination: InfoView()) {
                Label("Info", systemImage: "info.circle")
            }
            
        }
        .listStyle(SidebarListStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(HymnalAppData())
    }
}
