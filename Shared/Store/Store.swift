//
//  Store.swift
//  iOS
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation
import CoreData

public protocol Store {
    /// Retrieve all books from the store
    /// - Returns: an array of ``StoreBook``
    func retrieveAllBooks() -> [StoreBook]
//    func retrieveAllCollections() -> [StoreCollection]
    func retrieveHymns(from book: String) -> [StoreHymn]?
    func setSelectedBook(to bookName: String)
    func retrieveSelectedBook() -> String?
//    func retrieveHymns(from collection: StoreCollection) -> [StoreHymn]
//    func updateSelectedBook(from book: StoreBook, to newBook: StoreBook) -> Error?
//    func createCollection(with title: String, and about: String?) -> Error?
//    func add(hymn: StoreHymn, to collection: StoreCollection) -> Error?
//    func saveCollection()
}


final class CISPersistence {
    let container: NSPersistentContainer
    
    @Published var appError: Error? = nil
    @Published var allBooks: [StoreBook] = []
    
    init() {
        container = NSPersistentContainer(name: .StoreName)
        container.loadPersistentStores {[weak self] _, error in
            if let error {
                self?.appError = error
            }
        }
        
        initializeData()
    }
    
    func fetchHymnsFrom(book: String) -> [StoreHymn]? {
        var foundHymns: [StoreHymn] = []
        
        let context = container.viewContext
        let request = NSFetchRequest<Hymn>(entityName: .Hymn)
        let predicate = NSPredicate(format: "book == %@", book)
        request.predicate = predicate
        
        do {
            let results = try context.fetch(request)
            foundHymns = results.map { $0.toStoreHymn() }
        } catch {
            self.appError = error
        }
        
        return foundHymns
    }
    
    private func initializeData() {
        let fileLoader = FileLoader<[LocalBook]>(fromFile: "config")
        
        fileLoader.load {[weak self] result in
            switch result {
            case let .success(books):
                // For all the books, check if they already exists otherwise migrate them.
                for book in books {
                    let hymnsFromBook = self?.fetchHymnsFrom(book: book.key)
                    if hymnsFromBook?.count == 0 {
                        // Migrate the book
                        self?.migrateHymnsFor(bookName: book.key)
                    }
                }
            case let .failure(error):
                self?.appError = error
            }
        }
    }
    
    private func migrateHymnsFor(bookName: String) {
        let fileLoader = FileLoader<[LocalHymn]>(fromFile: bookName)
        var foundHymns : [LocalHymn] = []
        
        fileLoader.load {[weak self] result in
            switch result {
            case let .success(hymns):
                foundHymns = hymns
            case let .failure(error):
                self?.appError = error
            }
        }
        
        for foundHymn in foundHymns {
            let hymn = Hymn(context: container.viewContext)
            hymn.id = UUID()
            hymn.book = bookName
            hymn.title = foundHymn.title
            hymn.titleStr = foundHymn.title.titleStr
            hymn.number = Int16(foundHymn.number)
            
            if foundHymn.content.contains(foundHymn.title) {
                hymn.content = foundHymn.content
            } else {
                hymn.content = "<h3>\(foundHymn.title)</h3>\(foundHymn.content)"
            }
            
            save()
        }
    }
    
    private func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                self.appError = error
            }
        }
    }
    
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


extension Hymn {
    func toStoreHymn() -> StoreHymn {
        StoreHymn(id: self.id!, title: self.title!, titleStr: self.titleStr!, content: self.content!, number: Int(self.number))
    }
}

extension Collection {
    func toStoreCollection() -> StoreCollection {
        StoreCollection(id: self.id!, title: self.title!, dateCreated: self.created!, about: self.about, hymns: (self.hymns?.allObjects as? [Hymn]).map{ $0.map { $0.toStoreHymn()}})
    }
}

extension String {
    static var StoreName = "Main"
    static var Hymn = "Hymn"
    static var Collection = "Collection"
}
