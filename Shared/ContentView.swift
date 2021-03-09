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
                        NavLabel(item: NavItem.hymns)
                    }
                    .tag(0)
                CollectionsView()
                    .tabItem {
                        NavLabel(item: NavItem.collections)
                    }
                    .tag(1)
                SupportView()
                    .tabItem {
                        NavLabel(item: NavItem.support)
                    }
                    .tag(2)
                InfoView()
                    .tabItem {
                        NavLabel(item: NavItem.info)
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
    
    private var sidebarContent: some View {
        List {
            NavigationLink(destination: HymnsView()) {
                NavLabel(item: NavItem.hymns)
            }
            
            NavigationLink(destination: CollectionsView()) {
                NavLabel(item: NavItem.collections)
            }
           
            NavigationLink(destination: SupportView()) {
                NavLabel(item: NavItem.support)
            }
            
            NavigationLink(destination: InfoView()) {
                NavLabel(item: NavItem.info)
            }
        }
        .listStyle(SidebarListStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
