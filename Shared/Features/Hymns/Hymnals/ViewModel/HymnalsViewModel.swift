//
//  HymnalsViewModel.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/20.
//

import Foundation
import Combine

class HymnalsViewModel: ObservableObject {
    
    @Published var hymnals = [HymnalModel]()
    
    func onAppear(selectedId: String) {
        hymnals = getData(id: selectedId)
    }
    
    func hymnalSelected(id: String) {
        hymnals = hymnals.map { HymnalModel(model: $0, selected: $0.id == id)}
        let count = PersistenceController.shared.query(book: id)
        if count < 1 {
            let hymns = loadHymns(key: id)
            PersistenceController.shared.saveHymns(book: id, models: hymns)
        }
    }
    
    private func getData(id: String) -> [HymnalModel] {
        return [
            HymnalModel(id: "english", title: "Christ In Song", language: "English", selected: id == "english"),
            HymnalModel(id: "tswana", title: "Keresete Mo Kopelong", language: "Tswana", selected: id == "tswana"),
            HymnalModel(id: "sotho", title: "Keresete Pineng", language: "Sotho", selected: id == "sotho"),
            HymnalModel(id: "chichewa", title: "Khristu Mu Nyimbo", language: "Chichewa", selected: id == "chichewa"),
            HymnalModel(id: "tonga", title: "Kristu Mu Nyimbo", language: "Tonga", selected: id == "tonga"),
            HymnalModel(id: "shona", title: "Kristu MuNzwiyo", language: "Shona", selected: id == "shona"),
            HymnalModel(id: "venda", title: "Ngosha YaDzingosha", language: "Venda", selected: id == "venda"),
            HymnalModel(id: "swahili", title: "Nyimbo Za Kristo", language: "Swahili", selected: id == "swahili"),
            HymnalModel(id: "ndebele", title: "UKrestu Esihlabelelweni", language: "Ndebele/IsiZulu", selected: id == "ndebele"),
            HymnalModel(id: "xhosa", title: "UKristu Engomeni", language: "IsiXhosa", selected: id == "xhosa")
        ]
    }
}
