//
//  Hymnal.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/15.
//

import Foundation
import CoreData

struct Hymnal: Identifiable {
    var id = UUID()
    var title: String = ""
    var language: String = ""
}
