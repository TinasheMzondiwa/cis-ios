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
            .retrieveSelectedBook,
            .retrieveHymns("english"),
            .retrieveAllCollections]
        )
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
