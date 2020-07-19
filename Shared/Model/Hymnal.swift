//
//  Hymnal.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/15.
//

import Foundation
import CoreData

struct Hymnal: Hashable, Codable {
    var key: String
    var title: String = ""
    var language: String = ""
}
