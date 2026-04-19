//
//  CISCoreDataStore.swift
//  iOS
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation
import CoreData

final class CISCoreDataStore: Store {
   
    var onStoreLoaded: (() -> Void)?
    private let container: NSPersistentContainer
    private let defaults = UserDefaults.standard
    
    
    init() {
        container = NSPersistentContainer(name: .CISStore)
        if let description = container.persistentStoreDescriptions.first {
            description.shouldAddStoreAsynchronously = true
        }
        
        container.loadPersistentStores { [weak self] _, error in
            if let error = error {
                print("Error loading store: \(error.localizedDescription)")
                return
            }
            
            guard let self = self else { return }
            
            self.container.performBackgroundTask { context in
                // Perform Migration
                do {
                    try self.initializeStore(context: context)
                } catch {
                    //TODO: - Better handle the error
                    print("Error: Initialization \(error.localizedDescription)")
                }
                
                DispatchQueue.main.async {
                    self.onStoreLoaded?()
                }
            }
        }
    }
    
    
    /// Retrieves Books from the config.json file
    /// - Returns: An array of StoreBooks
    func retrieveAllBooks() -> [StoreBook] {
        var books: [StoreBook] = []
        
        let fileLoader = FileLoader<[LocalBook]>(fromFile: "config")
        
        fileLoader.load {[weak self] result in
            switch result {
            case let .success(booksFromFile):
                books = booksFromFile.map { $0.toStoreBook(self?.getSelectedBookKey()) }
            default:
                print("We couldn't fetch the books")
            }
        }
        
        return books
    }
    
    private func isStoreValid(context: NSManagedObjectContext) -> Bool {
        let request = NSFetchRequest<Hymn>(entityName: .Hymn)
        request.fetchLimit = 1
        if let res = try? context.fetch(request), let first = res.first {
            // Verify if the content string is structured JSON from v2 instead of raw v1 HTML payload
            if let data = first.content?.data(using: .utf8),
               let _ = try? JSONDecoder().decode([StoreLyric].self, from: data) {
                 return true // Successfully mapped as v2
             } else {
                 return false // Is mapped as old v1 string logic, or corrupted.
             }
        }
        return false // Empty, not valid
    }
    
    
    /// Retrieve Hymns from a book
    /// - Parameter book: key of the book
    /// - Returns: An optional array of hymns
    func retrieveHymns(from book: String) -> [StoreHymn]? {
        var foundHymns: [StoreHymn] = []
        let request = NSFetchRequest<Hymn>(entityName: .Hymn)
        let predicate = NSPredicate(format: "book == %@", book)
        let titleSortDescriptor = NSSortDescriptor(key: .title, ascending: true)
        request.predicate = predicate
        request.sortDescriptors = [titleSortDescriptor]
        
        do {
            let fetchedHymns = try container.viewContext.fetch(request)
            foundHymns = fetchedHymns.map { $0.toStoreHymn() }.sorted(by: {$0.number < $1.number})
        } catch {
            //TODO: - Better handle the error
             print("Error: Fetching hymns failed\(error.localizedDescription)")
        }
        
        return foundHymns
    }
    
    
    /// Sets the selected book
    /// - Parameter bookName: Name of the book
    func setSelectedBook(to bookName: String) {
        defaults.set(bookName, forKey: .selectedBook)
    }
    
    func retrieveSelectedBook() -> String? {
        defaults.string(forKey: .selectedBook)
    }
    
    func retrieveAllCollections() -> [StoreCollection] {
        var collections: [StoreCollection] = []
        
        let request = NSFetchRequest<Collection>(entityName: .Collection)
        let titleSortDescriptor = NSSortDescriptor(key: .title, ascending: true)
        request.sortDescriptors = [titleSortDescriptor]
        
        do  {
            let fetchedCollections = try container.viewContext.fetch(request)
            collections = fetchedCollections.map { $0.toStoreCollection() }
        } catch {
            //TODO: - Better handle the error
            print("Error: Fetching Collections failed\(error.localizedDescription)")
        }
        
        return collections
    }
    
    
    func createCollection(with title: String, and about: String?) {
        let collection = Collection(context: container.viewContext)
        collection.id = UUID()
        collection.title = title
        
        collection.about = about
        collection.created = .now
        
        do {
            try save()
        } catch {
            //TODO: Better handle any save errors
        }
    }
    
    func removeCollection(with id: UUID) {
        if let res = retrieveCollection(with: id) {
            container.viewContext.delete(res)
        }
        
        do {
            try save()
        } catch {
            //TODO: - Better handle the error
            print("Error: Couldn't delete the collection")
        }
    }
    
    func retrieveHymn(with id: UUID) -> Hymn? {
        let req = NSFetchRequest<Hymn>(entityName: .Hymn)
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        req.predicate = predicate
        req.fetchLimit = 1
        
        return try? container.viewContext.fetch(req).first
    }
    
    func retrieveCollection(with id: UUID) -> Collection? {
        let req = NSFetchRequest<Collection>(entityName: .Collection)
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        req.predicate = predicate
        req.fetchLimit = 1
        
        return try? container.viewContext.fetch(req).first
    }
    
