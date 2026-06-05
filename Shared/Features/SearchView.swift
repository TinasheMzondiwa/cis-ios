//
//  SearchView.swift
//  iOS
//
//  Created by Tinashe Mzondiwa on 2026-05-17.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var vm: CISAppViewModel
    @State private var filterQuery: String = ""
    @State private var searchTask: Task<Void, Never>? = nil
    
    @State private var allMatches: [StoreBook: [StoreHymn]] = [:]
    @State private var selectedBookKey: String? = nil
    
    // Sort books to ensure consistent ordering in the chips
    private var matchingBooks: [StoreBook] {
        var books = Array(allMatches.keys)
        
        let trimmedQuery = filterQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedQuery.isEmpty, let currentBook = vm.selectedBook, !books.contains(where: { $0.key == currentBook.key }) {
            books.append(currentBook)
        }
        
        books.sort(by: { $0.title < $1.title })
        
        // Ensure current book is always the first item
        if let currentBook = vm.selectedBook, let index = books.firstIndex(where: { $0.key == currentBook.key }) {
            let book = books.remove(at: index)
            books.insert(book, at: 0)
        }
        
        return books
    }
    
    var body: some View {
#if os(iOS)
        NavigationStack {
            content
        }
#else
        content
            .frame(minWidth: 300, idealWidth: 500)
#endif
    }
    
    private var chipsView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(matchingBooks, id: \.key) { book in
                        let count = allMatches[book]?.count ?? 0
                        let isSelected = (selectedBookKey == book.key)
                        
                        Button(action: {
                            HapticsManager.instance.trigger(.toggleSwitch)
                            
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedBookKey = book.key
                            }
                        }) {
                            HStack(spacing: 6) {
                                if vm.selectedBook?.key == book.key {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.footnote)
                                        .transition(.scale.combined(with: .opacity))
                                }
                                
                                Text("\(book.title) (\(count))")
                                    .font(.system(.subheadline, design: .rounded))
                                    .fontWeight(isSelected ? .semibold : .medium)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(isSelected ? Color.accentColor : Color(.secondarySystemBackground))
                            )
                            .foregroundColor(isSelected ? .white : .secondary)
                        }
                        .id(book.key)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            // Automatically scroll to the chip when selectedBookKey changes
            .onChange(of: selectedBookKey) { _, newValue in
                withAnimation(.easeOut(duration: 0.25)) {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
    
    private var selectedHymns: [StoreHymn] {
        guard let selectedKey = selectedBookKey,
              let book = matchingBooks.first(where: { $0.key == selectedKey }),
              let hymns = allMatches[book] else {
            return []
        }
        return hymns
    }
    
    private var resultsListView: some View {
        Group {
            if selectedHymns.isEmpty {
                Spacer()
                ContentUnavailableView.search(text: filterQuery)
                Spacer()
            } else {
                List {
                    ForEach(selectedHymns, id: \.id) { hymn in
                        NavigationLink(value: hymn) {
                            Text("\(hymn.number) - \(hymn.title)")
                                .headLineStyle()
                                .lineLimit(1)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
    
    private var content: some View {
        Group {
            if filterQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                ContentUnavailableView(
                    "Search Hymns",
                    systemImage: "magnifyingglass",
                    description: Text("Search by title, number, or lyrics.")
                )
            } else {
                VStack(spacing: 0) {
                    chipsView
                    Divider()
                    resultsListView
                }
            }
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $filterQuery, prompt: "Search Hymns")
        .resignKeyboardOnDragGesture()
        .onChange(of: filterQuery) { _, query in
            searchTask?.cancel()
            searchTask = Task {
                // Debounce search slightly to avoid heavy work on every keystroke
                try? await Task.sleep(nanoseconds: 150_000_000) // 150ms
                guard !Task.isCancelled else { return }
                
                let matches = await vm.searchAllBooks(query: query)
                guard !Task.isCancelled else { return }
                
                allMatches = matches
                selectedBookKey = vm.selectedBook?.key ?? matchingBooks.first?.key
            }
        }
        .onDisappear {
            searchTask?.cancel()
        }
        .navigationDestination(for: StoreHymn.self) { hymn in
            HymnView(displayedHymn: hymn)
        }
        .task {
            AnalyticsManager.shared.logScreen(name: "SearchView")
        }
    }
}

#if DEBUG
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(CISAppViewModel.sample)
    }
}
#endif


