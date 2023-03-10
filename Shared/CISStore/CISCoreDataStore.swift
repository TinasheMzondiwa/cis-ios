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
        let books: [StoreBook] = []
        return books
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
}
