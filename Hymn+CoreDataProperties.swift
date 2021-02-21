//
//  Hymn+CoreDataProperties.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/21.
//
//

import Foundation
import CoreData


extension Hymn {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hymn> {
        return NSFetchRequest<Hymn>(entityName: "Hymn")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var book: String?
    @NSManaged public var number: Int16
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var edited_content: String?
    
    var wrappedTitle: String {
        title ?? ""
    }
    var wrappedContent: String {
        content ?? ""
    }

}

extension Hymn : Identifiable {

}
