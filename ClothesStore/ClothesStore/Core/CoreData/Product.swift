//
//  Product.swift
//  ClothesStore
//
//  Created by Alexandre Malkov on 10/12/2016.
//  Copyright © 2016 Alexandre Malkov. All rights reserved.
//

import Foundation
import CoreData

extension Product {
    
    static func getItemOrCreate(forId id: Int) -> Product {
        return getItem(forId: id, addItemIfNeeded: true)!
    }
    
    static func getItem(forId id: Int, addItemIfNeeded: Bool = false) -> Product? {
        let predicate = NSPredicate(format: "id == \(id)")
        let item: Product? = DataController.getItem(forPredicate: predicate, addItemIfNeeded: addItemIfNeeded)
        item?.id = Int64(id)
        return item
    }
    
    static func getAllItems() -> [Product] {
        let sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        return DataController.getAllItems(sortDescriptors: sortDescriptors)
    }
    
    static func deleteAll() {
        let _: Product? = DataController.deleteAll()
    }
}
