//
//  FilteredList.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/21.
//

import Foundation
import CoreData
import SwiftUI

struct FilteredList<T: NSManagedObject, Content: View>: View {
    private var fetchRequest: FetchRequest<T>
    private var results: FetchedResults<T> { fetchRequest.wrappedValue }
    
    private let content: (T) -> Content
    
    private let canDelete: Bool
    
    init(sortKey: String,
         filterKey: String? = nil, filterValue: String? = nil,
         queryKey: String? = nil, query: String? = nil, canDelete: Bool = false,
         @ViewBuilder content: @escaping (T) -> Content) {
        
        var predicateArr: [NSPredicate] = []
        if let key = filterKey, let value = filterValue {
            predicateArr.append(NSPredicate(format: "\(key) == %@", value))
        }
        if let query = query, !query.isEmpty, let key = queryKey {
            predicateArr.append( NSPredicate(format: "\(key) contains[c] %@", query))
        }
        fetchRequest = FetchRequest<T>(entity: T.entity(),
                                       sortDescriptors: [NSSortDescriptor(key: sortKey, ascending: true)],
                                       predicate: NSCompoundPredicate(andPredicateWithSubpredicates: predicateArr))
        self.canDelete = canDelete
        self.content = content
    }
    
    var body: some View {
        if canDelete {
            List {
                ForEach(results, id: \.self) { item in
                    self.content(item)
                }
                .onDelete(perform: removeContent)
            }
        } else {
            List(results, id: \.self) { item in
                self.content(item)
            }
        }
    }
    
    private func removeContent(at offsets: IndexSet) {
        for index in offsets {
            let result = results[index]
            PersistenceController.shared.delete(item: result)
        }
    }
}


class FilterVideModel<T: NSManagedObject>: ObservableObject {
    
    var fetchRequest: FetchRequest<T>
    
    private let sortKey: String
    private var filterKey: String?
    private var filterValue: String?
    private var queryKey: String?
    let canDelete: Bool
    
    init(sortKey: String,
         filterKey: String?, filterValue: String?,
         queryKey: String?, canDelete: Bool) {
        
        self.queryKey = queryKey
        self.sortKey = sortKey
        self.filterKey = filterKey
        self.filterValue = filterValue
        self.canDelete = canDelete
        
        var predicateArr: [NSPredicate] = []
        if let key = filterKey, let value = filterValue {
            predicateArr.append(NSPredicate(format: "\(key) == %@", value))
        }
    
        fetchRequest = FetchRequest<T>(entity: T.entity(),
                                       sortDescriptors: [NSSortDescriptor(key: sortKey, ascending: true)],
                                       predicate: NSCompoundPredicate(andPredicateWithSubpredicates: predicateArr))
    }
    
    func performSearch(query: String?) {
        var predicateArr: [NSPredicate] = []
        if let key = filterKey, let value = filterValue {
            predicateArr.append(NSPredicate(format: "\(key) == %@", value))
        }
        if let query = query, !query.isEmpty, let key = queryKey {
            predicateArr.append( NSPredicate(format: "\(key) contains[c] %@", query))
        }
        fetchRequest = FetchRequest<T>(entity: T.entity(),
                                       sortDescriptors: [NSSortDescriptor(key: sortKey, ascending: true)],
                                       predicate: NSCompoundPredicate(andPredicateWithSubpredicates: predicateArr))
    }
}
