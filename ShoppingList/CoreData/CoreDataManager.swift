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
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func createData(named: String) {
        guard let managedContext = self.managedContext else { return }
        let itemEntity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)!
        let item = NSManagedObject(entity: itemEntity, insertInto: managedContext)
        item.setValue(named, forKey: "name")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error saving item. \(error)")
        }
    }
    
    func fetchData() -> [NSManagedObject] {
        var array: [NSManagedObject] = []
        guard let managedContext = self.managedContext else {
            print("Error fetching itens.")
            return array }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result {
                array.append(data as! NSManagedObject)
            }
        } catch let err as NSError {
            print("Error fetching itens. \(err)")
        }
        
        return array
    }
    
    func deleteItem(named: String) {
        guard let managedContext = self.managedContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        fetchRequest.predicate = NSPredicate(format: "name = %@", named)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            let objectToDelete = result[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            do {
                try managedContext.save()
            } catch {
                print("ERROR: Couldn't save after deletion!")
            }
        }
    }
}

