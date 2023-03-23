//
//  MockStore.swift
//  ChristInSongTests
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation
import ChristInSong

final class MockStore: Store {
    func retrieveAllCollections() -> [ChristInSong.StoreCollection] {
        [.dummyCollection()]
    }
    
    func retrieveHymns(from book: String) -> [ChristInSong.StoreHymn]? {
        nil
    }
    
    func retrieveHymn(with id: UUID) -> ChristInSong.Hymn? {
        nil
    }
    
    func setSelectedBook(to bookName: String) {}
    
    func retrieveSelectedBook() -> String? { nil }
    
    func createCollection(with title: String, and about: String?) {}
    
    func retrieveCollection(with id: UUID) -> ChristInSong.Collection? { nil }
    
    func removeCollection(with id: UUID) {}
    
    func toggle(hymn: ChristInSong.StoreHymn, in collection: ChristInSong.StoreCollection) {}
    
    func retreiveAllCollections() -> [ChristInSong.StoreCollection] {
        return [.dummyCollection()]
    }
    
    func retrieveAllBooks() -> [ChristInSong.StoreBook] {
        return [.dummyBook()]
    }
}

extension StoreBook {
    static func dummyBook(_ id: UUID = UUID(), _ number: Int = 1) -> StoreBook {
        StoreBook(key: "dummy", language: "Language", title: "Title")
    }
}

extension StoreHymn {
    
    static func dummyHymn(_ id: UUID = UUID(), _ number: Int = 1) -> StoreHymn {
        StoreHymn(id: id, title: "Dummy Title", titleStr: "Dummy Title", content: "a very long hymn", number: number)
    }
}

extension StoreCollection {
    static func dummyCollection(_ id: UUID = UUID()) -> StoreCollection {
        StoreCollection(id: id, title: "Dummy title", dateCreated: .now)
    }
}
