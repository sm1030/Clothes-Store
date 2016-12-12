//
//  StoreController.swift
//  ClothesStore
//
//  Created by Alexandre Malkov on 11/12/2016.
//  Copyright © 2016 Alexandre Malkov. All rights reserved.
//

import Foundation

protocol StoreControllerDelegate: class {
    func storeControllerDataUpdated()
    func storeControllerMessage(title: String, message: String)
}

class StoreController {
    
    static let sharedInstant = StoreController()
    
    var delegate: StoreControllerDelegate?
    
    private let api = ApiService()
    
    init(testMode: Bool = false) {
        
        // Clean up all database info
        ProductCategory.deleteAll()
        Product.deleteAll()
        Catalogue.deleteAll()
        Basket.deleteAll()
        WishList.deleteAll()
        
        // Get new product catalogue data
        api.testMode = testMode
        api.getAllProducts { (errorMessage) in
            if errorMessage == nil {
                self.delegate?.storeControllerDataUpdated()
            } else {
                let message = "Can not download product catalgue with error: \(errorMessage)"
                self.delegate?.storeControllerMessage(title: "Error", message: message)
            }
        }
    }
    
    func addProductToBasket(product: Product) {
        let catalogue = Catalogue.getItemOrCreate(forProduct: product)
        if catalogue.stock > 0 {
            catalogue.stock -= 1
            let basket = Basket.getItemOrCreate(forProduct: product)
            basket.count += 1
            
            delegate?.storeControllerDataUpdated()
            
            api.addProductToCart(productId: Int(product.id), onFinish: { (errorMessage) in
                if errorMessage != nil {
                    let message = "Can not add \"\(product.name)\" to the shopping cart with error: \(errorMessage)"
                    self.delegate?.storeControllerMessage(title: "Error", message: message)
                }
            })
        } else {
            let message = "Can not add\"\(product.name)\" to the shopping cart, because it is currently out of stock"
            delegate?.storeControllerMessage(title: "Shopping Cart", message: message)
        }
    }
    
    func removeProductFromBasket(product: Product) {
        let optionalBasket = Basket.getItem(forProduct: product)
        if let basket = optionalBasket {
            if basket.count > 0 {
                let catalogue = Catalogue.getItemOrCreate(forProduct: product)
                catalogue.stock += 1
                
                basket.count -= 1
                
                if basket.count == 0 {
                    DataController.getContext().delete(basket)
                }
                
                delegate?.storeControllerDataUpdated()
                
                // I'm using cartId == 1, because shopping cart list is not implemented in server API, so I don't have access to that value!
                api.removeProductFromCart(cartId: 1, onFinish: { (errorMessage) in
                    if errorMessage != nil {
                        let message = "Can not remove \"\(product.name)\" to the shopping cart with error: \(errorMessage)"
                        self.delegate?.storeControllerMessage(title: "Error", message: message)
                    }
                })
            }
        }
    }
    
    func addProductToWishList(product: Product) {
        let _ = WishList.getItemOrCreate(forProduct: product)
        delegate?.storeControllerDataUpdated()
    }
    
    func removeProductFromWishList(product: Product) {
        let wishList = WishList.getItem(forProduct: product)
        if wishList != nil {
            DataController.getContext().delete(wishList!)
            delegate?.storeControllerDataUpdated()
        }
    }
    
    func commitPurchase() {
        Basket.deleteAll()
        
        WishList.deleteAll()
        
        let message = "Congratulations! You purchase was successful!"
        delegate?.storeControllerMessage(title: "Checkout", message: message)
    }
    
    func cancelPurchase() {
        for basket in Basket.getAllItems() {
            if let basketProduct = basket.product {
                if let catalogue = Catalogue.getItem(forProduct: basketProduct) {
                    catalogue.stock += basket.count
                }
            }
        }
        
        Basket.deleteAll()
        
        let message = "You checkout have been cancelled."
        delegate?.storeControllerMessage(title: "Checkout", message: message)
    }
    
}
