//
//  SelectedData.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/19.
//

import Foundation

class HymnalAppData: ObservableObject {
    @Published var hymnal: Hymnal = hymnalsData[0]
    @Published var hymns: [Hymn] = loadHymns(key: "english")
    @Published var isShowingHymnals = false
}
