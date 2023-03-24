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
