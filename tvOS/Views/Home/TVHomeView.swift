//
//  TVHomeView.swift
//  tvOS
//
//

import SwiftUI

struct TVHomeView: View {
    @EnvironmentObject private var vm: CISAppViewModel
    @ObservedObject private var recentsManager = TVRecentsManager.shared
    @ObservedObject private var pinnedManager = TVPinnedHymnalsManager.shared
    @AppStorage("tv_hymnals_show_pinned_only") private var showPinnedOnly: Bool = false
    
    let onNavigateToSearch: () -> Void
    let onNavigateToBrowse: (StoreBook) -> Void
    
    @State private var activeLyricsHymn: StoreHymn?
    @State private var activeLyricsBook: StoreBook?
    
    private var activeBook: StoreBook? {
        vm.selectedBook ?? vm.allBooks.first(where: { $0.key == "sdah" }) ?? vm.allBooks.first
    }
    
    private var fallbackHymns: [StoreHymn] {
        guard let bookKey = activeBook?.key else { return [] }
        return vm.fetchHymns(from: bookKey) ?? []
    }
    
    private var isShowingPinnedOnly: Bool {
        showPinnedOnly && !pinnedManager.pinnedKeys.isEmpty
    }
    
    private var displayedBooks: [StoreBook] {
        if isShowingPinnedOnly {
            return pinnedManager.pinnedBooks(from: vm.allBooks)
        }
        return pinnedManager.sortedBooks(vm.allBooks)
    }
    
    private var resolvedRecents: [(book: StoreBook, hymn: StoreHymn)] {
        recentsManager.recents.compactMap { item in
            if let book = vm.allBooks.first(where: { $0.key == item.bookKey }),
               let hymns = vm.fetchHymns(from: item.bookKey),
               let hymn = hymns.first(where: { $0.id == item.hymnId || ($0.number == item.hymnNumber && $0.title == item.title) }) {
                return (book, hymn)
            }
            for book in vm.allBooks {
                if let hymns = vm.fetchHymns(from: book.key),
                   let hymn = hymns.first(where: { $0.id == item.hymnId || ($0.number == item.hymnNumber && $0.title == item.title) }) {
                    return (book, hymn)
                }
            }
            return nil
        }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 44) {
                // Header: iOS-Style Squircle App Icon + Dynamic Greeting + Title & Subtitle
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 14) {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 44)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color.white.opacity(0.22), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.35), radius: 8, y: 3)
                        
                        Text(TVGreetingHelper.greeting())
                            .font(TVStyle.uiFont(size: 40, weight: .bold))
                            .tracking(1.5)
                            .foregroundStyle(Color.white.opacity(0.9))
                    }
                                        
                    Text(LocalizedStringKey("Home.Subtitle"))
                        .font(TVStyle.uiFont(size: 24, weight: .regular))
                        .foregroundStyle(Color.white.opacity(0.7))
                        .frame(maxWidth: 850, alignment: .leading)
                }
                .padding(.horizontal, TVStyle.horizontalPadding)
                .padding(.top, 36)
                
                // Primary Shelf: Recently Viewed or Fallback to Active Hymnal
                let recentsList = resolvedRecents
                if !recentsList.isEmpty {
                    // Recents Shelf
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(LocalizedStringKey("Home.Recents"))
                                .font(TVStyle.titleFont(size: 36))
                                .foregroundStyle(Color.white)
                            
                            Text(LocalizedStringKey("Home.RecentsSubtitle"))
                                .font(TVStyle.uiFont(size: 20))
                                .foregroundStyle(Color.white.opacity(0.65))
                        }
                        .padding(.horizontal, TVStyle.horizontalPadding)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 32) {
                                ForEach(recentsList, id: \.hymn.id) { entry in
                                    TVHymnGridCard(hymn: entry.hymn, bookTitle: entry.book.title) {
                                        activeLyricsBook = entry.book
                                        activeLyricsHymn = entry.hymn
                                    }
                                    .frame(width: 340)
                                }
                            }
                            .padding(.horizontal, TVStyle.horizontalPadding)
                            .padding(.vertical, 32)
                        }
                    }
                } else if let book = activeBook {
                    // Fallback Shelf: Active Hymnal First 10 Hymns + "View All" Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .firstTextBaseline) {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(spacing: 12) {
                                    Text(book.title)
                                        .font(TVStyle.titleFont(size: 36))
                                        .foregroundStyle(Color.white)
                                    
                                    if book.key == "sdah" {
                                        Label(LocalizedStringKey("Home.TunesAvailable"), systemImage: "music.note")
                                            .font(TVStyle.uiFont(size: 16, weight: .semibold))
                                            .foregroundStyle(Color.white.opacity(0.9))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 4)
                                            .background(Capsule().fill(Color.white.opacity(0.12)))
                                    }
                                }
                                
                                if book.key == "sdah" {
                                    Text(LocalizedStringKey("Home.SDAHDescription"))
                                        .font(TVStyle.uiFont(size: 20))
                                        .foregroundStyle(Color.white.opacity(0.65))
                                } else {
                                    Text(String(format: NSLocalizedString("Home.ViewAllHymnal", comment: ""), book.title))
                                        .font(TVStyle.uiFont(size: 20))
                                        .foregroundStyle(Color.white.opacity(0.65))
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal, TVStyle.horizontalPadding)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 32) {
                                ForEach(fallbackHymns.prefix(10), id: \.id) { hymn in
                                    TVHymnGridCard(hymn: hymn, bookTitle: book.title) {
                                        activeLyricsBook = book
                                        activeLyricsHymn = hymn
                                    }
                                    .frame(width: 340)
                                }
                                
                                // View All Card
                                TVViewAllCard(bookTitle: book.title) {
                                    onNavigateToBrowse(book)
                                }
                                .frame(width: 340)
                            }
                            .padding(.horizontal, TVStyle.horizontalPadding)
                            .padding(.vertical, 32)
                        }
                    }
                }
                
                // Hymnals Bookshelf: Designed as sacred hymn books with Pin & Filter support
                VStack(alignment: .leading, spacing: 14) {
                    HStack(alignment: .bottom, spacing: 24) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(LocalizedStringKey(isShowingPinnedOnly ? "Home.PinnedHymnals" : "Home.AllHymnals"))
                                .font(TVStyle.titleFont(size: 36))
                                .foregroundStyle(Color.white)
                            
                            Text(LocalizedStringKey("Home.PinHint"))
                                .font(TVStyle.uiFont(size: 18))
                                .foregroundStyle(Color.white.opacity(0.55))
                        }
                        
                        if !pinnedManager.pinnedKeys.isEmpty {
                            HStack(spacing: 12) {
                                TVBookshelfFilterChip(
                                    title: NSLocalizedString("Home.Filter.All", comment: ""),
                                    icon: nil,
                                    isSelected: !isShowingPinnedOnly
                                ) {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                                        showPinnedOnly = false
                                    }
                                }
                                
                                TVBookshelfFilterChip(
                                    title: String(format: NSLocalizedString("Home.Filter.Pinned", comment: ""), pinnedManager.pinnedKeys.count),
                                    icon: "pin.fill",
                                    isSelected: isShowingPinnedOnly
                                ) {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                                        showPinnedOnly = true
                                    }
                                }
                            }
                            .padding(.bottom, 4)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, TVStyle.horizontalPadding)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 36) {
                            ForEach(displayedBooks, id: \.key) { book in
                                let count = vm.fetchHymns(from: book.key)?.count ?? 0
                                let pinned = pinnedManager.isPinned(book.key)
                                TVBookCard(
                                    book: book,
                                    hymnCount: count,
                                    isPinned: pinned,
                                    onTogglePin: {
                                        withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                                            pinnedManager.togglePin(book.key)
                                            if pinnedManager.pinnedKeys.isEmpty {
                                                showPinnedOnly = false
                                            }
                                        }
                                    }
                                ) {
                                    onNavigateToBrowse(book)
                                }
                            }
                        }
                        .padding(.horizontal, TVStyle.horizontalPadding)
                        .padding(.vertical, 40)
                    }
                }
                .padding(.bottom, 90)
            }
        }
        .tvAmbientBackground()
        .navigationDestination(item: $activeLyricsHymn) { hymn in
            let book = vm.allBooks.first(where: { $0.key == hymn.book }) ?? activeLyricsBook ?? vm.selectedBook
            TVLyricsView(hymn: hymn, book: book)
        }
    }
}

