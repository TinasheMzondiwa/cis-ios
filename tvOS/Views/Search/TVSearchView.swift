//
//  TVSearchView.swift
//  tvOS
//

import SwiftUI

struct TVSearchView: View {
    @EnvironmentObject private var vm: CISAppViewModel
    
    @State private var searchQuery: String = ""
    @State private var searchResults: [(book: StoreBook, hymn: StoreHymn)] = []
    @State private var isSearching = false
    @State private var activeLyricsHymn: StoreHymn?
    @State private var activeLyricsBook: StoreBook?
    @FocusState private var focusedHymnId: UUID?
    
    // When query is empty, show initial hymns list
    private var defaultHymns: [(book: StoreBook, hymn: StoreHymn)] {
        let activeBook = vm.selectedBook ?? vm.allBooks.first(where: { $0.key == "sdah" }) ?? vm.allBooks.first
        guard let book = activeBook, let hymns = vm.fetchHymns(from: book.key) else {
            return []
        }
        return hymns.prefix(30).map { (book, $0) }
    }
    
    private var displayList: [(book: StoreBook, hymn: StoreHymn)] {
        let trimmed = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? defaultHymns : searchResults
    }
    
    private func performSearch(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            searchResults = []
            isSearching = false
            return
        }
        
        isSearching = true
        let selectedKey = vm.selectedBook?.key
        Task {
            let results = await vm.searchHymns(query: trimmed, prioritizedBookKey: selectedKey)
            await MainActor.run {
                self.searchResults = results
                self.isSearching = false
            }
        }
    }
    
    var body: some View {
        List {
            if isSearching {
                HStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.4)
                        .padding(.vertical, 32)
                    Spacer()
                }
                .listRowBackground(Color.clear)
            } else if !searchQuery.isEmpty && searchResults.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundStyle(Color.white.opacity(0.35))
                    Text(String(format: NSLocalizedString("Search.NoHymnsFound", comment: ""), searchQuery))
                        .font(TVStyle.uiFont(size: 22))
                        .foregroundStyle(Color.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 48)
                .listRowBackground(Color.clear)
            } else {
                Section {
                    ForEach(displayList, id: \.hymn.id) { item in
                        let isRowFocused = (focusedHymnId == item.hymn.id)
                        Button {
                            activeLyricsBook = item.book
                            activeLyricsHymn = item.hymn
                        } label: {
                            TVSearchListRow(hymn: item.hymn, book: item.book, isRowFocused: isRowFocused)
                        }
                        .focused($focusedHymnId, equals: item.hymn.id)
                    }
                } header: {
                    if searchQuery.isEmpty {
                        Text(LocalizedStringKey("Home.AllHymnals"))
                            .font(TVStyle.uiFont(size: 20, weight: .semibold))
                            .foregroundStyle(Color.white.opacity(0.6))
                    } else {
                        Text(String(format: NSLocalizedString("Search.MatchingHymns", comment: ""), searchResults.count))
                            .font(TVStyle.uiFont(size: 20, weight: .semibold))
                            .foregroundStyle(Color.white.opacity(0.6))
                    }
                }
            }
        }
        .searchable(
            text: $searchQuery,
            prompt: Text(LocalizedStringKey("Search.Placeholder"))
        )
        .onChange(of: searchQuery) { newValue in
            performSearch(query: newValue)
        }
        .onAppear {
            if !searchQuery.isEmpty {
                performSearch(query: searchQuery)
            }
        }
        .tvAmbientBackground()
        .navigationDestination(item: $activeLyricsHymn) { hymn in
            TVLyricsView(hymn: hymn, book: activeLyricsBook ?? vm.selectedBook)
        }
    }
}

// MARK: - Search List Row
struct TVSearchListRow: View {
    let hymn: StoreHymn
    let book: StoreBook
    var isRowFocused: Bool = false
    @Environment(\.isFocused) private var envIsFocused
    
    private var isFocused: Bool {
        isRowFocused || envIsFocused
    }
    
    private var hasTune: Bool {
        hymn.book == "sdah"
    }
    
    var body: some View {
        HStack(spacing: 24) {
            // Number Badge in clean pill
            Text("\(hymn.number)")
                .font(TVStyle.uiFont(size: 20, weight: .bold))
                .foregroundStyle(isFocused ? Color.black : Color.white)
                .frame(minWidth: 56, minHeight: 40)
                .padding(.horizontal, 8)
                .background(
                    Capsule().fill(isFocused ? Color.black.opacity(0.12) : Color.white.opacity(0.14))
                )
            
            // Title & First Line Lyric Preview
            VStack(alignment: .leading, spacing: 4) {
                Text(hymn.title)
                    .font(TVStyle.titleFont(size: 26))
                    .foregroundStyle(isFocused ? Color.black : Color.white)
                    .lineLimit(1)
                
                if let firstLine = hymn.lyrics.first?.lines.first {
                    Text(firstLine)
                        .font(TVStyle.uiFont(size: 18))
                        .foregroundStyle(isFocused ? Color.black.opacity(0.70) : Color.white.opacity(0.6))
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // Tune Available Icon
            if hasTune {
                HStack(spacing: 6) {
                    Image(systemName: "music.note")
                        .font(.system(size: 14, weight: .bold))
                    Text(LocalizedStringKey("Common.Tune"))
                        .font(TVStyle.uiFont(size: 14, weight: .semibold))
                }
                .foregroundStyle(isFocused ? Color.black.opacity(0.85) : Color.white.opacity(0.8))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule().fill(isFocused ? Color.black.opacity(0.10) : Color.white.opacity(0.10))
                )
                .padding(.trailing, 8)
            }
            
            // Hymnal Book / Language Tag
            Text(book.title)
                .font(TVStyle.uiFont(size: 15, weight: .medium))
                .foregroundStyle(isFocused ? Color.black.opacity(0.75) : Color.white.opacity(0.55))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule().fill(isFocused ? Color.black.opacity(0.08) : Color.white.opacity(0.08))
                )
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    TVSearchView()
        .environmentObject(CISAppViewModel.sample)
        .environmentObject(TunePlayer())
}
