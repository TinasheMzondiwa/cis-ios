//
//  ContentView.swift
//  Shared
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: CISAppViewModel
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    @State private var selection = 0
    
    @AppStorage("lastSeenWhatsNewVersion") private var lastSeenWhatsNewVersion: String = ""
    @State private var showingWhatsNew = false
    private let currentVersion = Bundle.versionString
    
    @ViewBuilder
    var body: some View {
        if viewModel.isLoadingStore {
            ShimmerPlaceholderView()
        } else {
            mainView
                .onAppear {
                    if lastSeenWhatsNewVersion != currentVersion {
                        let items = ChangelogParser.getWhatsNewItems(for: currentVersion)
                        
                        if !items.isEmpty {
                            showingWhatsNew = true
                        } else {
                            lastSeenWhatsNewVersion = currentVersion
                        }
                    }
                }
                .sheet(isPresented: $showingWhatsNew, onDismiss: {
                    lastSeenWhatsNewVersion = currentVersion
                }) {
                    WhatsNewView(isPresented: $showingWhatsNew, navigateToSupport: {
                        selection = 2
                    }, items: ChangelogParser.getWhatsNewItems(for: currentVersion))
                }
        }
    }
    
    @ViewBuilder
    private var mainView: some View {
        
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
        let selectionBinding = Binding<Int?>(get: { self.selection }, set: { if let v = $0 { self.selection = v } })
        return List {
            NavigationLink(destination: HymnsView(), tag: 0, selection: selectionBinding) {
                NavLabel(item: NavItem.hymns)
            }
            
            NavigationLink(destination: CollectionsView(), tag: 1, selection: selectionBinding) {
                NavLabel(item: NavItem.collections)
            }
           
            NavigationLink(destination: SupportView(), tag: 2, selection: selectionBinding) {
                NavLabel(item: NavItem.support)
            }
            
            NavigationLink(destination: InfoView(), tag: 3, selection: selectionBinding) {
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
