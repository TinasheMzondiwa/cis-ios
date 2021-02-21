//
//  Hymn.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/15.
//

import Foundation
import CoreData

struct Hymn: Hashable, Codable {
    var title: String = ""
    var number: Int = 0
    var content: String = ""
    var editedContent: String? = nil
}
