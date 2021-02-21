//
//  Hymn.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/15.
//

import Foundation
import CoreData

struct HymnModel: Hashable, Codable {
    let id: UUID
    let bookTitle: String
    let title: String
    let number: Int
    let content: String
    let editedContent: String?
    
    init(hymn: Hymn, bookTitle: String) {
        self.id = hymn.id ?? UUID()
        self.bookTitle = bookTitle
        self.title = hymn.title ?? ""
        self.number = Int(hymn.number)
        self.content = hymn.content ?? ""
        self.editedContent = hymn.edited_content
    }
    
    init(content: String) {
        self.id = UUID()
        self.bookTitle = "Christ In Song"
        self.title = ""
        self.number = 1
        self.content = content
        self.editedContent = nil
    }
}
