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
    /// Lyrics of the Hymn
    public let lyrics: [StoreLyric]
    /// Key to book to which the hymn belongs
    public let book: String
    /// Hymn number
    public let number: Int
    /// The english title of the hymn
    public let titleEnglish: String?
    /// Other hymnal references
    public let hymnalReferences: String?
    
    public init(id: UUID, title: String, lyrics: [StoreLyric], book: String, number: Int, titleEnglish: String?, hymnalReferences: String?) {
        self.id = id
        self.title = title
        self.lyrics = lyrics
        self.book = book
        self.number = number
        self.titleEnglish = titleEnglish
        self.hymnalReferences = hymnalReferences
    }
}
