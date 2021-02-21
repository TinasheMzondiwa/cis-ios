//
//  HymnalAppData.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/19.
//

import Foundation

class HymnalAppData: ObservableObject {
    @Published var hymnal: HymnalModel = HymnalModel(id: "english", title: "Christ In Song", language: "English")
    @Published var isShowingHymnals = false
}
