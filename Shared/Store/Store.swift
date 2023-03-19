//
//  Store.swift
//  iOS
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation

public protocol Store {
    /// Retrieve all books from the store
    /// - Returns: an array of ``StoreBook``
    func retrieveAllBooks() -> [StoreBook]
    func retrieveAllCollections() -> [StoreCollection]
    func retrieveHymns(from book: StoreBook) -> [StoreHymn]
    func retrieveHymns(from collection: StoreCollection) -> [StoreHymn]
    func updateSelectedBook(from book: StoreBook, to newBook: StoreBook) -> Error?
    func createCollection(with title: String, and about: String?) -> Error?
    func add(hymn: StoreHymn, to collection: StoreCollection) -> Error?
//    func saveCollection()
}


final class CISPersistence {
    
}


extension Hymn {
    func toStoreHymn() -> StoreHymn {
        StoreHymn(id: self.id!, title: self.title!, titleStr: self.titleStr!, content: self.content!, number: Int(self.number))
    }
}

extension Collection {
    func toStoreCollection() -> StoreCollection {
        StoreCollection(id: self.id!, title: self.title!, dateCreated: self.created!, about: self.about, hymns: (self.hymns?.allObjects as? [Hymn]).map{ $0.map { $0.toStoreHymn()}})
    }
}

extension String {
    static var StoreName = "Main"
    static var Hymn = "Hymn"
    static var Collection = "Collection"
}
