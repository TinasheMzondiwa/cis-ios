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
    
    init() throws {
        container = NSPersistentContainer(name: .CISStore)
        container.loadPersistentStores { _, _ in }
        try initializeStore()
    }
    
    func retrieveAllBooks() -> [StoreBook] {
        var books: [StoreBook] = []
        
        let request = NSFetchRequest<BookEntity>(entityName: .BookEntity)
        let titleSortDescriptor = NSSortDescriptor(key: .title, ascending: true)
        request.sortDescriptors = [titleSortDescriptor]
        
        do {
            let fetchBooks = try container.viewContext.fetch(request)
            books = fetchBooks.map { $0.toStoreBook() }
        } catch {
            print("Fetching Books failed")
        }
        
        return books
    }
    
    func retreiveAllCollections() -> [StoreCollection] {
        var collections: [StoreCollection] = []
        
        let request = NSFetchRequest<CollectionEntity>(entityName: .CollectionEntity)
        let titleSortDescriptor = NSSortDescriptor(key: .title, ascending: true)
        request.sortDescriptors = [titleSortDescriptor]
        
        do  {
            let fetchedCollections = try container.viewContext.fetch(request)
            collections = fetchedCollections.map { $0.toStoreCollection()
            }
        } catch {
            print("Fetching Collections failed")
        }
        
        return collections
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
                print("Error \(error.localizedDescription)")
            }
        }
        
        guard !allBooksFromFile.isEmpty else {
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
                    print("Error: Migration failed \(error.localizedDescription)")
                    return
                }
            }
            
            guard !hymnsFromFile.isEmpty else {
                print("Error: Migration failed no songs found")
                return
            }
            
            let book = BookEntity(context: container.viewContext)
            book.id = UUID()
            book.title = bookFromFile.title
            book.key = bookFromFile.key
            book.language = bookFromFile.language
            book.isSelected = (bookFromFile.key == .english) ? true : false
            book.hymns = NSOrderedSet(array: hymnsFromFile.map { fileHymn in
                let hymn = HymnEntity(context: container.viewContext)
                hymn.id = UUID()
                hymn.title = fileHymn.title
                hymn.titleStr = fileHymn.title
                hymn.number = Int16(fileHymn.number)
                hymn.content = fileHymn.content
                hymn.editedContent = fileHymn.content
                hymn.isFavorite = false
                return hymn
                }
            )
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
    static let CISStore = "CISStore"
    /// First time migration UserDefaults Key
    static let migrationKey = "firstTimeMigration"
    /// Key name: title
    static let title = "title"
    /// Key name: english
    static let english = "english"
}


extension CollectionEntity {
    func toStoreCollection() -> StoreCollection {
        StoreCollection(id: self.id!, title: self.title!, dateCreated: self.dateCreated!, about: self.about, hymns: (self.hymns?.allObjects as? [HymnEntity]).map({ $0.map { $0.toStoreHymn()}
        }) ?? [])
    }
}

extension BookEntity {
    func toStoreBook() -> StoreBook {
        StoreBook(id: self.id!, isSelected: self.isSelected, key: self.key!, language: self.language!, title: self.title!, titleStr: self.titleStr!, hymns: (self.hymns!.array as? [HymnEntity]).map( { entity in
            entity.map { $0.toStoreHymn()}})!
        )
    }
}

extension HymnEntity {
    func toStoreHymn() -> StoreHymn {
        StoreHymn(id: self.id!, title: self.title!, content: self.content!, number: Int(self.number))
    }
}
