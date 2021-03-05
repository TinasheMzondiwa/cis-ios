//
//  PersistenceController.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/21.
//

import Foundation
import CoreData

protocol PersistenceControllerProtocol {
    func save()
    func query(book: String) -> Int
    func queryHymn(id: UUID) -> Hymn?
    func saveHymns(book: String, models: [JsonHymn])
    func saveCollection(title: String, about: String)
    func queryCollection(id: UUID) -> Collection?
    func queryCollections() -> Int
    func delete(item: NSManagedObject)
}

struct PersistenceController : PersistenceControllerProtocol {
    
    // A singleton for our entire app to use
    static let shared = PersistenceController()
    
    // Storage for Core Data
    let container: NSPersistentContainer
    
    // A test configuration for SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        
        // Create 10 example hymns.
        for i in 0..<10 {
            let hymn = Hymn(context: controller.container.viewContext)
            hymn.content = ""
            hymn.book = "english"
            hymn.title = "Title \(i)"
        }
        
        return controller
    }()
    
    // An initializer to load Core Data, optionally able
    // to use an in-memory store.
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
        
        initData()
    }
    
    // Load initial hymns
    private func initData() {
        let defBook = "english"
        let count = query(book: defBook)
        if count == 0 {
            let hymns = loadHymns(key: defBook)
            saveHymns(book: defBook, models: hymns)
        }
    }
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
            }
        }
    }
    
    func query(book: String) -> Int {
        let context = container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Hymn")
        let predicate = NSPredicate(format: "book == %@", book)
        request.predicate = predicate
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 1
        
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            return 0
        }
    }
    
    func queryHymn(id: UUID) -> Hymn? {
        let context = container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Hymn")
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let results =  try context.fetch(request)
            if !results.isEmpty, let hymn = results.first as? Hymn {
                return hymn
            }
            return nil
        } catch {
            return nil
        }
    }
    
    func saveHymns(book: String, models: [JsonHymn]) {
        let context = container.viewContext
        
        for model in models {
            let hymn = Hymn(context: context)
            hymn.id = UUID()
            hymn.book = book
            hymn.title = model.title
            hymn.number = Int16(model.number)
            hymn.content = model.content
        }
        
        save()
    }
    
    func saveCollection(title: String, about: String) {
        let context = container.viewContext
        
        let collection = Collection(context: context)
        collection.id = UUID()
        collection.title = title
        collection.about = about
        collection.created = Date()
        
        save()
    }
    
    func queryCollection(id: UUID) -> Collection? {
        let context = container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Collection")
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let results =  try context.fetch(request)
            if !results.isEmpty, let collection = results.first as? Collection {
                return collection
            }
            return nil
        } catch {
            return nil
        }
    }
    
    func queryCollections() -> Int {
        let context = container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Collection")
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 1
        
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            return 0
        }
    }
    
    func delete(item: NSManagedObject) {
        let context = container.viewContext
        context.delete(item)
        save()
    }
}
