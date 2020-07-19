//
//  Data.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/18.
//

import Foundation

let hymnalsData: [Hymnal] = [
    Hymnal(key: "english", title: "Christ In Song", language: "English"),
    Hymnal(key: "tswana", title: "Keresete Mo Kopelong", language: "Tswana"),
    Hymnal(key: "sotho", title: "Keresete Pineng", language: "Sotho"),
    Hymnal(key: "chichewa", title: "Khristu Mu Nyimbo", language: "Chichewa"),
    Hymnal(key: "tonga", title: "Kristu Mu Nyimbo", language: "Tonga"),
    Hymnal(key: "shona", title: "Kristu MuNzwiyo", language: "Shona"),
    Hymnal(key: "venda", title: "Ngosha YaDzingosha", language: "Venda"),
    Hymnal(key: "swahili", title: "Nyimbo Za Kristo", language: "Swahili"),
    Hymnal(key: "ndebele", title: "UKrestu Esihlabelelweni", language: "Ndebele/IsiZulu"),
    Hymnal(key: "xhosa", title: "UKristu Engomeni", language: "IsiXhosa")
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
