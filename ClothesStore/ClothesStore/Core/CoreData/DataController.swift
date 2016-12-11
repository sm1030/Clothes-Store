//
//  DataManager.swift
//  ClothesStore
//
//  Created by Alexandre Malkov on 10/12/2016.
//  Copyright © 2016 Alexandre Malkov. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    class func getContext() -> NSManagedObjectContext {
        return DataController.persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ClothesStore")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Custom methods
    
    static func getItem<T : NSManagedObject>(forPredicate predicate: NSPredicate, addItemIfNeeded: Bool = false) -> T? {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
            fetchRequest.predicate = predicate
            if let fetchResults = try DataController.getContext().fetch(fetchRequest) as? [T] {
                if fetchResults.count > 0 {
                    return fetchResults[0]
                }
            }
        } catch let error {
            print("ERROR: \(error)")
        }
        
        if addItemIfNeeded {
            let item = NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self), into: DataController.getContext()) as? T
            return item
        } else {
            return nil
        }
    }
    
    static func getAllItems<T : NSManagedObject>() -> [T] {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
            return try DataController.getContext().fetch(fetchRequest) as! [T]
        } catch let error {
            print("ERROR: \(error)")
        }
        return [T]()
    }
    
    static func deleteAll<T : NSManagedObject>() -> T? {
        for dataItem in DataController.getAllItems() as [T] {
            DataController.getContext().delete(dataItem)
        }
        
        return nil
    }
    
}

