//
//  HymnViewModel.swift
//  iOS
//
//  Created by Tinashe Mzondiwa on 2023-01-29.
//

import Foundation

class OldHymnViewModel : ObservableObject {
    
    private(set) lazy var persistance: PersistenceControllerProtocol = {
        PersistenceController.shared
    }()
    
    @Published private(set) var model: HymnModel?
    @Published private(set) var hymnal: HymnalModel?
    @Published private(set) var currState: (message: String, state: AlertState)?
    @Published var showingHUD = false
    
    func onAppear(hymn: HymnModel) {
        self.model = hymn
    }
    
    func switchHymnal(hymnal: HymnalModel) {
        if let model = model, let hymn = persistance.queryHymn(number: model.number, book: hymnal.id) {
            currState = nil
            self.model = HymnModel(hymn: hymn, bookTitle: hymnal.title)
            self.hymnal = hymnal
        } else if let model = model {
            currState = ("Hymn \(model.number) unvailable in \(hymnal.title).", .warning)
            showingHUD = true
        } else {
            self.model = nil
        }
    }
    
}
