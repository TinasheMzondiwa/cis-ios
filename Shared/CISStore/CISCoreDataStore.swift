//
//  CISCoreDataStore.swift
//  iOS
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation
import CoreData
import OSLog

final class CISCoreDataStore: Store {
   
    private let container: NSPersistentContainer
    private let defaults = UserDefaults.standard
    private let logger = Logger(subsystem: .subsystem, category: .categoryCoreDatastore)
    
    
    init() {
        container = NSPersistentContainer(name: .CISStore)
        container.loadPersistentStores { _, _ in }
        
        // Perform Migration
        do {
            try initializeStore()
        } catch {
            logger.error("store initialization failed: \(error.localizedDescription)")
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
                self?.logger.error("failed to retrieveAllBooks")
            }
        }
        
        return books
    }
    
    private func isStoreEmpty() -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: .Hymn)
        if let res = try? container.viewContext.fetch(request) {
            return res.isEmpty
        } else {
            return false
        }
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
            var fetchedHymns = try container.viewContext.fetch(request)
            // TODO: only use this after testing existing store
            if fetchedHymns.isEmpty {
                // migrate the book
                try migrateBook(with: book)
                // perform a fresh fetch
                fetchedHymns = try container.viewContext.fetch(request)
            }
            foundHymns = fetchedHymns.map { $0.toStoreHymn() }.sorted(by: {$0.number < $1.number})
        } catch {
            logger.error("failed to retrieveHymns from \(book): \(error.localizedDescription)")
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
            logger.error("failed to retrieveAllCollections : \(error.localizedDescription)")
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
            logger.error("failed to createCollection with: \(title) : \(error.localizedDescription)")
        }
    }
    
    func removeCollection(with id: UUID) {
        if let res = retrieveCollection(with: id) {
            container.viewContext.delete(res)
        }
        
        do {
            try save()
        } catch {
            logger.error("failed to removeCollection: \(error.localizedDescription)")
        }
    }
    
    func retrieveHymn(with id: UUID) -> Hymn? {
        let req = NSFetchRequest<Hymn>(entityName: .Hymn)
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        req.predicate = predicate
        req.fetchLimit = 1
        
        do {
            return try container.viewContext.fetch(req).first
        } catch {
            logger.error("failed to retrieveHymn: \(error.localizedDescription)")
        }
        return nil
    }
    
    func retrieveCollection(with id: UUID) -> Collection? {
        let req = NSFetchRequest<Collection>(entityName: .Collection)
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        req.predicate = predicate
        req.fetchLimit = 1
        
        do {
            return try container.viewContext.fetch(req).first
        } catch {
            logger.error("failed to retrieveCollection: \(error.localizedDescription)")
        }
        return nil
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
            logger.error("failed to retrieveCollection: \(error.localizedDescription)")
        }
    }
    
    private func getSelectedBookKey() -> String {
        defaults.string(forKey: .selectedBook) ?? .defaultBook
    }
    
    func removeHymn(with id: UUID, from collectionID: UUID) {
        if let collection = retrieveCollection(with: collectionID),
           let hymn = retrieveHymn(with: id) {
                collection.removeFromHymns(hymn)
                do  {
                    try save()
                } catch {
                    logger.error("failed to removeHymn: \(error.localizedDescription)")
                }
            }
    }
}

extension CISCoreDataStore {
    // MARK: - Private
    
    
    // MARK: - Private methods
    private func initializeStore() throws {
        // Perform only if the store is empty
        if isStoreEmpty() {
            if !defaults.bool(forKey: .migrationKey) {
                try performFirstTimeMigration()
                defaults.set("true", forKey: .migrationKey)
            }
        }
    }
    
    private func performFirstTimeMigration() throws {
        let booksLoader = FileLoader<[LocalBook]>(fromFile: "config")
        var allBooksFromFile: [LocalBook] = []
        
        booksLoader.load { [weak self] result in
            switch result {
            case let .success(books):
                allBooksFromFile = books
            case let .failure(error):
                self?.logger.error("firstTimeMigration failed with: \(error.localizedDescription)")
                return
            }
        }
        
        guard !allBooksFromFile.isEmpty else {
            throw "firstTimeMigration failed: No books found in file"
        }
        
        for bookFromFile in allBooksFromFile {
            try migrateBook(with: bookFromFile.key)
        }
    }
    
    private func migrateBook(with key: String) throws {
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
        
        // Migrate
        for hymnFromFile in hymnsFromfile {
            let hymn = Hymn(context: container.viewContext)
            hymn.id = UUID()
            hymn.book = key
            hymn.title = hymnFromFile.title
            hymn.titleStr = hymnFromFile.title.titleStr
            hymn.number = Int16(hymnFromFile.number)
        
            if let html = hymnFromFile.content {
                if html.contains(hymnFromFile.title) {
                    hymn.content = html
                } else {
                    hymn.content = "<h3>\(hymnFromFile.title)</h3>\(html)"
                }
            }
            hymn.markdown = hymnFromFile.markdown
            
            hymn.edited_content = hymn.content
            
            try save()
        }

        
    }
    
    private func save() throws {
        try container.viewContext.save()
    }
    
    // MARK: - Private properties
    private struct LocalBook: Decodable {
        let key: String
        let title: String
        let language: String
        
        func toStoreBook(_ selectedBook: String?) -> StoreBook {
            if selectedBook != nil {
                return StoreBook(key: key, language: language, title: title, isSelected: key == selectedBook)
            } else {
                return StoreBook(key: key, language: language, title: title)
            }
        }
    }
    
    private struct LocalHymn: Decodable {
        let title: String
        let number: Int
        let content: String?
        let markdown: String?
    }
}


extension String {
    /// Store Name: CISStore
    static let CISStore = "Main"
    /// First time migration UserDefaults Key
    static let migrationKey = "firstTimeMigration"
    /// Key name: title
    static let title = "title"
    /// Key name: english
    static let english = "english"
    /// UserDefaults Key for selected Hymn Book
    static let selectedBook = "selectedBook"
    /// Default Selected Book
    static let defaultBook = "english"
}

extension String: LocalizedError {}
