//
//  CategoryTests.swift
//  ClothesStore
//
//  Created by Alexandre Malkov on 10/12/2016.
//  Copyright © 2016 Alexandre Malkov. All rights reserved.
//

import XCTest
@testable import ClothesStore

class ProductCategoryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        ProductCategory.deleteAll()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreateAndGet() {
        
        // Make sure there is no data
        XCTAssertEqual(ProductCategory.getAllItems().count, 0)
        
        // Create two category objects
        let cat1 = ProductCategory.getItemOrCreate(forName: "cat1")
        let cat2 = ProductCategory.getItemOrCreate(forName: "cat2")
        
        // Should be 2 item
        XCTAssertEqual(ProductCategory.getAllItems().count, 2)
        
        //Check results
        XCTAssertEqual(cat1, ProductCategory.getItem(forName: "cat1"))
        XCTAssertEqual(cat2, ProductCategory.getItem(forName: "cat2"))
        
        // Delete all
        ProductCategory.deleteAll()
        
        // Should be 0 items
        XCTAssertEqual(ProductCategory.getAllItems().count, 0)
    }
    
}
