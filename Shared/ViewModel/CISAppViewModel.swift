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
    @Published var bookSelectionShown: Bool = false
    @Published var bookSelectionShownFromHymnView: Bool = false
    @Published var collectionsSheetShown: Bool = false
    
    @Published var switchBooks: [StoreBook] = []
    @Published var bookSearchQuery: String = ""
    
    // MARK: - Initialization
    init(store: Store) {
        self.store = store
        fetchAllBooks()
        fetchAllCollections()
    }
    
    // MARK: - Functions
    func fetchAllBooks(){
        allBooks = store.retrieveAllBooks()
        switchBooks = allBooks
        selectedBook = allBooks.first(where: { $0.isSelected == true })
        if let selectedBook {
            hymnsFromSelectedBook = store.retrieveHymns(from: selectedBook)
            filteredHymnsFromSelectedBook = hymnsFromSelectedBook
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
    
    func setSelectedBook(to storeBook: StoreBook) { }
    func setSelectedHymn(to selectedHymn: StoreHymn) { }
    func switchSongfromBook(to storeBook: StoreBook) {}
    func toggleBookSelectionSheet() { }
    func fetchSongsFromSelectedBook() { }
    func resetSwitchBooks() { }
    func toggleCollectionSheetVisibility() { }
    func addCollection(with title: String, and about: String?){ }
    func addHymnToCollection(hymn: StoreHymn, collection: StoreCollection) { }
    
    
    // MARK: - Private
}
