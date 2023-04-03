//
//  Store.swift
//  iOS
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation
import CoreData

/// Conform to this protocol to perfom any store operations within the CIS applicaiton
public protocol Store {
    /// Retrieve all books from the store
    /// - Returns: a list of ``StoreBook``
    func retrieveAllBooks() -> [StoreBook]
    /// Retrieves all collections from store
    /// - Returns: a list of ``StoreCollection``
    func retrieveAllCollections() -> [StoreCollection]
    /// Retrieves all hymns for a particular book
    /// - Parameter book: the `key` for the book
    /// - Returns: a list of store hymns when found and nil when no book is available
    func retrieveHymns(from book: String) -> [StoreHymn]?
    /// Sets a book as the selected book, by default during app launch hymns are fetched from this book
    /// - Parameter bookName: `key` to the book
    func setSelectedBook(to bookName: String)
    /// Retrieves the selected bookKey
    /// - Returns: book `key`
    func retrieveSelectedBook() -> String?
    /// Creates a new collection
    /// - Parameters:
    ///   - title: `title` to the the collection
    ///   - about: an optional `description` to the collection
    func createCollection(with title: String, and about: String?)
    /// Deletes a collection from the store
    /// - Parameter id: the unique `id` (UUID) of the collection
    func removeCollection(with id: UUID)
    /// Deletes a hymn from a collection
    /// - Parameter id: the unique `id` (UUID) of the hymn
    /// - Parameter collectionID: the unique `id` of the collection
    func removeHymn(with id: UUID, from collectionID: UUID)
    /// Toggle the presence of a hymn in a collection. (Removes/Add)
    /// - Parameters:
    ///   - hymn: hymn
    ///   - collection: collection
    func toggle(hymn: StoreHymn,in collection: StoreCollection)
}

extension Hymn {
    func toStoreHymn() -> StoreHymn {
        StoreHymn(id: self.id!, title: self.title!, titleStr: self.titleStr!, html: self.content, markdown: self.markdown ?? nil, book: self.book!, number: Int(self.number))
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
