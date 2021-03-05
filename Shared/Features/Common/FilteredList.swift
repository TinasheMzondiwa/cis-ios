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
    
    private let onDelete: (() -> Void)?
    
    init(sortKey: String,
         filterKey: String? = nil, filterValue: String? = nil,
         queryKey: String? = nil, query: String? = nil, onDelete: (() -> Void)? = nil,
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
        self.onDelete = onDelete
        self.content = content
    }
    
    var body: some View {
        if onDelete != nil {
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
        
        onDelete?()
    }
}
