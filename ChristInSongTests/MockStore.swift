//
//  MockStore.swift
//  ChristInSongTests
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation
import ChristInSong

final class MockStore: Store {
    func retreiveAllCollections() -> [ChristInSong.StoreCollection] {
        return [.dummyCollection()]
    }
    
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

extension StoreCollection {
    static func dummyCollection(_ id: UUID = UUID()) -> StoreCollection {
        StoreCollection(id: id, title: "Dummy title", dateCreated: .now)
    }
}
