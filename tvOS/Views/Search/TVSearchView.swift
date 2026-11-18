//
//  TVSearchView.swift
//  tvOS
//

import SwiftUI

struct TVSearchView: View {
    @EnvironmentObject private var vm: CISAppViewModel
    
    @State private var searchMode: SearchMode = .number
    @State private var numberQuery: String = ""
    @State private var textQuery: String = ""
    @State private var selectedBookKey: String? = nil
    
    @State private var searchResults: [(book: StoreBook, hymn: StoreHymn)] = []
    @State private var isSearching = false
    @State private var activeLyricsHymn: StoreHymn?
    @State private var activeLyricsBook: StoreBook?
    
    enum SearchMode: CaseIterable {
        case number
        case text
        
        var titleKey: LocalizedStringKey {
            switch self {
            case .number: return LocalizedStringKey("Search.Mode.Number")
            case .text: return LocalizedStringKey("Search.Mode.Text")
            }
        }
    }
    
    private var filteredResults: [(book: StoreBook, hymn: StoreHymn)] {
        if let key = selectedBookKey {
            return searchResults.filter { $0.book.key == key }
        }
        return searchResults
    }
    
    private func executeSearch(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        Task {
            let results = await vm.searchHymns(query: trimmed, in: selectedBookKey)
            await MainActor.run {
                self.searchResults = results
                self.isSearching = false
            }
        }
    }
    
