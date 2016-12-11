//
//  ProductCategory.swift
//  ClothesStore
//
//  Created by Alexandre Malkov on 10/12/2016.
//  Copyright © 2016 Alexandre Malkov. All rights reserved.
//

import Foundation
import CoreData

extension ProductCategory {
    
    static func getItemOrCreate(forName name: String) -> ProductCategory {
        return getItem(forName: name, addItemIfNeeded: true)!
    }
    
    static func getItem(forName name: String, addItemIfNeeded: Bool = false) -> ProductCategory? {
        let predicate = NSPredicate(format: "name = %@", name)
        let item: ProductCategory? = DataController.getItem(forPredicate: predicate, addItemIfNeeded: addItemIfNeeded)
        item?.name = name
        return item
    }
    
    static func getAllItems() -> [ProductCategory] {
        return DataController.getAllItems()
    }
    
    static func deleteAll() {
        let _: ProductCategory? = DataController.deleteAll()
    }
}
