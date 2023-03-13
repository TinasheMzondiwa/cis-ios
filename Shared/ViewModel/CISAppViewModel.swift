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
    
    // MARK: - Initialization
    init(store: Store) {
        self.store = store
    }
    
    // MARK: - Functions
    func fetchAllBooks(){ }
    func setSelectedBook(to storeBook: StoreBook) { }
    func setSelectedHymn(to selectedHymn: StoreHymn) { }
    func switchSongfromBook(to storeBook: StoreBook) {}
    func toggleBookSelectionSheet() { }
    func fetchSongsFromSelectedBook() { }
    func resetSwitchBooks() { }
    func toggleCollectionSheetVisibility() { }
    func addCollection(with title: String, and about: String?){ }
    func addHymnToCollection(hymn: StoreHymn, collection: StoreCollection) { }
    func fetchAllCollection(){ }
    
    // MARK: - Private
}
