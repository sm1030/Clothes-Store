//
//  Basket.swift
//  ClothesStore
//
//  Created by Alexandre Malkov on 11/12/2016.
//  Copyright © 2016 Alexandre Malkov. All rights reserved.
//

import Foundation
import CoreData

extension Basket {
    
    static func getItemOrCreate(forProduct product: Product) -> Basket {
        return getItem(forProduct: product, addItemIfNeeded: true)!
    }
    
    static func getItem(forProduct product: Product, addItemIfNeeded: Bool = false) -> Basket? {
        let predicate = NSPredicate(format: "product.id == \(product.id)")
        let item: Basket? = DataController.getItem(forPredicate: predicate, addItemIfNeeded: addItemIfNeeded)
        item?.product = product
        return item
    }
    
    static func getAllItems() -> [Basket] {
        let sortDescriptors = [NSSortDescriptor(key: "product.id", ascending: true)]
        return DataController.getAllItems(sortDescriptors: sortDescriptors)
    }
    
    static func deleteAll() {
        let _: Basket? = DataController.deleteAll()
    }
}
