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
    private let defaults = UserDefaults.standard
    
    
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
    
    /// Fetch all books from the `config.json` file
    /// It's important that this file is updated with the right key names otherwise this might lead to
    /// an inconsistent app state.
    func fetchAllBooks(){
        allBooks = store.retrieveAllBooks()
        if !allBooks.isEmpty {
            // If no book has been selected - Select the English book by default
            if defaults.string(forKey: .selectedBook) == nil {
                store.setSelectedBook(to: .defaultBook)
            }
            
            let selectedBookKey = store.retrieveSelectedBook() ?? .defaultBook
            
            selectedBook = allBooks.first(where: { $0.key == selectedBookKey })
            
            // Fetch all the hymns from the selected book
            if let fetchedHymns = fetchHymns(from: selectedBookKey) {
                hymnsFromSelectedBook = fetchedHymns
            }
            
        } else {
            // TODO: To fix
            // We're unable to fetch books, file is missing or corrupt
            // Handle this scenario
        }
    }
    
    func fetchHymns(from bookKey: String) -> [StoreHymn]? {
        return store.retrieveHymns(from: bookKey)
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
        let hymns = store.retrieveHymns(from: book.key)
        
        return hymns?.first(where: {$0.number == hymn.number})
    }
    
    func setSelectedHymn(to hymn: StoreHymn) {
        selectedHymn = hymn
    }
    
    func fetchSongsFromSelectedBook() { }
    func resetSwitchBooks() { }
    
    
    func addHymnToCollection(hymn: StoreHymn, collection: StoreCollection) { }
    
    func addCollection(with title: String, and about: String?){
        
        // Check if title is empty
        if title.trimmed.isEmpty {
            return
        }
        store.createCollection(with: title, and: about)
        refreshAppContent()
    }
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
        guard storeBook.key != selectedBook.key else { return }
        
        store.setSelectedBook(to: storeBook.key)
        
        print("Selected Book: \(store.retrieveSelectedBook())")
        
        refreshAppContent()
        // TODO: - Switch to completion handlers
//        if let _ = store.updateSelectedBook(from: selectedBook, to: storeBook) {
//        } else {
//            refreshAppContent()
//        }
    }
    
    
    // MARK: - Private
}
