//
//  StoreBook.swift
//  iOS
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation

public struct StoreBook: Identifiable, Equatable {
    /// Unique identifier to the Book
    public let id: UUID
    /// Flag indicating if a the book is selected. Only one book can be selected at a time.
    public var isSelected: Bool
    /// Unique key to the book
    public let key: String
    /// Language of the hymns
    public let language: String
    /// Title to the book
    public let title: String
    /// Array of the hymns  in this book
    public let hymns: [StoreHymn]
    
    public init(id: UUID, isSelected: Bool, key: String, language: String, title: String,
         hymns: [StoreHymn]) {
        self.id = id
        self.isSelected = isSelected
        self.key = key
        self.language = language
        self.title = title
        self.hymns = hymns
    }
}
