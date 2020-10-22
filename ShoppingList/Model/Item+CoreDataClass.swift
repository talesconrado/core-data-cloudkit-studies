//
//  Item+CoreDataClass.swift
//  ShoppingList
//
//  Created by Tales Conrado on 22/10/20.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(Date(), forKey: #keyPath(Item.createdAt))
    }
    
    func update(named: String, category: String) {
        self.name = named
        self.category = category
    }

    func delete() {
        managedObjectContext?.delete(self)
        save()
    }
    
    func save() {
        guard let context = managedObjectContext else { return }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("ERROR: Couldn't save after deletion!")
            }
        }
    }
}
