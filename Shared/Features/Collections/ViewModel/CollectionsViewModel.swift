//
//  CollectionsViewModel.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/25.
//

import Foundation
import Foundation

class CollectionsViewModel: ObservableObject {
    
    private(set) lazy var persistance: PersistenceControllerProtocol = {
        PersistenceController.shared
    }()
    
    @Published var collectionHymns = [HymnModel]()
    @Published var collectionTitle: String = ""
    @Published var emptyCollections: Bool = false
    
    func loadCollectionHymns(collectionId: UUID) {
        if let collection = persistance.queryCollection(id: collectionId) {
            collectionHymns = collection.allHymns.map {
                HymnModel(hymn: $0, bookTitle: collection.wrappedTitle)
            }
            collectionTitle = collection.wrappedTitle
        }
    }
    
    func saveCollection(title: String, about: String) {
        if title.isEmpty {
            return
        }
        
        persistance.saveCollection(title: title, about: about)
        emptyCollections = persistance.queryCollections() == 0
    }
    
    func toggleCollection(hymnId: UUID, collection: Collection) {
        guard let hymn = persistance.queryHymn(id: hymnId) else { return }
        
        if collection.allHymns.contains(hymn) {
            collection.removeFromHymns(hymn)
            hymn.removeFromCollection(collection)
        } else {
            collection.addToHymns(hymn)
            hymn.addToCollection(collection)
        }
        
        persistance.save()
    }
    
    func subscribeToCollections() {
        emptyCollections = persistance.queryCollections() == 0
    }
}
