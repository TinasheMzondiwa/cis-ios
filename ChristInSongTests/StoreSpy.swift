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
    private(set) var allBooks: [StoreBook]?
    private(set) var allHymns: [StoreHymn]?
    private(set) var hymnsFromSelectedBook: [StoreHymn]?
    private(set) var allCollections: [StoreCollection]?
    private(set) var selectedBook: String?
    
    func retrieveHymns(from book: String) -> [ChristInSong.StoreHymn]? {
        messages.append(.retrieveHymns(book))
        self.hymnsFromSelectedBook = allHymns?.filter { $0.book == book}
        return self.hymnsFromSelectedBook
    }
    
    func setSelectedBook(to bookName: String) {
        messages.append(.setSelectedBook(bookName))
        self.selectedBook = bookName
    }
    
    func retrieveSelectedBook() -> String? {
        messages.append(.retrieveSelectedBook)
        return self.selectedBook
    }
    
    func createCollection(with title: String, and about: String?) {
        messages.append(.createCollection(title, about))
    }
    
    func removeCollection(with id: UUID) {
        messages.append(.removeCollection(id))
    }
    
    func toggle(hymn: ChristInSong.StoreHymn, in collection: ChristInSong.StoreCollection) {
        messages.append(.toggle(hymn, collection))
    }
    
    func retrieveAllCollections() -> [ChristInSong.StoreCollection] {
        messages.append(.retrieveAllCollections)
        if let allCollections {
            return allCollections
        } else {
            return []
        }
    }
    
    func retrieveAllBooks() -> [ChristInSong.StoreBook] {
        messages.append(.retrieveAllBooks)
        if let allBooks {
            return allBooks
        } else {
            return []
        }
    }
    
    func completeFetchAllBooks(with books : [StoreBook]) {
        self.allBooks = books
    }
    
    func completeFetchAllCollections(with collections: [StoreCollection]?) {
        self.allCollections = collections
    }
    
    func populateAllHymns(with hymns: [StoreHymn]) {
        self.allHymns = hymns
    }
}

extension StoreSpy {
    enum Action: Equatable {
        
        case retrieveAllBooks
        case toggle(StoreHymn, StoreCollection)
        case removeCollection(UUID)
        case createCollection(String, String?)
        case retrieveSelectedBook
        case setSelectedBook(String)
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
            case (.createCollection(let lhsTitle, let lhsAbout), .createCollection(let rhsTitle, let rhsAbout)):
                return lhsTitle == rhsTitle && lhsAbout == rhsAbout
            case (.setSelectedBook(let lhsKey), .setSelectedBook(let rhsKey)):
                return lhsKey == rhsKey
            case (.retrieveHymns(let lhsBook), .retrieveHymns(let rhsBook)):
                return lhsBook == rhsBook
            default:
                return false
            }
        }
        
    }
}

extension StoreBook {
    static func book(_ id: UUID = UUID(),
                          key: String = .defaultBookKey,
                          language: String = .defaultLanguage,
                          title: String = .defaultTitle
    ) -> StoreBook {
        StoreBook(key: key, language: language, title: title)
    }
}

extension StoreHymn {
    
    static func hymn(_ id: UUID = UUID(), number: Int = 1, book: String = .defaultBookKey) -> StoreHymn {
        StoreHymn(id: id, title: "Dummy Title", titleStr: "Dummy Title", content: "a very long hymn", book: book, number: number)
    }
}

extension StoreCollection {
    static func dummyCollection(_ id: UUID = UUID(), date: Date = .now) -> StoreCollection {
        StoreCollection(id: id, title: "Dummy title", dateCreated: date)
    }
}

extension StoreCollection: Equatable {
    public static func == (lhs: StoreCollection, rhs: StoreCollection) -> Bool {
        lhs.id == rhs.id
    }
}


extension String {
    static var defaultBookKey = "english"
    static var secondBookKey = "swahili"
    static var defaultLanguage = "English"
    static var secondLanguage = "Swahili"
    static var defaultTitle = "Christ In Song"
    static var secondTitle = "Nyimbo Za Kristo"
    static var nonExistentBook = "i-am-not-a-real-book"
}
