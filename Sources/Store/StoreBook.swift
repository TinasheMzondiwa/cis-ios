//
//  StoreBook.swift
//  iOS
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation

public struct StoreBook: Identifiable {
    /// Unique identifier to the Book
    public let id: UUID
    /// Flag indicating if a the book is selected. Only one book can be selected at a time.
    public let isSelected: Bool
    /// Unique key to the book
    public let key: String
    /// Language of the hymns
    public let language: String
    /// Title to the book
    public let title: String
    /// Title of the book, without the song number
    public let titleStr: String
    /// Array of the hymns  in this book
    public let hymns: [StoreHymn]
    
    public init(id: UUID, isSelected: Bool, key: String, language: String, title: String,
         titleStr: String, hymns: [StoreHymn]) {
        self.id = id
        self.isSelected = isSelected
        self.key = key
        self.language = language
        self.title = title
        self.titleStr = titleStr
        self.hymns = hymns
    }
}
