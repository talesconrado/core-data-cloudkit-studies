//
//  CoreDataManager.swift
//  ShoppingList
//
//  Created by Tales Conrado on 14/10/20.
//
import UIKit
import CoreData

class CoreDataManager {
    var managedContext: NSManagedObjectContext?
    
    var persistentContainer: NSPersistentContainer?
    
    init() {
        //loadContainer(completion: nil)
    }
    
    func createData(named: String) {
        guard let managedContext = self.managedContext else { return }
        let item = Item(context: managedContext)
        item.setValue(named, forKey: "name")
        item.setValue(Date(), forKey: "createdAt")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error saving item. \(error)")
        }
    }
    
    func loadContainer(completion: (() -> Void)?) {
        let container = NSPersistentContainer(name: "ShoppingList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            self.persistentContainer = container
            self.managedContext = container.viewContext

            if let completion = completion {
                completion()
            }
        })
    }
    
    func deleteItem(object: NSManagedObject) {
        guard let managedContext = self.managedContext else { return }
        managedContext.delete(object)
        do {
            try managedContext.save()
        } catch {
            print("ERROR: Couldn't save after deletion!")
        }
    }
    
    func saveContext () {
        let context = persistentContainer!.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

