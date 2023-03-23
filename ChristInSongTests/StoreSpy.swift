//
//  MockStore.swift
//  ChristInSongTests
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation
import ChristInSong

final class StoreSpy: Store {
    
    private(set) var messages = [Action]()
    
    func retrieveAllCollections() -> [ChristInSong.StoreCollection] {
        messages.append(.retrieveAllCollections)
        return [.dummyCollection()]
    }
    
    func retrieveHymns(from book: String) -> [ChristInSong.StoreHymn]? {
        messages.append(.retrieveHymns(book))
        return nil
    }
    
    func retrieveHymn(with id: UUID) -> ChristInSong.Hymn? {
        messages.append(.retrieveHymn(id))
        return nil
    }
    
    func setSelectedBook(to bookName: String) {
        messages.append(.setSelectedBook(bookName))
    }
    
    func retrieveSelectedBook() -> String? {
        messages.append(.retrieveSelectedBook)
        return nil
    }
    
    func createCollection(with title: String, and about: String?) {
        messages.append(.createCollection(title, about))
    }
    
    func retrieveCollection(with id: UUID) -> ChristInSong.Collection? {
        messages.append(.retrieveCollection(id))
        return nil
    }
    
    func removeCollection(with id: UUID) {
        messages.append(.removeCollection(id))
    }
    
    func toggle(hymn: ChristInSong.StoreHymn, in collection: ChristInSong.StoreCollection) {
        messages.append(.toggle(hymn, collection))
    }
    
    func retreiveAllCollections() -> [ChristInSong.StoreCollection] {
        messages.append(.retrieveAllCollections)
        return [.dummyCollection()]
    }
    
    func retrieveAllBooks() -> [ChristInSong.StoreBook] {
        messages.append(.retrieveAllBooks)
        return [.dummyBook()]
    }
}

extension StoreSpy {
    enum Action: Equatable {
        
        case retrieveAllBooks
        case toggle(StoreHymn, StoreCollection)
        case removeCollection(UUID)
        case retrieveCollection(UUID)
        case createCollection(String, String?)
        case retrieveSelectedBook
        case setSelectedBook(String)
        case retrieveHymn(UUID)
        case retrieveHymns(String)
        case retrieveAllCollections
        
        static func == (lhs: StoreSpy.Action, rhs: StoreSpy.Action) -> Bool {
            switch (lhs, rhs) {
            case (.retrieveAllBooks, .retrieveAllBooks):
                return true
            case (.retrieveSelectedBook, .retrieveSelectedBook):
                return true
            case (.retrieveAllCollections, .retrieveAllCollections):
                return true
            case (.toggle(let lhsStoreHymn, let lhsStoreCollection), .toggle(let rhsStoreHymn, let rhsStoreCollection)):
                return lhsStoreHymn == rhsStoreHymn && lhsStoreCollection == rhsStoreCollection
            case (.removeCollection(let lhsId), .removeCollection(let rhsId)):
                return lhsId == rhsId
            case (.retrieveCollection(let lhsId), .retrieveCollection(let rhsId)):
                return lhsId == rhsId
            case (.createCollection(let lhsTitle, let lhsAbout), .createCollection(let rhsTitle, let rhsAbout)):
                return lhsTitle == rhsTitle && lhsAbout == rhsAbout
            case (.setSelectedBook(let lhsKey), .setSelectedBook(let rhsKey)):
                return lhsKey == rhsKey
            case (.retrieveHymn(let lhsId), .retrieveHymn(let rhsId)):
                return lhsId == rhsId
            case (.retrieveHymns(let lhsBook), .retrieveHymns(let rhsBook)):
                return lhsBook == rhsBook
            default:
                return false
            }
        }
        
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

extension StoreCollection: Equatable {
    public static func == (lhs: StoreCollection, rhs: StoreCollection) -> Bool {
        lhs.id == rhs.id
    }
}