    private func openHymnByExactNumber(_ number: Int) {
        let key = selectedBookKey ?? vm.selectedBook?.key ?? "sdah"
        if let hymns = vm.fetchHymns(from: key),
           let hymn = hymns.first(where: { $0.number == number }) {
            let book = vm.allBooks.first(where: { $0.key == key }) ?? vm.selectedBook
            activeLyricsBook = book
            activeLyricsHymn = hymn
        }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Top Mode Picker & Scope Bar
            HStack(spacing: 24) {
                // Search Mode Native Segmented Picker
                Picker("", selection: $searchMode) {
                    ForEach(SearchMode.allCases, id: \.self) { mode in
                        Text(mode.titleKey).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 440)
                
                Spacer()
                
                // Hymnal Scope Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        TVSearchScopeChip(
                            title: NSLocalizedString("Search.AllHymnals", comment: ""),
                            isChosen: selectedBookKey == nil
                        ) {
                            selectedBookKey = nil
                            if searchMode == .text {
                                executeSearch(query: textQuery)
                            }
                        }
                        
                        ForEach(vm.allBooks, id: \.key) { book in
                            TVSearchScopeChip(
                                title: book.title,
                                isChosen: selectedBookKey == book.key
                            ) {
                                selectedBookKey = book.key
                                if searchMode == .text {
                                    executeSearch(query: textQuery)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 24)
                }
                .frame(maxWidth: 900)
            }
            .padding(.horizontal, TVStyle.horizontalPadding)
            .padding(.top, 4)
            
            // Content Area depending on Mode
            if searchMode == .number {
                // NUMBER DIAL MODE
                HStack(alignment: .top, spacing: 64) {
                    // Left: Keypad
                    VStack(alignment: .center, spacing: 0) {
                        TVNumberPadView(enteredNumber: $numberQuery) { number in
                            openHymnByExactNumber(number)
                        }
                    }
                    .frame(width: 400)
                    .padding(.top, 10)
                    
                    // Right: Live matching preview
                    VStack(alignment: .leading, spacing: 18) {
                        let activeKey = selectedBookKey ?? vm.selectedBook?.key ?? "sdah"
                        let currentHymns = vm.fetchHymns(from: activeKey) ?? []
                        let matchingHymns: [StoreHymn] = {
                            guard !numberQuery.isEmpty else { return [] }
                            return currentHymns.filter { "\($0.number)".contains(numberQuery) }
                        }()
                        
                        Text(String(format: NSLocalizedString("Search.MatchingHymns", comment: ""), matchingHymns.count))
                            .font(TVStyle.uiFont(size: 22, weight: .semibold))
                            .foregroundStyle(Color.white.opacity(0.7))
                            .padding(.leading, 18)
                        
                        if matchingHymns.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "number.circle")
                                    .font(.system(size: 56))
                                    .foregroundStyle(Color.white.opacity(0.3))
                                Text(numberQuery.isEmpty ? LocalizedStringKey("Search.EnterHymnNumberPrompt") : LocalizedStringKey(String(format: NSLocalizedString("Search.NoHymnsMatchNumber", comment: ""), numberQuery)))
                                    .font(TVStyle.uiFont(size: 20))
                                    .foregroundStyle(Color.white.opacity(0.6))
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVGrid(columns: [GridItem(.flexible(), spacing: 24), GridItem(.flexible(), spacing: 24)], spacing: 24) {
                                    ForEach(matchingHymns, id: \.id) { hymn in
                                        let book = vm.allBooks.first(where: { $0.key == hymn.book })
                                        TVHymnGridCard(hymn: hymn, bookTitle: book?.title) {
                                            activeLyricsBook = book
                                            activeLyricsHymn = hymn
                                        }
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.top, 36)
                                .padding(.bottom, 60)
                            }
                        }
                    }
                }
                .padding(.horizontal, TVStyle.horizontalPadding)
            } else {
                // TEXT SEARCH MODE
                VStack(spacing: 20) {
                    // Search Bar
                    HStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.white.opacity(0.6))
                        
                        TextField(LocalizedStringKey("Search.Placeholder"), text: $textQuery)
                            .font(TVStyle.uiFont(size: 24))
                            .onSubmit {
                                executeSearch(query: textQuery)
                            }
                        
                        if !textQuery.isEmpty {
                            Button {
                                textQuery = ""
                                searchResults = []
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 22))
                                    .foregroundStyle(Color.white.opacity(0.6))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: TVStyle.cardCornerRadius)
                            .fill(TVStyle.cardBackground)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: TVStyle.cardCornerRadius)
                            .stroke(TVStyle.cardBorder, lineWidth: 1)
                    )
                    .padding(.horizontal, TVStyle.horizontalPadding)
                    
                    // Search Results
                    if isSearching {
                        VStack(spacing: 20) {
                            ProgressView()
                                .scaleEffect(1.6)
                            Text(LocalizedStringKey("Search.Searching"))
                                .font(TVStyle.uiFont(size: 22))
                                .foregroundStyle(Color.white.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if filteredResults.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "text.magnifyingglass")
                                .font(.system(size: 64))
                                .foregroundStyle(Color.white.opacity(0.3))
                            Text(textQuery.isEmpty ? LocalizedStringKey("Search.TypeWordsPrompt") : LocalizedStringKey(String(format: NSLocalizedString("Search.NoHymnsFound", comment: ""), textQuery)))
                                .font(TVStyle.uiFont(size: 22))
                                .foregroundStyle(Color.white.opacity(0.6))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)], spacing: 20) {
                                ForEach(filteredResults, id: \.hymn.id) { item in
                                    TVSearchResultCard(hymn: item.hymn, book: item.book, searchQuery: textQuery) {
                                        activeLyricsBook = item.book
                                        activeLyricsHymn = item.hymn
                                    }
                                }
                            }
                            .padding(.horizontal, TVStyle.horizontalPadding)
                            .padding(.top, 36)
                            .padding(.bottom, 60)
                        }
                    }
                }
            }
        }
        .tvAmbientBackground()
        .navigationDestination(item: $activeLyricsHymn) { hymn in
            TVLyricsView(hymn: hymn, book: activeLyricsBook ?? vm.selectedBook)
        }
    }
}

// MARK: - Subviews

private struct TVSearchScopeChip: View {
    let title: String
    let isChosen: Bool
    let action: () -> Void
    
    var body: some View {
        if isChosen {
            Button(action: action) {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .bold))
                    Text(title)
                        .font(TVStyle.uiFont(size: 18, weight: .bold))
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(TVStyle.accentGold)
            .foregroundStyle(Color.black)
        } else {
            Button(action: action) {
                Text(title)
                    .font(TVStyle.uiFont(size: 18, weight: .medium))
            }
            .buttonStyle(.bordered)
        }
    }
}
