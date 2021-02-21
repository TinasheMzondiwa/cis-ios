//
//  JsonHymn.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/21.
//

import Foundation

struct JsonHymn: Hashable, Codable {
    var title: String = ""
    var number: Int = 0
    var content: String = ""
    var editedContent: String? = nil
}
