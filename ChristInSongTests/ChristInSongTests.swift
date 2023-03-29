//
//  ChristInSongTests.swift
//  ChristInSongTests
//
//  Created by George Nyakundi on 10/03/2023.
//

import XCTest
@testable import ChristInSong

final class ChristInSongTests: XCTestCase {

    func test_init_performsOrderedFetch_of_booksHymnsCollections() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.messages, [
            .retrieveAllBooks,
            .retrieveAllCollections]
        )
    }
    
    func test_fetchAllBooks_receivesBooksReturnedFromStore() {
        let (sut, store) = makeSUT()
        store.completeFetchAllBooks(with: [.book()])
        sut.fetchAllBooks()
        
        XCTAssertEqual(sut.allBooks, [.book()])
    }
    
    func test_fetchAllBooks_checksForDefaultBook_and_setsDefaultBookIfIsNil() {
        let (sut, store) = makeSUT()
        store.completeFetchAllBooks(with: [.book()])
        // NOTE: This adds an extra call to `retrieveAllBooks`
        // Improvement will be to make the call asynchronous and make `fetchAllBooks` return a list of books or an error
        sut.fetchAllBooks()
        
        XCTAssertEqual(store.messages, [
            // Calls from `init`
            .retrieveAllBooks,
            .retrieveAllCollections,
            // Calls from `fetchAllBooks`
            .retrieveAllBooks,
            .retrieveSelectedBook,
            .setSelectedBook(.defaultBookKey),
            .retrieveSelectedBook,
            .retrieveHymns(.defaultBookKey)]
        )
        
        XCTAssertEqual(sut.selectedBook, .book())
        XCTAssertEqual(sut.allBooks, [.book()])
    }
    
    func test_fetchHymns_fromDefaultBook_returnsAllHymnsFromBookFromTheStore() {
        let (sut, store) = makeSUT()
        let fetchedHymns = sut.fetchHymns(from: .defaultBookKey)
        XCTAssertEqual(fetchedHymns, store.hymnsFromSelectedBook)
        
        XCTAssertEqual(store.messages, [
            // Calls from `init`
            .retrieveAllBooks,
            .retrieveAllCollections,
            
            // Call from `fetchHymns(from: .defaultBookKey)`
            .retrieveHymns(.defaultBookKey)
        ])
    }
    
    func test_fetchHymns_fromAnNonExistentBook_returnsNil_when_storeRespondsWithNil() {
        let (sut, store) = makeSUT()
        let fetchedHymns = sut.fetchHymns(from: .nonExistentBook)
        XCTAssertNil(fetchedHymns)
        XCTAssertEqual(fetchedHymns, store.hymnsFromSelectedBook)
    }
    
    func test_fetchAllCollections_returnsEmptyList_whenTheStoreRespondsWithNil() {
        let (sut, store) = makeSUT()
        store.completeFetchAllCollections(with: nil)
        let fetchedCollections = sut.fetchAllCollections()
        
        XCTAssertEqual(fetchedCollections,[])
        
        XCTAssertEqual(store.messages, [
            // Calls from `init`
            .retrieveAllBooks,
            .retrieveAllCollections,
            
            .retrieveAllCollections]
        )
    }
    
    func test_fetchAllCollections_returnsListOfCollections_whenTheStoreRespondsWithAListOfCollection() {
        let (sut, store) = makeSUT()
        let id = UUID()
        let collection: StoreCollection = .collection(id)
        store.completeFetchAllCollections(with: [collection])
        let fetchedCollections = sut.fetchAllCollections()
        
        XCTAssertEqual(fetchedCollections,[collection])
        
        XCTAssertEqual(store.messages, [
            // Calls from `init`
            .retrieveAllBooks,
            .retrieveAllCollections,
            
            .retrieveAllCollections]
        )
    }
    
    func test_get_similarHymn_returnsNIL_WhenSimilarHymnIsNotFound() {
        let firstBook: StoreBook = .book()
        let secondBook: StoreBook = .book(key: .secondBookKey, language: .secondLanguage, title: .secondLanguage)
        let firstHymn: StoreHymn = .hymn(number: 1, book: .defaultBookKey)
        let secondHymn: StoreHymn = .hymn(number: 1, book: .secondBookKey)
        let thirdHymn: StoreHymn = .hymn(number: 2, book: .defaultBook)
        
        let (sut, store) = makeSUT()
        store.completeFetchAllBooks(with: [firstBook, secondBook])
        store.populateAllHymns(with: [firstHymn, secondHymn, thirdHymn])
        
        let fetchedHymn = sut.get(similarHymnTo: thirdHymn, from: secondBook)
        XCTAssertEqual(fetchedHymn, nil)
    }
    
    func test_get_similarHymn_returnsHymn_WhenSimilarHymnIsFound() {
        let firstBook: StoreBook = .book()
        let secondBook: StoreBook = .book(key: .secondBookKey, language: .secondLanguage, title: .secondLanguage)
        let firstHymn: StoreHymn = .hymn(number: 1, book: .defaultBookKey)
        let secondHymn: StoreHymn = .hymn(number: 1, book: .secondBookKey)
        let thirdHymn: StoreHymn = .hymn(number: 2, book: .defaultBook)
        
        let (sut, store) = makeSUT()
        store.completeFetchAllBooks(with: [firstBook, secondBook])
        store.populateAllHymns(with: [firstHymn, secondHymn, thirdHymn])
        
        let fetchedHymn = sut.get(similarHymnTo: firstHymn, from: secondBook)
        XCTAssertEqual(fetchedHymn, secondHymn)
    }
    
    func test_addCollection_savesCollectionWithTitleAndEmptyDescription() {
        let (sut, store) = makeSUT()
        let title = "Awesome Collection"
        
        sut.addCollection(with: title, and: nil)
        XCTAssertEqual(store.messages, [
            // Calls from `init`
            .retrieveAllBooks,
            .retrieveAllCollections,
            
            .createCollection(title, nil),
            .retrieveAllCollections
        ])
    }
    
    func test_SetSelectedBook_messagesStore_withBookKey() {
        let(sut, store) = makeSUT()
        sut.selectedBook = .book()
        let anotetherBook: StoreBook = .book(key: "another-key", language: "Special Language")
        
        sut.setSelectedBook(to: anotetherBook)
        
        XCTAssertEqual(store.messages, [
            .retrieveAllBooks,
            .retrieveAllCollections,
            .setSelectedBook("another-key"),
            .retrieveAllBooks
        ])
    }
    
    func test_removeCollection_messagesStoreWithTheRespectiveCollectionID() {
        let (sut, store) = makeSUT()
        let collectionId: UUID = UUID()
        
        sut.removeCollection(with: collectionId)
        
        XCTAssertEqual(store.messages, [
            .retrieveAllBooks,
            .retrieveAllCollections,
            .removeCollection(collectionId),
            .retrieveAllCollections
        ])
    }
    
    func test_setSelectedHymn() {
        let (sut, _) = makeSUT()
        let hymn: StoreHymn = .hymn()
        
        sut.setSelectedHymn(to: hymn)
        
        XCTAssertEqual(sut.selectedHymn, hymn)
    }
    
    func test_toggleBookSelectionSheet() {
        let (sut, _) = makeSUT()
        let currentToggle = sut.bookSelectionShown
        
        sut.toggleBookSelectionSheet()
        XCTAssertEqual(sut.bookSelectionShown, !currentToggle)
    }
    
    func test_toggleCollectionSheetVisibility() {
        let (sut, _) = makeSUT()
        let currentToggleStatus = sut.collectionsSheetShown
        
        sut.toggleCollectionSheetVisibility()
        XCTAssertEqual(sut.collectionsSheetShown, !currentToggleStatus)
    }
    
    func test_toggleBookSelectionShownFromHymnView() {
        let (sut, _) = makeSUT()
        let currentToggleStatus = sut.bookSelectionShownFromHymnView
        
        sut.toggleBookSelectionShownFromHymnView()
        XCTAssertEqual(sut.bookSelectionShownFromHymnView, !currentToggleStatus)
    }
    
    func test_toggleHymn_inCollection_messagesStoreWithHymnAndCollection() {
        let hymn: StoreHymn = .hymn()
        let collection: StoreCollection = .collection()
        
        let (sut, store) = makeSUT()
        sut.toggle(hymn: hymn, collection: collection )
        
        XCTAssertEqual(store.messages, [
            .retrieveAllBooks,
            .retrieveAllCollections,
            .toggle(hymn, collection),
            .retrieveAllBooks,
            .retrieveAllCollections
        ])
    }
    
    func test_removeHymn_fromCollection_messagesStore() {
        let hymn: StoreHymn = .hymn()
        let collection: StoreCollection = .collection()
        
        let (sut, store) = makeSUT()
        sut.removeHymn(with: hymn.id, fromCollectionId: collection.id)
        
        XCTAssertEqual(store.messages, [
            .retrieveAllBooks,
            .retrieveAllCollections,
            .removeHym(hymn.id, collection.id),
            .retrieveAllCollections ])
    }
    
    
    // MARK: - Private
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: CISAppViewModel, store: StoreSpy) {
        let store = StoreSpy()
        let sut = CISAppViewModel(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}
