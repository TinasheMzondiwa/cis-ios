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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(matchingBooks, id: \.key) { book in
                    let count = allMatches[book]?.count ?? 0
                    let isSelected = (selectedBookKey == book.key)
                    
                    Button(action: {
                        selectedBookKey = book.key
                    }) {
                        Text("\(book.title) (\(count))")
                            .font(.subheadline)
                            .fontWeight(isSelected ? .semibold : .regular)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(isSelected ? Color.accentColor : Color.gray.opacity(0.5), lineWidth: 1)
                                    .background(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
                            )
                            .foregroundColor(isSelected ? .accentColor : .primary)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
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
        .onChange(of: filterQuery) { query in
            Task {
                allMatches = await vm.searchAllBooks(query: query)
                selectedBookKey = vm.selectedBook?.key ?? matchingBooks.first?.key
            }
        }
        .navigationDestination(for: StoreHymn.self) { hymn in
            HymnView(displayedHymn: hymn)
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


