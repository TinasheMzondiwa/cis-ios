//
//  Data.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/18.
//

import Foundation

let hymnalsData: [RemoteHymnal] = [
    RemoteHymnal(key: "english", title: "Christ In Song", language: "English"),
    RemoteHymnal(key: "tswana", title: "Keresete Mo Kopelong", language: "Tswana"),
    RemoteHymnal(key: "sotho", title: "Keresete Pineng", language: "Sotho"),
    RemoteHymnal(key: "chichewa", title: "Khristu Mu Nyimbo", language: "Chichewa"),
    RemoteHymnal(key: "tonga", title: "Kristu Mu Nyimbo", language: "Tonga"),
    RemoteHymnal(key: "shona", title: "Kristu MuNzwiyo", language: "Shona"),
    RemoteHymnal(key: "venda", title: "Ngosha YaDzingosha", language: "Venda"),
    RemoteHymnal(key: "swahili", title: "Nyimbo Za Kristo", language: "Swahili"),
    RemoteHymnal(key: "ndebele", title: "UKrestu Esihlabelelweni", language: "Ndebele/IsiZulu"),
    RemoteHymnal(key: "xhosa", title: "UKristu Engomeni", language: "IsiXhosa")
]

func loadHymns(key: String) -> [Hymn] {
    return load(key + ".json")
}

private func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
