//
//  CatalogueTests.swift
//  ClothesStore
//
//  Created by Alexandre Malkov on 11/12/2016.
//  Copyright © 2016 Alexandre Malkov. All rights reserved.
//

import XCTest
@testable import ClothesStore

class CatalogueTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Product.deleteAll()
        Catalogue.deleteAll()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreateAndGet() {
        
        // Make sure there is no data
        XCTAssertEqual(Catalogue.getAllItems().count, 0)
        
        // Create two category objects
        let category1 = ProductCategory.getItemOrCreate(forName: "cat1")
        let category2 = ProductCategory.getItemOrCreate(forName: "cat2")
        
        // Create product1 objects
        let product1 = Product.getItemOrCreate(forId: 1)
        product1.name = "Product1"
        product1.price = 111
        product1.productCategory = category1
        
        // Create product2 objects
        let product2 = Product.getItemOrCreate(forId: 2)
        product2.name = "Product2"
        product2.price = 222
        product2.productCategory = category2
        
        // Add products to Catalogue
        let catalogue1 = Catalogue.getItemOrCreate(forProduct: product1)
        let catalogue2 = Catalogue.getItemOrCreate(forProduct: product2)
        
        // Should be 2 item
        XCTAssertEqual(Catalogue.getAllItems().count, 2)
        
        //Check results for product1
        let savedCatalogue1 = Catalogue.getItem(forProduct: product1)
        XCTAssertEqual(catalogue1, savedCatalogue1)
        let savedProduct1 = savedCatalogue1?.product
        XCTAssertEqual(product1, savedProduct1)
        XCTAssertEqual(product1.id, savedProduct1?.id)
        XCTAssertEqual(product1.name, savedProduct1?.name)
        XCTAssertEqual(product1.price, savedProduct1?.price)
        XCTAssertEqual(product1.productCategory, savedProduct1?.productCategory)
        XCTAssertEqual(product1.productCategory?.name, savedProduct1?.productCategory?.name)
        
        //Check results for product 2
        let savedCatalogue2 = Catalogue.getItem(forProduct: product2)
        XCTAssertEqual(catalogue2, savedCatalogue2)
        let savedProduct2 = savedCatalogue2?.product
        XCTAssertEqual(product2, savedProduct2)
        XCTAssertEqual(product2.id, savedProduct2?.id)
        XCTAssertEqual(product2.name, savedProduct2?.name)
        XCTAssertEqual(product2.price, savedProduct2?.price)
        XCTAssertEqual(product2.productCategory, savedProduct2?.productCategory)
        XCTAssertEqual(product2.productCategory?.name, savedProduct2?.productCategory?.name)
        
        // Delete all
        Catalogue.deleteAll()
        
        // Should be 0 items
        XCTAssertEqual(Catalogue.getAllItems().count, 0)
    }
    
}
