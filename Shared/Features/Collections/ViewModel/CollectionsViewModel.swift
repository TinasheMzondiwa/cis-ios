//
//  CollectionsViewModel.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/25.
//

import Foundation
import Foundation

class CollectionsViewModel: ObservableObject {
    
    @Published var hymn: Hymn? = nil
    
    private(set) lazy var persistance: PersistenceControllerProtocol = {
        PersistenceController.shared
    }()
    
    func onAppear(hymnId: UUID) {
        hymn = persistance.queryHymn(id: hymnId)
    }
    
    func saveCollection(title: String, about: String) {
        if title.isEmpty {
            return
        }
        
        persistance.saveCollection(title: title, about: about)
    }
    
    func toggleCollection(collection: Collection) {
        guard let hymn = hymn else { return }
        
        if collection.allHymns.contains(hymn) {
            collection.removeFromHymns(hymn)
            hymn.removeFromCollection(collection)
        } else {
            collection.addToHymns(hymn)
            hymn.addToCollection(collection)
        }
        
        persistance.save()
    }
}
