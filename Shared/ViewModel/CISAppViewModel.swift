//
//  CISAppViewModel.swift
//  iOS
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation

final class CISAppViewModel: ObservableObject {
    // MARK: - Properties
    private var store: Store
    
    // MARK: - Published properties
    @Published var isLoadingStore: Bool = true
    @Published var allBooks: [StoreBook] = []
    @Published var allCollections: [StoreCollection] = []
    @Published var hymnsFromSelectedBook: [StoreHymn] = []
    @Published var selectedBook: StoreBook?
    @Published var selectedHymn: StoreHymn?
    @Published var selectedBookTitle: String?
    @Published var bookSelectionShown: Bool = false
    @Published var collectionsSheetShown: Bool = false
    
    @Published var bookSearchQuery: String = ""
    
    // MARK: - Initialization
    init(store: Store) {
        self.store = store
        self.store.onStoreLoaded = { [weak self] in
            self?.isLoadingStore = false
            self?.refreshAppContent()
        }
    }
    
    // MARK: - Functions
    
    func refreshAppContent() {
        fetchAllBooks()
        allCollections = fetchAllCollections()
    }
    
    /// Fetch all books from the `config.json` file
    /// It's important that this file is updated with the right key names otherwise this might lead to
    /// an inconsistent app state.
    func fetchAllBooks() {
        allBooks = store.retrieveAllBooks()
        if !allBooks.isEmpty {
            if store.retrieveSelectedBook() == nil {
                store.setSelectedBook(to: .defaultBook)
            }
            
            let selectedBookKey =  store.retrieveSelectedBook() ?? .defaultBook
            
            
            selectedBook = allBooks.first(where: { $0.key == selectedBookKey })
            
            // Fetch all the hymns from the selected book
            if let fetchedHymns = fetchHymns(from: selectedBookKey) {
                hymnsFromSelectedBook = fetchedHymns
            }
            
        } else {
            print("We're unable to fetch books, file is missing or corrupt")
            // TODO: To fix
            // We're unable to fetch books, file is missing or corrupt
            // Handle this scenario
        }
    }
    
    func fetchHymns(from bookKey: String) -> [StoreHymn]? {
        return store.retrieveHymns(from: bookKey)
    }
    
    func fetchAllCollections() -> [StoreCollection]{
        store.retrieveAllCollections()
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
    
    func getNextOrPreviousHymn(to hymn: StoreHymn, swipeDirection: SwipeDirection) -> StoreHymn? {
        let hymns = store.retrieveHymns(from: hymn.book)
        switch swipeDirection {
        case .forward:
            return hymns?.first(where: {$0.number == hymn.number + 1})
        case .backward:
            return hymns?.first(where: {$0.number == hymn.number - 1})
        }
    }
    
    func setSelectedHymn(to hymn: StoreHymn) {
        selectedHymn = hymn
    }
    
    func toggle(hymn: StoreHymn, collection: StoreCollection) {
        store.toggle(hymn: hymn, in: collection)
        refreshAppContent()
    }
    
    func addCollection(with title: String, and about: String?){
        
        // Check if title is empty
        if title.trimmed.isEmpty {
            return
        }
        let aboutStr = about?.trimmingCharacters(in: .whitespacesAndNewlines)
        store.createCollection(with: title, and: aboutStr)
        allCollections = store.retrieveAllCollections()
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
        
        fetchAllBooks()
    }
    
    func removeCollection(with id: UUID) {
        store.removeCollection(with: id)
        allCollections = fetchAllCollections()
    }
    
    func removeHymn(with id: UUID, fromCollectionId collectionId: UUID) {
        store.removeHymn(with: id, from: collectionId)
        allCollections = fetchAllCollections()
    }
    
    enum SwipeDirection {
        case forward
        case backward
    }
}

#if DEBUG
class PreviewStore: Store {
    var onStoreLoaded: (() -> Void)?
    
    func retrieveAllBooks() -> [StoreBook] {
        return [
            StoreBook(key: "english", language: "English", title: "Christ In Song", isSelected: true, refrainLabel: "Chorus"),
            StoreBook(key: "swahili", language: "Swahili", title: "Nyimbo Za Kristo", isSelected: false, refrainLabel: "Kibwagizo")
        ]
    }
    
    func retrieveHymns(from book: String) -> [StoreHymn]? {
        let dummyLyric1 = StoreLyric(type: "verse", index: 1, lines: ["There's a land that is fairer than day,", "And by faith we can see it afar;"])
        let dummyLyric2 = StoreLyric(type: "refrain", index: nil, lines: ["In the sweet by and by,", "We shall meet on that beautiful shore."])
        
        return [
            StoreHymn(id: UUID(), title: "Sweet By And By", titleStr: "Sweet By And By", lyrics: [dummyLyric1, dummyLyric2], book: "english", number: 428),
            StoreHymn(id: UUID(), title: "O For A Thousand Tongues", titleStr: "O For A Thousand Tongues", lyrics: [dummyLyric1], book: "english", number: 1)
        ]
    }
    
    func retrieveSelectedBook() -> String? { "english" }
    func setSelectedBook(to bookName: String) {}
    func retrieveAllCollections() -> [StoreCollection] { [] }
    func createCollection(with title: String, and about: String?) {}
    func removeCollection(with id: UUID) {}
    func removeHymn(with id: UUID, from collectionID: UUID) {}
    func toggle(hymn: StoreHymn, in collection: StoreCollection) {}
}

extension CISAppViewModel {
    static var sample: CISAppViewModel {
        let store = PreviewStore()
        let vm = CISAppViewModel(store: store)
        vm.isLoadingStore = false
        store.onStoreLoaded?()
        return vm
    }
}
#endif
