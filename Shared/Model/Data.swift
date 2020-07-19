//
//  Data.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/18.
//

import Foundation

let hymnalData: Hymnal = load("english.json")
let hymnalsData: [Hymnal] = [
    Hymnal(key: "english", title: "Christ In Song", language: "English", hymns: []),
    Hymnal(key: "tswana", title: "Keresete Mo Kopelong", language: "Tswana", hymns: []),
    Hymnal(key: "sotho", title: "Keresete Pineng", language: "Sotho", hymns: []),
    Hymnal(key: "chichewa", title: "Khristu Mu Nyimbo", language: "Chichewa", hymns: []),
    Hymnal(key: "tonga", title: "Kristu Mu Nyimbo", language: "Tonga", hymns: []),
    Hymnal(key: "shona", title: "Kristu MuNzwiyo", language: "Shona", hymns: []),
    Hymnal(key: "venda", title: "Ngosha YaDzingosha", language: "Venda", hymns: []),
    Hymnal(key: "swahili", title: "Nyimbo Za Kristo", language: "Swahili", hymns: []),
    Hymnal(key: "ndebele", title: "UKrestu Esihlabelelweni", language: "Ndebele/IsiZulu", hymns: []),
    Hymnal(key: "xhosa", title: "UKristu Engomeni", language: "IsiXhosa", hymns: [])
]

func load<T: Decodable>(_ filename: String) -> T {
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
