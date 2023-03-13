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
//    func saveCollection()
}
