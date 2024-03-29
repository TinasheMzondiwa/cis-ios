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
    /// Boolean flag for when book is selected
    public let isSelected: Bool
    
    public init(key: String, language: String, title: String, isSelected: Bool = false) {
        self.key = key
        self.language = language
        self.title = title
        self.isSelected = isSelected
    }
}
