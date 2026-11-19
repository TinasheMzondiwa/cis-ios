//
//  TVBrowseHymnalsView.swift
//  tvOS
//

import SwiftUI

struct TVBrowseHymnalsView: View {
    @EnvironmentObject private var vm: CISAppViewModel
    @ObservedObject private var pinnedManager = TVPinnedHymnalsManager.shared
    @State var selectedBook: StoreBook?
    
    @State private var activeLyricsHymn: StoreHymn?
    
    private var orderedBooks: [StoreBook] {
        pinnedManager.sortedBooks(vm.allBooks)
    }
    
    private var currentBook: StoreBook? {
        selectedBook ?? vm.selectedBook ?? orderedBooks.first
    }
    
    private var hymns: [StoreHymn] {
        guard let key = currentBook?.key else { return [] }
        return vm.fetchHymns(from: key) ?? []
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Hymnal Switcher Shelf (Pinned floated first)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(orderedBooks, id: \.key) { book in
                        let pinned = pinnedManager.isPinned(book.key)
                        TVBrowseHymnalChip(
                            book: book,
                            isSelected: currentBook?.key == book.key,
                            isPinned: pinned,
                            onTogglePin: {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                                    pinnedManager.togglePin(book.key)
                                }
                            }
                        ) {
                            selectedBook = book
                            vm.setSelectedBook(to: book)
                        }
                    }
                }
                .padding(.horizontal, TVStyle.horizontalPadding)
                .padding(.vertical, 24)
            }
            .padding(.top, 2)
            
            // Header showing count & active hymnal
            HStack(alignment: .firstTextBaseline) {
                if let book = currentBook {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(book.title)
                            .font(TVStyle.titleFont(size: 42))
                            .foregroundStyle(Color.white)
                        Text(String(format: NSLocalizedString("Browse.HymnsCount", comment: ""), hymns.count, book.language))
                            .font(TVStyle.uiFont(size: 20))
                            .foregroundStyle(Color.white.opacity(0.65))
                    }
                }
                Spacer()
            }
            .padding(.horizontal, TVStyle.horizontalPadding)
            
            // Hymns Grid
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 28),
                        GridItem(.flexible(), spacing: 28),
                        GridItem(.flexible(), spacing: 28)
                    ],
                    spacing: 28
                ) {
                    ForEach(hymns, id: \.id) { hymn in
                        TVHymnGridCard(hymn: hymn, bookTitle: currentBook?.title) {
                            activeLyricsHymn = hymn
                        }
                    }
                }
                .padding(.horizontal, TVStyle.horizontalPadding)
                .padding(.top, 36)
                .padding(.bottom, 90)
            }
        }
        .tvAmbientBackground()
        .navigationDestination(item: $activeLyricsHymn) { hymn in
            TVLyricsView(hymn: hymn, book: currentBook)
        }
    }
}

// MARK: - Hymnal Chip

private struct TVBrowseHymnalChip: View {
    let book: StoreBook
    let isSelected: Bool
    var isPinned: Bool = false
    var onTogglePin: (() -> Void)? = nil
    let action: () -> Void
    
    var body: some View {
        Group {
            if isSelected {
                Button(action: action) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 13, weight: .bold))
                        if isPinned {
                            Image(systemName: "pin.fill")
                                .font(.system(size: 13, weight: .bold))
                        }
                        if book.key == "sdah" {
                            Image(systemName: "music.note")
                                .font(.system(size: 15, weight: .bold))
                        }
                        Text(book.title)
                            .font(TVStyle.uiFont(size: 20, weight: .bold))
                        Text(book.language.uppercased())
                            .font(TVStyle.uiFont(size: 13, weight: .bold))
                            .opacity(0.85)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.white)
                .foregroundStyle(Color.black)
            } else {
                Button(action: action) {
                    HStack(spacing: 8) {
                        if isPinned {
                            Image(systemName: "pin.fill")
                                .font(.system(size: 13, weight: .bold))
                        }
                        if book.key == "sdah" {
                            Image(systemName: "music.note")
                                .font(.system(size: 16, weight: .bold))
                        }
                        Text(book.title)
                            .font(TVStyle.uiFont(size: 20, weight: .medium))
                        Text(book.language.uppercased())
                            .font(TVStyle.uiFont(size: 13, weight: .bold))
                            .opacity(0.6)
                    }
                }
                .buttonStyle(.bordered)
            }
        }
        .contextMenu {
            if let onTogglePin {
                Button(action: onTogglePin) {
                    Label(
                        LocalizedStringKey(isPinned ? "Home.UnpinHymnal" : "Home.PinHymnal"),
                        systemImage: isPinned ? "pin.slash.fill" : "pin.fill"
                    )
                }
            }
        }
    }
}

#Preview {
    TVBrowseHymnalsView()
        .environmentObject(CISAppViewModel.sample)
        .environmentObject(TunePlayer())
}
