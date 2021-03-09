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
    
    @Published var collectionHymns = [HymnModel]()
    @Published var collectionTitle: String = ""
    
    private var hymnsCollection: Collection? = nil
    
    func loadCollectionHymns(collectionId: UUID) {
        if let collection = persistance.queryCollection(id: collectionId) {
            self.hymnsCollection = collection
            
            collectionHymns = collection.allHymns.map {
                HymnModel(hymn: $0, bookTitle: collection.wrappedTitle)
            }
            collectionTitle = collection.wrappedTitle
        }
    }
    
    func removeHymnFromCollection(at offsets: IndexSet) {
        guard let collection = hymnsCollection else {
            return
        }
        
        for index in offsets {
            guard collectionHymns.count > index else { return }
            let model = collectionHymns[index]
            persistance.remove(from: collection, id: model.id)
        }
        
        guard let collectionId = collection.id else {
            return
        }
        loadCollectionHymns(collectionId: collectionId)
    }
    
    func saveCollection(title: String, about: String) {
        if title.trimmed.isEmpty {
            return
        }
        
        persistance.saveCollection(title: title.trimmed, about: about)
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
}
