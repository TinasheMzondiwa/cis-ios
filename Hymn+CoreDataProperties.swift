//
//  Hymn+CoreDataProperties.swift
//  iOS
//
//  Created by Tinashe  on 2021/03/07.
//
//

import Foundation
import CoreData


extension Hymn {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hymn> {
        return NSFetchRequest<Hymn>(entityName: "Hymn")
    }

    @NSManaged public var book: String?
    @NSManaged public var content: String?
    @NSManaged public var edited_content: String?
    @NSManaged public var id: UUID?
    @NSManaged public var number: Int16
    @NSManaged public var title: String?
    @NSManaged public var titleStr: String?
    @NSManaged public var collection: NSSet?

}

// MARK: Generated accessors for collection
extension Hymn {

    @objc(addCollectionObject:)
    @NSManaged public func addToCollection(_ value: Collection)

    @objc(removeCollectionObject:)
    @NSManaged public func removeFromCollection(_ value: Collection)

    @objc(addCollection:)
    @NSManaged public func addToCollection(_ values: NSSet)

    @objc(removeCollection:)
    @NSManaged public func removeFromCollection(_ values: NSSet)

}

extension Hymn : Identifiable {
    var wrappedTitle: String {
        title ?? ""
    }
    var wrappedTitleStr: String {
        titleStr ?? wrappedTitle.titleStr
    }
    var wrappedContent: String {
        content ?? ""
    }
    var collections: [Collection] {
        let set = collection as? Set<Collection> ?? []
        return set.sorted {
            $0.wrappedTitle < $1.wrappedTitle
        }
    }
}
