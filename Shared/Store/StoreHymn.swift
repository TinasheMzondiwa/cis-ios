//
//  StoreHymn.swift
//  iOS
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation

public struct StoreHymn: Identifiable, Equatable {
    /// Unique ID
    public let id: UUID
    /// Title of the Hymn
    public let title: String
    /// Title of the Hymn with the number inverted
    public let titleStr: String
    /// Content of the Hymn
    public let content: String
    /// Modified version of thy hymn, defaults to content
    public let editedContent: String?
    /// Favorite flag
    public let isFavorite: Bool
    /// Hymn number
    public let number: Int
    
    public init(id: UUID, title: String, titleStr: String, content: String, editedContent: String? = nil , isFavorite: Bool = false, number: Int) {
        self.id = id
        self.title = title
        self.titleStr = titleStr
        self.content = content
        self.editedContent = editedContent
        self.isFavorite = isFavorite
        self.number = number
    }
}
