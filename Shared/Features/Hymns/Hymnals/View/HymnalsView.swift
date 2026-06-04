//
//  HymnalsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct HymnalsView: View {
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    let books: [StoreBook]
    let action: (StoreBook) -> Void
    let dismissAction: () -> Void
    
    @State private var filterQuery: String = ""
    @State private var lastToggledKey: String?
    
    @AppStorage("pinnedHymnals") private var pinnedHymnalsString: String = ""
    @AppStorage("showOnlyPinnedHymnals") private var showOnlyPinned: Bool = false
    
    private var pinnedKeys: [String] {
        pinnedHymnalsString.isEmpty
        ? []
        : pinnedHymnalsString.split(separator: ",").map(String.init)
    }
    
    private func togglePin(for key: String) {
        lastToggledKey = key
        
        withAnimation(.easeInOut(duration: 0.25)) {
            var keys = pinnedKeys
            
            if keys.contains(key) {
                keys.removeAll { $0 == key }
            } else {
                keys.append(key)
            }
            
            pinnedHymnalsString = keys.joined(separator: ",")
        }
    }
    
    private var filteredBooks: [StoreBook] {
        let terms = filterQuery.lowercased().split(separator: " ")
        
        let results: [StoreBook] = {
            if terms.isEmpty {
                return books
            } else {
                return books.filter { book in
                    terms.allSatisfy { term in
                        book.title.lowercased().contains(term) ||
                        book.language.lowercased().contains(term)
                    }
                }
            }
        }()
        
        if showOnlyPinned {
            return results.filter { pinnedKeys.contains($0.key) }
        } else {
            return results
        }
    }
    
    private var orderedBooks: [StoreBook] {
        filteredBooks.sorted { a, b in
            let aPinned = pinnedKeys.contains(a.key)
            let bPinned = pinnedKeys.contains(b.key)
            
            if aPinned != bPinned {
                return aPinned
            }
            
            return a.title.localizedCaseInsensitiveCompare(b.title) == .orderedAscending
        }
    }
    
    var body: some View {
        NavigationStack {
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        
                        if showOnlyPinned && filteredBooks.isEmpty {
                            emptyPinnedState
                        } else {
                            ForEach(orderedBooks, id: \.id) { book in
                                VStack {
                                    bookRow(book)
                                        .id(book.id)
                                    
                                    Divider()
                                        .padding(.leading, 70)
                                }
                            }
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: pinnedKeys)
                .onChange(of: lastToggledKey) { _, id in
                    guard let id else { return }
                    
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            proxy.scrollTo(id, anchor: .top)
                        }
                    }
                }
            }
            .navigationTitle(LocalizedStringKey("Hymnals"))
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $filterQuery)
            .resignKeyboardOnDragGesture()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        HapticsManager.instance.trigger(.light)
                        dismissAction()
                    } label: {
                        SFSymbol.close.navButtonStyle()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Filter", selection: $showOnlyPinned) {
                            Label("All Hymnals", systemImage: "books.vertical")
                                .tag(false)
                            
                            Label("Pinned", systemImage: "pin")
                                .tag(true)
                        }
                    } label: {
                        Image(
                            systemName: showOnlyPinned
                            ? "line.3.horizontal.decrease.circle.fill"
                            : "line.3.horizontal.decrease.circle"
                        )
                    }
                }
            }
            .onChange(of: showOnlyPinned) { _, _ in
                HapticsManager.instance.trigger(.success)
            }
        }
    }
    
    private var emptyPinnedState: some View {
        VStack(spacing: 16) {
            Image(systemName: "pin.slash")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("Pin a few hymnals you regularly get back to and they will show up here.")
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .padding(.top, 64)
    }
    
    @ViewBuilder
    private func bookRow(_ book: StoreBook) -> some View {
        let isPinned = pinnedKeys.contains(book.key)
        
        Button {
            HapticsManager.instance.trigger(.success)
            action(book)
        } label: {
            HymnalView(
                book: book,
                index: books.firstIndex(of: book) ?? 0,
                isPinned: isPinned,
            )
            .swipeToPin(isPinned: isPinned) {
                HapticsManager.instance.trigger(.toggleSwitch)
                togglePin(for: book.key)
            }
        }
        .padding(.horizontal)
        .padding(.horizontal, sizeClass == .regular ? 32 : 0)
        .contextMenu {
            Button {
                HapticsManager.instance.trigger(.buttonPress)
                togglePin(for: book.key)
            } label: {
                Label(
                    pinnedKeys.contains(book.key) ? "Unpin" : "Pin",
                    systemImage: pinnedKeys.contains(book.key) ? "pin.slash.fill" : "pin.fill"
                )
            }
        }
    }
}

#Preview {
    HymnalsView(books: [
        .init(key: "shona", language: "Shona", title: "Shona", isSelected: true),
        .init(key: "cis", language: "English", title: "Christ In Song"),
        .init(key: "shona-2", language: "Cristu Munzwiyo", title: "Shona")
    ], action: { _ in }, dismissAction: { })
}
