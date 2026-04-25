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
            NavigationSplitView {
                #if os(iOS)
                    SidebarView(selection: $selection)
                        .navigationTitle("")
                #else
                    SidebarView(selection: $selection)
                        .frame(minWidth: 200, idealWidth: 250, maxWidth: 300)
                #endif
            } detail: {
                switch selection {
                case 0: HymnsView()
                case 1: CollectionsView()
                case 2: SupportView()
                case 3: InfoView()
                default: HymnsView()
                }
            }
        }
    }
}

struct SidebarView: View {
    @Binding var selection: Int
    
    var body: some View {
        let selectionBinding = Binding<Int?>(
            get: { selection },
            set: { if let v = $0 { selection = v } }
        )
        
        List(selection: selectionBinding) {
            NavigationLink(value: 0) {
                NavLabel(item: NavItem.hymns)
            }
            
            NavigationLink(value: 1) {
                NavLabel(item: NavItem.collections)
            }
           
            NavigationLink(value: 2) {
                NavLabel(item: NavItem.support)
            }
            
            NavigationLink(value: 3) {
                NavLabel(item: NavItem.info)
            }
        }
        .listStyle(SidebarListStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CISAppViewModel(store: StoreManager.shared as! Store))
    }
}
