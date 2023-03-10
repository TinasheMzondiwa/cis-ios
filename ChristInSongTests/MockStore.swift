//
//  MockStore.swift
//  ChristInSongTests
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation
import ChristInSong

final class MockStore: Store {
    func retrieveAllBooks() -> [ChristInSong.StoreBook] {
        return [.dummyBook()]
    }
    
    
}

extension StoreBook {
    static func dummyBook(_ id: UUID = UUID(), _ number: Int = 1) -> StoreBook {
        StoreBook(id: id, isSelected: false, key: "dummy", language: "english", title: "\(number) - Dummy Book Title", titleStr: "Dummy Book Title - \(number)", hymns: [.dummyHymn()])
    }
}

extension StoreHymn {
    static func dummyHymn(_ id: UUID = UUID(), _ number: Int = 1) -> StoreHymn {
        StoreHymn(id: id, title: "Dummy Title", content: "A very long long *hymn*", number: number)
    }
}
