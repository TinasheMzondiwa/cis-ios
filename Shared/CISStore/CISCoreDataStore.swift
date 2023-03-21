//
//  CISCoreDataStore.swift
//  iOS
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation
import CoreData

final class CISCoreDataStore: Store {
    
    private let container: NSPersistentContainer
    private let defaults = UserDefaults.standard
    
    
    init() {
        container = NSPersistentContainer(name: .CISStore)
        container.loadPersistentStores { _, _ in }
        
        // Perform Migration
//        do {
//            try initializeStore()
//        } catch {
//            //TODO: - Better handle the error
//            print("Error: Initialization \(error.localizedDescription)")
//        }
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
            // TODO: only use this after testing existing store
            if fetchedHymns.isEmpty {
                // migrate the book
//                try migrateBook(with: book)
                // perform a fresh fetch
//                fetchedHymns = try container.viewContext.fetch(request)
            }
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
    func retrieveHymns(from collection: StoreCollection) -> [StoreHymn] {
        let request = NSFetchRequest<CollectionEntity>(entityName: .CollectionEntity)
        let predicate = NSPredicate(format: "id == %@", collection.id as CVarArg)
        
        request.predicate = predicate
        request.fetchLimit = 1
        var foundHymns: [StoreHymn] = []
//        do {
//            let fetchedCollection = try container.viewContext.fetch(request)
//            _ = (fetchedCollection.first?.hymns?.allObjects as? [HymnEntity]).map({ hymnEntities in
//                for hymn in hymnEntities {
//                    foundHymns.append(hymn.toStoreHymn())
//                }
//            })
//        } catch {
//            //TODO: - Better handle the error
//            print("Error: Fetching Collections failed\(error.localizedDescription)")
//        }
        
        return foundHymns
    }
    
    
    private func retrieveBook(with id: UUID) -> BookEntity? {
        let request = NSFetchRequest<BookEntity>(entityName: .BookEntity)
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let fetchedBook = try container.viewContext.fetch(request)
            return fetchedBook.first(where: { $0.id == id })
        } catch {
            //TODO: - Better handle the error
            print("Error: Fetching Collections failed\(error.localizedDescription)")
            return nil
        }
    }
    
    
    
//    func updateSelectedBook(from book: StoreBook, to newBook: StoreBook) -> Error? {
//        let previousSelectedBookEntity = retrieveBook(with: book.id)
//        let newlySelectedBookEntity = retrieveBook(with: newBook.id)
//
//        if let previousSelectedBookEntity, let newlySelectedBookEntity {
//            previousSelectedBookEntity.isSelected = false
//            newlySelectedBookEntity.isSelected = true
//
//            do {
//                try save()
//            } catch {
//                print("Error: Fetching Collections failed\(error.localizedDescription)")
//            }
//
//            return nil
//        } else {
//            return "Unable to Switch books"
//        }
//    }
    
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
    
    func add(hymn: StoreHymn, to collection: StoreCollection) -> Error? {
        // Check if Collection already contains the hymn
        // If yes, then remove it
        // Otherwise, add hymn t the collection
        
        return nil
    }
    
    private func getSelectedBookKey() -> String {
        defaults.string(forKey: .selectedBook) ?? .defaultBook
    }
    
}

extension CISCoreDataStore {
    // MARK: - Private
    
    
    // MARK: - Private methods
    private func initializeStore() throws {
        if !defaults.bool(forKey: .migrationKey) {
            try performFirstTimeMigration()
            defaults.set("true", forKey: .migrationKey)
        }
    }
    
    private func performFirstTimeMigration() throws {
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
            let hymnsLoader = FileLoader<[LocalHymn]>(fromFile: bookFromFile.key)
            var hymnsFromFile: [LocalHymn] = []
            hymnsLoader.load { result in
                switch result {
                case let .success(hymns):
                    hymnsFromFile = hymns
                case let .failure(error):
                    //TODO: - Better handle the error
                    print("Error: Migration failed \(error.localizedDescription)")
                    return
                }
            }
            
            guard !hymnsFromFile.isEmpty else {
                //TODO: - Better handle the error
                print("Error: Migration failed no songs found")
                return
            }
            for hymnFromFile in hymnsFromFile {
                let hymn = Hymn(context: container.viewContext)
                hymn.id = UUID()
                hymn.book = bookFromFile.key
                hymn.title = hymnFromFile.title
                hymn.titleStr = hymnFromFile.title.titleStr
                hymn.number = Int16(hymnFromFile.number)
                if hymnFromFile.content.contains(hymnFromFile.title) {
                    hymn.content = hymnFromFile.content
                } else {
                    hymn.content = "<h3>\(hymnFromFile.title)</h3>\(hymnFromFile.content)"
                }
                
                hymn.edited_content = hymn.content
                
            }

            try save()
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
        
        // Migrate
        for hymnFromFile in hymnsFromfile {
            let hymn = Hymn(context: container.viewContext)
            hymn.id = UUID()
            hymn.book = key
            hymn.title = hymnFromFile.title
            hymn.titleStr = hymnFromFile.title.titleStr
            hymn.number = Int16(hymnFromFile.number)
            if hymnFromFile.content.contains(hymnFromFile.title) {
                hymn.content = hymnFromFile.content
            } else {
                hymn.content = "<h3>\(hymnFromFile.title)</h3>\(hymnFromFile.content)"
            }
            
            hymn.edited_content = hymn.content
            
        }

        try save()
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
        let content: String
    }
}


extension String {
    /// Entity: Collection
    static let CollectionEntity = "CollectionEntity"
    /// Entity: Hymn
    static let HymnEntity = "HymnEntity"
    /// Entity: Book
    static let BookEntity = "BookEntity"
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


extension CollectionEntity {
//    func toStoreCollection() -> StoreCollection {
//        StoreCollection(id: self.id!, title: self.title!, dateCreated: self.dateCreated!, about: self.about, hymns: (self.hymns?.allObjects as? [HymnEntity]).map({ $0.map { $0.toStoreHymn()}
//        }) ?? [])
//    }
}

extension BookEntity {
//    func toStoreBook() -> StoreBook {
//        StoreBook(id: self.id!, isSelected: self.isSelected, key: self.key!, language: self.language!, title: self.title!, hymns: (self.hymns!.array as? [HymnEntity]).map( { entity in
//            entity.map { $0.toStoreHymn()}})!
//        )
//    }
}

extension HymnEntity {
//    func toStoreHymn() -> StoreHymn {
//        StoreHymn(id: self.id!, title: self.title!, titleStr: self.titleStr!, content: self.content!, number: Int(self.number))
//    }
}

extension String: LocalizedError {}
