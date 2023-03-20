//
//  StoreBook.swift
//  iOS
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation

public struct StoreBook: Identifiable, Equatable {
    /// Use the key to uniquely identify a book
    public var id: String {
        self.key
    }
    /// Unique key to the book
    public let key: String
    /// Language of the hymns
    public let language: String
    /// Title to the book
    public let title: String
//    /// Array of the hymns  in this book
//    public let hymns: [StoreHymn]
    
    public init(key: String, language: String, title: String) {
        self.key = key
        self.language = language
        self.title = title
//        self.hymns = hymns
    }
}
