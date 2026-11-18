//
//  TVHomeView.swift
//  tvOS
//
//

import SwiftUI

struct TVHomeView: View {
    @EnvironmentObject private var vm: CISAppViewModel
    @ObservedObject private var recentsManager = TVRecentsManager.shared
    
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
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 44) {
                // Header: iOS-Style Squircle App Icon + Dynamic Greeting + Title & Subtitle
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 14) {
                        Image("AppLogo")
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
                if !recentsManager.recents.isEmpty {
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
                                ForEach(recentsManager.recents) { item in
                                    if let book = vm.allBooks.first(where: { $0.key == item.bookKey }),
                                       let hymns = vm.fetchHymns(from: item.bookKey),
                                       let hymn = hymns.first(where: { $0.id == item.hymnId }) {
                                        TVHymnGridCard(hymn: hymn, bookTitle: book.title) {
                                            activeLyricsBook = book
                                            activeLyricsHymn = hymn
                                        }
                                        .frame(width: 340)
                                    }
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
                
                // Hymnals Bookshelf: Designed as sacred hymn books
                VStack(alignment: .leading, spacing: 14) {
                    Text(LocalizedStringKey("Home.AllHymnals"))
                        .font(TVStyle.titleFont(size: 36))
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, TVStyle.horizontalPadding)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 36) {
                            ForEach(vm.allBooks, id: \.key) { book in
                                let count = vm.fetchHymns(from: book.key)?.count ?? 0
                                TVBookCard(book: book, hymnCount: count) {
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
            TVLyricsView(hymn: hymn, book: activeLyricsBook ?? vm.selectedBook)
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
