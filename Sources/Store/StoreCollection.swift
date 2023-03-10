//
//  StoreCollection.swift
//  iOS
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation

struct StoreCollection: Identifiable {
    /// Unique identifier of the Collection
    let id: UUID
    /// Title of the collection
    let title: String
    /// A short description of the collection
    let about: String?
    /// Date when the collection when created
    let dateCreated: Date
    /// Hymns belonging to the Collection
    let hymns: [StoreHymn]?
    
    init(id: UUID, title: String, dateCreated: Date, about: String? = nil, hymns: [StoreHymn]? = nil) {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.about = about
        self.hymns = hymns
    }
}