    func toggle(hymn: StoreHymn,in collection: StoreCollection) {
        
        let fetchedCollection = retrieveCollection(with: collection.id)
        let fetchedHymn = retrieveHymn(with: hymn.id)
        guard let fetchedHymn ,
                let fetchedCollection  else { return }
        
        if fetchedCollection.allHymns.contains(fetchedHymn) {
            fetchedCollection.removeFromHymns(fetchedHymn)
            fetchedHymn.removeFromCollection(fetchedCollection)
        } else {
            fetchedCollection.addToHymns(fetchedHymn)
            fetchedHymn.addToCollection(fetchedCollection)
        }
        
        do {
            try save()
        } catch {
            // TODO: - Better handle any saving error
            print("Error: Unable to toggle hymn in collection")
        }
        
    }
    
    private func getSelectedBookKey() -> String {
        defaults.string(forKey: .selectedBook) ?? .defaultBook
    }
    
    func removeHymn(with id: UUID, from collectionID: UUID) {
        if let collection = retrieveCollection(with: collectionID) {
            if let hymn = retrieveHymn(with: id) {
                collection.removeFromHymns(hymn)
                do  {
                    try save()
                } catch {}
            }
        }
    }
    
    
}

extension CISCoreDataStore {
    // MARK: - Private
    
    
    // MARK: - Private methods
    private func initializeStore(context: NSManagedObjectContext) throws {
        // Evaluate config extraction.
        try loadInitialContent(context: context)
    }
    
    private func loadInitialContent(context: NSManagedObjectContext) throws {
        let booksLoader = FileLoader<[LocalBook]>(fromFile: "config")
        var allBooksFromFile: [LocalBook] = []
        
        booksLoader.load { result in
            switch result {
            case let .success(books):
                allBooksFromFile = books
            case let .failure(error):
                //TODO: - Better handle the error
                print("Error \(error.localizedDescription)")
                return
            }
        }
        
        guard !allBooksFromFile.isEmpty else {
            //TODO: - Better handle the error
            print("Error: Migration failed")
            return
        }
        
        for bookFromFile in allBooksFromFile {
            let request = NSFetchRequest<Hymn>(entityName: .Hymn)
            request.predicate = NSPredicate(format: "book == %@", bookFromFile.key)
            request.fetchLimit = 1
            
            if let first = try? context.fetch(request).first {
                // Book exists. Validate if it's already using the V2 stringified JSON format
                if let data = first.content?.data(using: .utf8),
                   let _ = try? JSONDecoder().decode([StoreLyric].self, from: data) {
                    continue // Successfully mapped V2, skip loading this book
                }
            }
            
            // If we reach here, the book is either completely missing, or runs legacy V1 HTML structures. Upsert it safely.
            do {
                try upsertBook(with: bookFromFile.key, context: context)
            } catch {
                print("Failed to upsert book \(bookFromFile.key): \(error)")
            }
        }
    }
    
    private func upsertBook(with key: String, context: NSManagedObjectContext) throws {
        let fileLoader = FileLoader<[LocalHymn]>(fromFile: key)
        var hymnsFromfile: [LocalHymn] = []
        
        fileLoader.load { result in
            switch result {
            case let .success(hymns):
                hymnsFromfile = hymns
            case .failure:
                break
            }
        }
        
        guard !hymnsFromfile.isEmpty else {
            throw "No hymns found during migration"
        }
        
        // Grab pre-existing hymns to update without discarding their unique IDs and breaking user collections
        let request = NSFetchRequest<Hymn>(entityName: .Hymn)
        request.predicate = NSPredicate(format: "book == %@", key)
        let existingHymns = (try? context.fetch(request)) ?? []
        let existingHymnsDict = Dictionary(grouping: existingHymns, by: { $0.number })
        
        // Upsert
        for hymnFromFile in hymnsFromfile {
            let number = Int16(hymnFromFile.number)
            let hymn: Hymn
            
            // Re-use an existing matching number to preserve bindings, or create brand new one if appending/missing.
            if let existingList = existingHymnsDict[number], let existing = existingList.first {
                hymn = existing
            } else {
                hymn = Hymn(context: context)
                hymn.id = UUID()
                hymn.book = key
                hymn.number = number
            }
            
            hymn.title = hymnFromFile.title
            hymn.titleStr = hymnFromFile.title.titleStr
        
            if let lyricsData = try? JSONEncoder().encode(hymnFromFile.lyrics),
               let lyricsString = String(data: lyricsData, encoding: .utf8) {
                hymn.content = lyricsString
            }
        }
        
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("Failure saving background context for upsert: \(error)")
        }
    }
    
    private func save() throws {
        do {
            try container.viewContext.save()
        } catch {
            print("Failure saving context: \(error)")
        }
    }
    
    // MARK: - Private properties
    private struct LocalBook: Decodable {
        let key: String
        let title: String
        let language: String
        let refrain_label: String?
        
        func toStoreBook(_ selectedBook: String?) -> StoreBook {
            if selectedBook != nil {
                return StoreBook(key: key, language: language, title: title, isSelected: key == selectedBook, refrainLabel: refrain_label)
            } else {
                return StoreBook(key: key, language: language, title: title, refrainLabel: refrain_label)
            }
        }
    }
    
    private struct LocalHymn: Decodable {
        let title: String
        let number: Int
        let lyrics: [StoreLyric]
    }
}


extension String {
    /// Store Name: CISStore
    static let CISStore = "Main"
    /// Key name: title
    static let title = "title"
    /// Key name: english
    static let english = "english"
    /// UserDefaults Key for selected Hymn Book
    static let selectedBook = "selectedBook"
    /// Default Selected Book
    static let defaultBook = "english"
}

extension String: @retroactive Error {}
extension String: @retroactive LocalizedError {}
