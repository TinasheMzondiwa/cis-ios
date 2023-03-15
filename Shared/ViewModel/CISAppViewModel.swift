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
    
    func switchSongfromBook(to book: StoreBook) {
        print("Book: \(book)")
        guard let currentlySelectedHymn = selectedHymn else { return }
        
        let foundHymn = book.hymns.first(where: { $0.number == currentlySelectedHymn.number })
        if let foundHymn {
            selectedHymn = foundHymn
            selectedBookTitle = book.title
            
            let filterSwithBooks = switchBooks.map {
                return StoreBook(id:$0.id , isSelected: $0 == book, key: $0.key, language: $0.language, title: $0.language, hymns: $0.hymns)
            }
            switchBooks = filterSwithBooks
            bookSelectionShownFromHymnView.toggle()
        } else {
            return
        }
    }
    
    func get(similarHymnTo hymn: StoreHymn,from book: StoreBook) -> StoreHymn? {
        book.hymns.first(where: { $0.number == hymn.number })
    }
    
    func setSelectedBook(to storeBook: StoreBook) { }
    
    func setSelectedHymn(to hymn: StoreHymn) {
        selectedHymn = hymn
    }
    
    
    func fetchSongsFromSelectedBook() { }
    func resetSwitchBooks() { }
    func toggleCollectionSheetVisibility() {
        
    }
    func addCollection(with title: String, and about: String?){ }
    func addHymnToCollection(hymn: StoreHymn, collection: StoreCollection) { }
    func toggleBookSelectionShownFromHymnView() {
        bookSelectionShownFromHymnView.toggle()
    }
    func toggleBookSelectionSheet() {
        bookSelectionShown.toggle()
    }
    
    
    // MARK: - Private
}
