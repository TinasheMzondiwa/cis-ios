//
//  HymnView.swift
//  iOS
//
//  Created by George Nyakundi on 14/03/2023.
//

import SwiftUI

struct HymnView: View {
    
    @EnvironmentObject var vm: CISAppViewModel
    
    @State private var displayedBook: StoreBook?
    @State var displayedHymn: StoreHymn
    
    private var books: [StoreBook] {
//        if let displayedBook {
//            return vm.allBooks.map {
//                StoreBook(id: $0.id,
//                          isSelected: $0.id == displayedBook.id ,
//                          key: $0.key,
//                          language: $0.language,
//                          title: $0.title,
//                          hymns: $0.hymns
//                )
//            }
//        } else {
            return vm.allBooks
//        }
    }
    
    
    private func setSelectedBook(to book: StoreBook) {
//        if let newHymn = vm.get(similarHymnTo: displayedHymn, from: book) {
//            displayedBook = book
//            displayedHymn = newHymn
//        } else {
//            displayedBook = vm.selectedBook
//        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                Text(displayedHymn.content)
                    .padding()
            }
        }
        .navigationTitle(displayedBook?.title ?? vm.selectedBook?.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            ToolbarItemGroup {
                Button {
                    vm.toggleCollectionSheetVisibility()
                } label: {
                    SFSymbol.textPlus
                        .accessibility(label: Text(LocalizedStringKey("Collections.Add")))
                }
                
                Button {
                    vm.toggleBookSelectionShownFromHymnView()
                } label: {
                    SFSymbol.bookCircle
                        .accessibility(label: Text(LocalizedStringKey("Hymnals.Switch")))
                }
            }
        }
        .sheet(isPresented: $vm.bookSelectionShownFromHymnView) {
            BooksView(books: books) { book in
                setSelectedBook(to: book)
                vm.toggleBookSelectionShownFromHymnView()
                
            } dismissAction: {
                vm.toggleBookSelectionShownFromHymnView()
            }
        }
        .sheet(isPresented: $vm.collectionsSheetShown) {
            AddCollectionView(hymn: displayedHymn)
        }
    }
}
