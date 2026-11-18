//
//  TVHomeView.swift
//  tvOS
//

import SwiftUI

struct TVHomeView: View {
    @EnvironmentObject private var vm: CISAppViewModel
    let onNavigateToSearch: () -> Void
    let onNavigateToBrowse: (StoreBook) -> Void
    
    @State private var activeLyricsHymn: StoreHymn?
    @State private var activeLyricsBook: StoreBook?
    
    private var sdahHymns: [StoreHymn] {
        vm.fetchHymns(from: "sdah") ?? []
    }
    
    private var sdahBook: StoreBook? {
        vm.allBooks.first(where: { $0.key == "sdah" })
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 44) {
                // Hero Banner
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        Image(systemName: "music.note.house.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(TVStyle.accentGold)
                        Text(LocalizedStringKey("Home.Brand"))
                            .font(TVStyle.uiFont(size: 16, weight: .bold))
                            .tracking(3)
                            .foregroundStyle(TVStyle.accentGold.opacity(0.9))
                    }
                    
                    Text(LocalizedStringKey("Home.Title"))
                        .font(TVStyle.titleFont(size: 68))
                        .foregroundStyle(Color.white)
                    
                    Text(LocalizedStringKey("Home.Subtitle"))
                        .font(TVStyle.uiFont(size: 24, weight: .regular))
                        .foregroundStyle(Color.white.opacity(0.7))
                        .frame(maxWidth: 850, alignment: .leading)
                    
                    HStack(spacing: 24) {
                        Button {
                            onNavigateToSearch()
                        } label: {
                            Label(LocalizedStringKey("Home.DialHymn"), systemImage: "number.circle.fill")
                                .font(TVStyle.uiFont(size: 22, weight: .bold))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(TVStyle.accentGold)
                        .foregroundStyle(Color.black)
                        
                        if let sdah = sdahBook, let firstHymn = sdahHymns.first {
                            Button {
                                activeLyricsBook = sdah
                                activeLyricsHymn = firstHymn
                            } label: {
                                Label(LocalizedStringKey("Home.SingSDAH"), systemImage: "play.circle.fill")
                                    .font(TVStyle.uiFont(size: 22, weight: .semibold))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, TVStyle.horizontalPadding)
                .padding(.top, 36)
                
                // Featured Shelf: SDA Hymnal with Tunes
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 12) {
                                Text(sdahBook?.title ?? "SDA Hymnal")
                                    .font(TVStyle.titleFont(size: 36))
                                    .foregroundStyle(Color.white)
                                
                                Label(LocalizedStringKey("Home.TunesAvailable"), systemImage: "music.note")
                                    .font(TVStyle.uiFont(size: 16, weight: .semibold))
                                    .foregroundStyle(TVStyle.accentGold)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Capsule().fill(TVStyle.accentGold.opacity(0.18)))
                            }
                            Text(LocalizedStringKey("Home.SDAHDescription"))
                                .font(TVStyle.uiFont(size: 20))
                                .foregroundStyle(Color.white.opacity(0.65))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, TVStyle.horizontalPadding)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 32) {
                            ForEach(sdahHymns.prefix(12), id: \.id) { hymn in
                                TVHymnGridCard(hymn: hymn, bookTitle: sdahBook?.title) {
                                    activeLyricsBook = sdahBook
                                    activeLyricsHymn = hymn
                                }
                                .frame(width: 340)
                            }
                        }
                        .padding(.horizontal, TVStyle.horizontalPadding)
                        .padding(.vertical, 32)
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
