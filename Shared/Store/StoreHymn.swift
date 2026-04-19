//
//  StoreHymn.swift
//  iOS
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation

public struct StoreLyric: Equatable, Codable, Identifiable {
    public var id: UUID { UUID() }
    
    public let type: String
    public let index: Int?
    public let lines: [String]
    
    public init(type: String, index: Int? = nil, lines: [String]) {
        self.type = type
        self.index = index
        self.lines = lines
    }
}

public struct StoreHymn: Identifiable, Equatable {
    /// Unique ID
    public let id: UUID
    /// Title of the Hymn
    public let title: String
    /// Title of the Hymn with the number inverted
    public let titleStr: String
    /// Lyrics of the Hymn
    public let lyrics: [StoreLyric]
    /// Key to book to which the hymn belongs
    public let book: String
    /// Hymn number
    public let number: Int
    
    public init(id: UUID, title: String, titleStr: String, lyrics: [StoreLyric], book: String, number: Int) {
        self.id = id
        self.title = title
        self.titleStr = titleStr
        self.lyrics = lyrics
        self.book = book
        self.number = number
    }
}
