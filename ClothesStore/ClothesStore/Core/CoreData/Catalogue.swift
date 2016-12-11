//
//  Catalogue.swift
//  ClothesStore
//
//  Created by Alexandre Malkov on 11/12/2016.
//  Copyright © 2016 Alexandre Malkov. All rights reserved.
//

import Foundation
import CoreData

extension Catalogue {
    
    static func getItemOrCreate(forProduct product: Product) -> Catalogue {
        return getItem(forProduct: product, addItemIfNeeded: true)!
    }
    
    static func getItem(forProduct product: Product, addItemIfNeeded: Bool = false) -> Catalogue? {
        let predicate = NSPredicate(format: "product.id == \(product.id)")
        let item: Catalogue? = DataController.getItem(forPredicate: predicate, addItemIfNeeded: addItemIfNeeded)
        item?.product = product
        return item
    }
    
    static func getAllItems() -> [Catalogue] {
        return DataController.getAllItems()
    }
    
    static func deleteAll() {
        let _: Catalogue? = DataController.deleteAll()
    }
}
