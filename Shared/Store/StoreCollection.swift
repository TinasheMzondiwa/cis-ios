//
//  StoreCollection.swift
//  iOS
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation

public struct StoreCollection: Identifiable {
    /// Unique identifier of the Collection
    public let id: UUID
    /// Title of the collection
    public let title: String
    /// A short description of the collection
    public let about: String?
    /// Date when the collection when created
    public let dateCreated: Date
    /// Hymns belonging to the Collection
    public let hymns: [StoreHymn]?
    
    public init(id: UUID, title: String, dateCreated: Date, about: String? = nil, hymns: [StoreHymn]? = nil) {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.about = about
        self.hymns = hymns
    }
}
