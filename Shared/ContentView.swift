//
//  ContentView.swift
//  Shared
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: CISAppViewModel
    @EnvironmentObject var tunePlayer: TunePlayer
    
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
            if #available(iOS 18.0, *) {
                TabView(selection: $selection) {
                    Tab(NavItem.hymns.title, systemImage: NavItem.hymns.icon, value: .hymns) {
                        HymnsView(navigateToSupport: {
                            selection = .support
                        })
                    }
                    
                    Tab("Search", systemImage: "magnifyingglass", value: .search, role: .search) {
                        SearchView()
                    }
                    
                    Tab(NavItem.collections.title, systemImage: NavItem.collections.icon, value: .collections) {
                        CollectionsView()
                    }
                    
                    Tab(NavItem.support.title, systemImage: NavItem.support.icon, value: .support) {
                        SupportView()
                    }
                    
                    Tab(NavItem.info.title, systemImage: NavItem.info.icon, value: .info) {
                        InfoView()
                    }
                }
                .tabBarMinimizeBehavior(.onScrollDown)
                .tabViewStyle(.sidebarAdaptable)
                .applyMiniPlayerAccessory(hasTrack: tunePlayer.hasTrack)
            } else {
                TabView(selection: $selection) {
                    HymnsView(navigateToSupport: {
                        selection = .support
                    })
                        .tabItem {
                            NavLabel(item: NavItem.hymns)
                        }
                        .tag(TabItem.hymns)
                    CollectionsView()
                        .tabItem {
                            NavLabel(item: NavItem.collections)
                        }
                        .tag(TabItem.collections)
                    SupportView()
                        .tabItem {
                            NavLabel(item: NavItem.support)
                        }
                        .tag(TabItem.support)
                    InfoView()
                        .tabItem {
                            NavLabel(item: NavItem.info)
                        }
                        .tag(TabItem.info)
                }
                .applyMiniPlayerAccessory(hasTrack: tunePlayer.hasTrack)
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
                case .hymns: HymnsView(navigateToSupport: {
                    selection = .support
                })
                case .search:
                    if #available(iOS 18.0, *) {
                        SearchView()
                    } else {
                        EmptyView()
                    }
                case .collections: CollectionsView()
                case .support: SupportView()
                case .info: InfoView()
                }
            }
            .safeAreaInset(edge: .bottom) {
                if tunePlayer.hasTrack {
                    HStack {
                        Spacer()
                        MiniPlayerView()
                            .frame(maxWidth: 500)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
                            )
                            .shadow(color: Color.black.opacity(0.08), radius: 10, y: 5)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.spring(), value: tunePlayer.hasTrack)
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
            
            if #available(iOS 18.0, *) {
                NavigationLink(value: TabItem.search) {
                    NavLabel(item: NavItem.search)
                }
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
    case search = 1
    case collections = 2
    case support = 3
    case info = 4
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CISAppViewModel.sample)
    }
}
#endif
