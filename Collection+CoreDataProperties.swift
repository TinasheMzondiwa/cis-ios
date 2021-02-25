//
//  Collection+CoreDataProperties.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/25.
//
//

import Foundation
import CoreData


extension Collection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Collection> {
        return NSFetchRequest<Collection>(entityName: "Collection")
    }

    @NSManaged public var created: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var about: String?
    
    var wrappedTitle: String {
        title ?? ""
    }
    var wrappedDescription: String {
        about ?? ""
    }

}

extension Collection : Identifiable {

}
