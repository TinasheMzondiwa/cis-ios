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

    @NSManaged public var about: String?
    @NSManaged public var created: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var hymns: NSSet?

}

// MARK: Generated accessors for hymns
extension Collection {

    @objc(addHymnsObject:)
    @NSManaged public func addToHymns(_ value: Hymn)

    @objc(removeHymnsObject:)
    @NSManaged public func removeFromHymns(_ value: Hymn)

    @objc(addHymns:)
    @NSManaged public func addToHymns(_ values: NSSet)

    @objc(removeHymns:)
    @NSManaged public func removeFromHymns(_ values: NSSet)

}

extension Collection : Identifiable {
    var wrappedTitle: String {
        title ?? ""
    }
    var wrappedDescription: String {
        about ?? ""
    }
    var allHymns: [Hymn] {
        let set = hymns as? Set<Hymn> ?? []
        return set.sorted {
            $0.wrappedTitle < $1.wrappedTitle
        }
    }
    func containsHymn(id: UUID) -> Bool {
        for item in allHymns {
            if item.id == id {
                return true
            }
        }
        return false
    }
}
