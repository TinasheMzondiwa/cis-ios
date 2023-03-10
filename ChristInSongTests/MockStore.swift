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
    static func dummyBook(_ number: Int = 1) -> StoreBook {
        StoreBook(id: UUID(), isSelected: false, key: "dummy", language: "english", title: "\(number) - Dummy Book Title", titleStr: "Dummy Book Title - \(number)", hymns: [.dummyHymn()])
    }
}

extension StoreHymn {
    static func dummyHymn(_ number: Int = 1) -> StoreHymn {
        StoreHymn(id: UUID(), title: "Dummy Title", content: "A very long long *hymn*", number: number)
    }
}
