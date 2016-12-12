//
//  apiServicesTests.swift
//  ClothesStore
//
//  Created by Alexandre Malkov on 11/12/2016.
//  Copyright © 2016 Alexandre Malkov. All rights reserved.
//

import XCTest
@testable import ClothesStore

class ApiServicesTests: XCTestCase {
    
    var api: ApiService = ApiService()
    
    override func setUp() {
        super.setUp()
        ProductCategory.deleteAll()
        Product.deleteAll()
        Catalogue.deleteAll()
        Basket.deleteAll()
        WishList.deleteAll()
        
        // Prepare ApiService
        api = ApiService()
        api.testMode = true
        
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testGetAllProducts() {
        // Prepare ApiService
        api.testMode = true
        api.mockUpFile = "Products"
        
        // Execute request
        api.getAllProducts() { (errorMessage: String?) in
            if errorMessage == nil {
                
                // Check first product
                var product = Product.getItem(forId: 1)
                if let p = product {
                    XCTAssertEqual(p.id, 1)
                    XCTAssertEqual(p.name, "Almond Toe Court Shoes, Patent Black")
                    XCTAssertEqual(p.productCategory?.name, "Women's Footwear")
                    XCTAssertEqual(p.price, 99)
                    XCTAssertEqual(p.catalogue?.stock, 5)
                } else {
                    XCTFail()
                }
                
                // Check last product
                product = Product.getItem(forId: 13)
                if let p = product {
                    XCTAssertEqual(p.id, 13)
                    XCTAssertEqual(p.name, "Mid Twist Cut-Out Dress, Pink")
                    XCTAssertEqual(p.productCategory?.name, "Women's Formalwear")
                    XCTAssertEqual(p.price, 540)
                    XCTAssertEqual(p.catalogue?.stock, 5)
                } else {
                    XCTFail()
                }
                
            } else {
                XCTAssertEqual(errorMessage, nil)
            }
        }
    }
    
    func testGetProduct() {
        
        // Prepare ApiService
        api.mockUpFile = "Product"
        
        // Execute request
        api.getProduct(productId: 1) { (errorMessage: String?) in
            if errorMessage == nil {
                // Check results
                let product = Product.getItem(forId: 1)
                if let p = product {
                    XCTAssertEqual(p.id, 1)
                    XCTAssertEqual(p.name, "Almond Toe Court Shoes, Patent Black")
                    XCTAssertEqual(p.productCategory?.name, "Women's Footwear")
                    XCTAssertEqual(p.price, 99)
                    XCTAssertEqual(p.catalogue?.stock, 5)
                } else {
                    XCTFail()
                }
            } else {
                XCTAssertEqual(errorMessage, nil)
            }
        }
    }
    
}
