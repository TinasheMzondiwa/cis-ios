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
    var fetchRequest: FetchRequest<T>
    var results: FetchedResults<T> { fetchRequest.wrappedValue }
    
    let content: (T) -> Content
    
    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { item in
            self.content(item)
        }
    }
    
    init(sortKey: String,
         filterKey: String? = nil, filterValue: String? = nil,
         queryKey: String? = nil, query: String? = nil,
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
        self.content = content
    }
}
