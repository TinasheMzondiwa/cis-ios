//
//  HymnalsView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct HymnalsView: View {
    
    @Environment(\.horizontalSizeClass) private var sizeClass: UserInterfaceSizeClass?
    
    let books: [StoreBook]
    let action: (StoreBook) -> Void
    let dismissAction: () -> Void
    
    @State private var filterQuery: String = ""
    
    private var filteredBooks: [StoreBook] {
        let terms = filterQuery.lowercased().split(separator: " ")
        if terms.isEmpty { return books }
        
        return books.filter { book in
            // Check if every word in the search query matches either title or language
            terms.allSatisfy { term in
                book.title.lowercased().contains(term) ||
                book.language.lowercased().contains(term)
            }
        }
    }
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(filteredBooks, id: \.id) {  book in
                        
                        Button(action: {
                            HapticsManager.instance.trigger(.success)
                            action(book)
                        }, label: {
                            HymnalView(book: book, index: books.firstIndex(of: book) ?? 0)
                        })
                    }
                }
                .padding([.leading, .trailing])
                .padding(.horizontal, sizeClass == .regular ? 32 : 0)
            }
            .navigationTitle(LocalizedStringKey("Hymnals"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        HapticsManager.instance.trigger(.light)
                        dismissAction()
                    }, label: {
                        SFSymbol.close
                            .navButtonStyle()
                    })
                }
            }
            .searchable(text: $filterQuery)
            .resignKeyboardOnDragGesture()
        }
        
    }
}

#Preview {
    HymnalsView(books: [], action: { _ in }, dismissAction: { })
}