// MARK: - Bookshelf Filter Chip
private struct TVBookshelfFilterChip: View {
    let title: String
    let icon: String?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        if isSelected {
            Button(action: action) {
                HStack(spacing: 8) {
                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 14, weight: .bold))
                    }
                    Text(title)
                        .font(TVStyle.uiFont(size: 18, weight: .bold))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.white)
            .foregroundStyle(Color.black)
        } else {
            Button(action: action) {
                HStack(spacing: 8) {
                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Text(title)
                        .font(TVStyle.uiFont(size: 18, weight: .medium))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
            }
            .buttonStyle(.bordered)
        }
    }
}

// MARK: - View All Card
struct TVViewAllCard: View {
    let bookTitle: String
    let action: () -> Void
    @FocusState private var isFocused: Bool
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "books.vertical.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(isFocused ? Color.black : Color.white)
                        .padding(12)
                        .background(
                            Circle()
                                .fill(isFocused ? Color.white : Color.white.opacity(0.16))
                        )
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(isFocused ? Color.black : Color.white.opacity(0.8))
                }
                
                Spacer(minLength: 4)
                
                Text(LocalizedStringKey("Home.ViewAll"))
                    .font(TVStyle.titleFont(size: 26))
                    .foregroundStyle(Color.white)
                
                Text(bookTitle)
                    .font(TVStyle.uiFont(size: 17, weight: .regular))
                    .foregroundStyle(isFocused ? Color.white.opacity(0.9) : Color.white.opacity(0.6))
                    .lineLimit(1)
            }
            .padding(20)
            .frame(maxWidth: .infinity, minHeight: 180, maxHeight: 180, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: TVStyle.cardCornerRadius)
                    .fill(TVStyle.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: TVStyle.cardCornerRadius)
                    .stroke(TVStyle.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(.card)
        .focused($isFocused)
    }
}

#Preview {
    TVHomeView(
        onNavigateToSearch: {},
        onNavigateToBrowse: { _ in }
    )
    .environmentObject(CISAppViewModel.sample)
    .environmentObject(TunePlayer())
}
