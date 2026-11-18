//
//  TVRootView.swift
//  tvOS
//

import SwiftUI

struct TVRootView: View {
    @EnvironmentObject private var vm: CISAppViewModel
    @State private var selectedTab: TVTab = .home
    @State private var browseSelectedBook: StoreBook?
    
    enum TVTab: Hashable {
        case home
        case search
        case browse
        case collections
    }
    
    var body: some View {
        Group {
            if vm.isLoadingStore {
                VStack(spacing: 24) {
                    ProgressView()
                        .scaleEffect(1.8)
                    Text(LocalizedStringKey("Common.Loading"))
                        .font(TVStyle.uiFont(size: 26, weight: .semibold))
                        .foregroundStyle(Color.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tvAmbientBackground()
            } else {
                TabView(selection: $selectedTab) {
                    NavigationStack {
                        TVHomeView(
                            onNavigateToSearch: {
                                selectedTab = .search
                            },
                            onNavigateToBrowse: { book in
                                browseSelectedBook = book
                                selectedTab = .browse
                            }
                        )
                    }
                    .tabItem {
                        Label(LocalizedStringKey("Navigation.Home"), systemImage: "house.fill")
                    }
                    .tag(TVTab.home)
                    
                    NavigationStack {
                        TVSearchView()
                    }
                    .tabItem {
                        Label(LocalizedStringKey("Navigation.Search"), systemImage: "magnifyingglass")
                    }
                    .tag(TVTab.search)
                    
                    NavigationStack {
                        TVBrowseHymnalsView(selectedBook: browseSelectedBook)
                    }
                    .tabItem {
                        Label(LocalizedStringKey("Hymnals"), systemImage: "books.vertical.fill")
                    }
                    .tag(TVTab.browse)
                    
                    NavigationStack {
                        TVCollectionsView(
                            onNavigateToBrowse: {
                                selectedTab = .browse
                            }
                        )
                    }
                    .tabItem {
                        Label(LocalizedStringKey("Collections"), systemImage: "music.note.list")
                    }
                    .tag(TVTab.collections)
                }
            }
        }
    }
}
