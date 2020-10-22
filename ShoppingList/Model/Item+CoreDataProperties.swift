//
//  Item+CoreDataProperties.swift
//  ShoppingList
//
//  Created by Tales Conrado on 22/10/20.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var category: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var name: String?
    @NSManaged public var belongsTo: List?

}

extension Item : Identifiable {

}
