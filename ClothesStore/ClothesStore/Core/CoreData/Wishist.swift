//
//  Wishist.swift
//  ClothesStore
//
//  Created by Alexandre Malkov on 11/12/2016.
//  Copyright © 2016 Alexandre Malkov. All rights reserved.
//

import Foundation
import CoreData

extension WishList {
    
    static func getItemOrCreate(forProduct product: Product) -> WishList {
        return getItem(forProduct: product, addItemIfNeeded: true)!
    }
    
    static func getItem(forProduct product: Product, addItemIfNeeded: Bool = false) -> WishList? {
        let predicate = NSPredicate(format: "product.id == \(product.id)")
        let item: WishList? = DataController.getItem(forPredicate: predicate, addItemIfNeeded: addItemIfNeeded)
        item?.product = product
        return item
    }
    
    static func getAllItems() -> [WishList] {
        return DataController.getAllItems()
    }
    
    static func deleteAll() {
        let _: WishList? = DataController.deleteAll()
    }
}
