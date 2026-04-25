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
    
    @State private var selection: TabItem = .hymns
    
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
                        selection = .support
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
                    .tag(TabItem.hymns.rawValue)
                CollectionsView()
                    .tabItem {
                        NavLabel(item: NavItem.collections)
                    }
                    .tag(TabItem.collections.rawValue)
                SupportView()
                    .tabItem {
                        NavLabel(item: NavItem.support)
                    }
                    .tag(TabItem.support.rawValue)
                InfoView()
                    .tabItem {
                        NavLabel(item: NavItem.info)
                    }
                    .tag(TabItem.info.rawValue)
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
                case .hymns: HymnsView()
                case .collections: CollectionsView()
                case .support: SupportView()
                case .info: InfoView()
                }
            }
        }
    }
}

struct SidebarView: View {
    @Binding var selection: TabItem
    
    var body: some View {
        let selectionBinding = Binding<TabItem?>(
            get: { selection },
            set: { if let v = $0 { selection = v } }
        )
        
        List(selection: selectionBinding) {
            NavigationLink(value: TabItem.hymns) {
                NavLabel(item: NavItem.hymns)
            }
            
            NavigationLink(value: TabItem.collections) {
                NavLabel(item: NavItem.collections)
            }
            
            NavigationLink(value: TabItem.support) {
                NavLabel(item: NavItem.support)
            }
            
            NavigationLink(value: TabItem.info) {
                NavLabel(item: NavItem.info)
            }
        }
        .listStyle(SidebarListStyle())
    }
}

enum TabItem: Int, CaseIterable {
    case hymns = 0
    case collections = 1
    case support = 2
    case info = 3
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CISAppViewModel.sample)
    }
}
