//
//  HymnalModel.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/20.
//

import Foundation

struct HymnalModel: Hashable, Codable {
    let id: String
    let title: String
    let language: String
    let selected: Bool
    
    init(id: String, title: String, language: String, selected: Bool = false) {
        self.id = id
        self.title = title
        self.language = language
        self.selected = selected
    }
    
    init(model: HymnalModel, selected: Bool) {
        self.id = model.id
        self.title = model.title
        self.language = model.language
        self.selected = selected
    }
}
