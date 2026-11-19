//
//  TVRootView.swift
//  tvOS
//

import SwiftUI

struct TVRootView: View {
    @EnvironmentObject private var vm: CISAppViewModel
    @State private var selectedTab: TVTab = .home
    @State private var browseSelectedBook: StoreBook?
    
    enum TVTab: String, CaseIterable, Identifiable, Hashable {
        case home
        case search
        case browse
        case collections
        case settings
        
        var id: String { rawValue }
    }
    
    var body: some View {
        ZStack {
            if vm.isLoadingStore {
                TVSplashView()
                    .transition(.opacity)
            } else {
                if #available(tvOS 18.0, *) {
                    nativeSidebarView
                } else {
                    classicTabView
                }
            }
        }
        .animation(.easeInOut(duration: 0.45), value: vm.isLoadingStore)
    }
    
    @available(tvOS 18.0, *)
    @ViewBuilder
    private var nativeSidebarView: some View {
        TabView(selection: $selectedTab) {
            Tab(value: TVTab.home) {
                NavigationStack {
                    TVHomeView(
                        onNavigateToSearch: { selectedTab = .search },
                        onNavigateToBrowse: { book in
                            browseSelectedBook = book
                            selectedTab = .browse
                        }
                    )
                }
            } label: {
                Label(
                    LocalizedStringKey("Navigation.Home"),
                    image: selectedTab == .home ? "tv_home_fill" : "tv_home_outline"
                )
            }
            
            Tab(value: TVTab.search, role: .search) {
                NavigationStack {
                    TVSearchView()
                }
            } label: {
                Label(LocalizedStringKey("Navigation.Search"), systemImage: "magnifyingglass")
            }
            
            Tab(
                LocalizedStringKey("Hymnals"),
                systemImage: selectedTab == .browse ? "books.vertical.fill" : "books.vertical",
                value: TVTab.browse
            ) {
                NavigationStack {
                    TVBrowseHymnalsView(selectedBook: browseSelectedBook)
                }
            }
            
            Tab(
                LocalizedStringKey("Collections"),
                systemImage: "music.note.list",
                value: TVTab.collections
            ) {
                NavigationStack {
                    TVCollectionsView(
                        onNavigateToBrowse: { selectedTab = .browse }
                    )
                }
            }
            
            TabSection {
                Tab(
                    LocalizedStringKey("Settings.Title"),
                    systemImage: selectedTab == .settings ? "gearshape.fill" : "gearshape",
                    value: TVTab.settings
                ) {
                    TVSettingsView()
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
    
    @ViewBuilder
    private var classicTabView: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                TVHomeView(
                    onNavigateToSearch: { selectedTab = .search },
                    onNavigateToBrowse: { book in
                        browseSelectedBook = book
                        selectedTab = .browse
                    }
                )
            }
            .tabItem {
                Label(
                    LocalizedStringKey("Navigation.Home"),
                    image: selectedTab == .home ? "tv_home_fill" : "tv_home_outline"
                )
            }
            .tag(TVTab.home)
            
            NavigationStack {
                TVSearchView()
            }
            .tabItem {
                if selectedTab == .search {
                    Label(LocalizedStringKey("Navigation.Search"), image: "tv_search_fill")
                } else {
                    Label(LocalizedStringKey("Navigation.Search"), systemImage: "magnifyingglass")
                }
            }
            .tag(TVTab.search)
            
            NavigationStack {
                TVBrowseHymnalsView(selectedBook: browseSelectedBook)
            }
            .tabItem {
                Label(
                    LocalizedStringKey("Hymnals"),
                    systemImage: selectedTab == .browse ? "books.vertical.fill" : "books.vertical"
                )
            }
            .tag(TVTab.browse)
            
            NavigationStack {
                TVCollectionsView(
                    onNavigateToBrowse: { selectedTab = .browse }
                )
            }
            .tabItem {
                Label(LocalizedStringKey("Collections"), systemImage: "music.note.list")
            }
            .tag(TVTab.collections)
            
            TVSettingsView()
                .tabItem {
                    Label(
                        LocalizedStringKey("Settings.Title"),
                        systemImage: selectedTab == .settings ? "gearshape.fill" : "gearshape"
                    )
                }
                .tag(TVTab.settings)
        }
    }
}

// MARK: - TVSplashView
struct TVSplashView: View {
    @State private var pulse = false
    
    var body: some View {
        ZStack {
            TVAmbientBackground()
            
            // Centered emblem aligned with UILaunchScreen's SplashScreenLogo
            Image("SplashScreenLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 240, height: 240)
                .scaleEffect(pulse ? 1.03 : 1.0)
                .opacity(pulse ? 1.0 : 0.92)
            
            // Subtle progress indicator anchored near the bottom so the center logo never shifts
            VStack {
                Spacer()
                ProgressView()
                    .tint(Color.white.opacity(0.65))
                    .padding(.bottom, 120)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}

#Preview {
    TVRootView()
        .environmentObject(CISAppViewModel.sample)
        .environmentObject(TunePlayer())
}
