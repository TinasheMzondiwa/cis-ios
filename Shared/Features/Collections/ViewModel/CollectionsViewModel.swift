//
//  CollectionsViewModel.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/25.
//

import Foundation

class CollectionsViewModel: ObservableObject {
    
    private(set) lazy var persistance: PersistenceControllerProtocol = {
        PersistenceController.shared
    }()
    
    func saveCollection(title: String, about: String) {
        if title.isEmpty {
            return
        }
        
        persistance.saveCollection(title: title, about: about)
    }
    
    func addHymnToCollection(hymnId: UUID, collectionId: UUID) {
        
    }
}
