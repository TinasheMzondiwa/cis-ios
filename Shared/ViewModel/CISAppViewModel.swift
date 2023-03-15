//
//  CISAppViewModel.swift
//  iOS
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation

final class CISAppViewModel: ObservableObject {
    // MARK: - Properties
    private let store: Store
    
    
    // MARK: - Published properties
    @Published var allBooks: [StoreBook] = []
    @Published var allCollections: [StoreCollection] = []
    @Published var hymnsFromSelectedBook: [StoreHymn] = []
    @Published var selectedBook: StoreBook?
    @Published var selectedHymn: StoreHymn?
    @Published var selectedBookTitle: String?
    @Published var bookSelectionShown: Bool = false
    @Published var bookSelectionShownFromHymnView: Bool = false
    @Published var collectionsSheetShown: Bool = false
    
    @Published var bookSearchQuery: String = ""
    
    // MARK: - Initialization
    init(store: Store) {
        self.store = store
        refreshAppContent()
    }
    
    // MARK: - Functions
    
    func refreshAppContent() {
        fetchAllBooks()
        fetchAllCollections()
    }
    
    func fetchAllBooks(){
        allBooks = store.retrieveAllBooks()
        selectedBook = allBooks.first(where: { $0.isSelected == true })
        if let selectedBook {
            hymnsFromSelectedBook = store.retrieveHymns(from: selectedBook)
        }
    }
    
    func fetchAllCollections(){
        allCollections = store.retrieveAllCollections()
    }
    
    func toggleHymnsSorting(using option: Sort) {
        let initialList = hymnsFromSelectedBook
        let sortedList = initialList.sorted {
            switch option {
            case .titleStr:
                return $0.titleStr < $1.titleStr
            default:
                return $0.number < $1.number
            }
        }
        hymnsFromSelectedBook = sortedList
    }
    
    func get(similarHymnTo hymn: StoreHymn,from book: StoreBook) -> StoreHymn? {
        book.hymns.first(where: { $0.number == hymn.number })
    }
    
    func setSelectedHymn(to hymn: StoreHymn) {
        selectedHymn = hymn
    }
    
    func fetchSongsFromSelectedBook() { }
    func resetSwitchBooks() { }
    
    func addCollection(with title: String, and about: String?){ }
    func addHymnToCollection(hymn: StoreHymn, collection: StoreCollection) { }
    func toggleBookSelectionShownFromHymnView() {
        bookSelectionShownFromHymnView.toggle()
    }
    func toggleBookSelectionSheet() {
        bookSelectionShown.toggle()
    }
    
    func toggleCollectionSheetVisibility() {
        collectionsSheetShown.toggle()
    }
    
    func setSelectedBook(to storeBook: StoreBook) {
        toggleBookSelectionSheet()
        guard let selectedBook else { return }
        guard storeBook.id != selectedBook.id else { return }
        
        // TODO: - Switch to completion handlers
        if let _ = store.updateSelectedBook(from: selectedBook, to: storeBook) {
        } else {
            refreshAppContent()
        }
    }
    
    
    // MARK: - Private
}
