//
//  HymnalAppData.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/19.
//

import Foundation

class HymnalAppData: ObservableObject {
    @Published var hymnal: Hymnal = Hymnal(key: "english", title: "Christ In Song", language: "English")
    @Published var hymnals: [RemoteHymnal] = []
    @Published var hymns: [Hymn] = loadHymns(key: "english")
    @Published var isShowingHymnals = false
}
