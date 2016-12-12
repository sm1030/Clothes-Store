//
//  ApiService.swift
//  ClothesStore
//
//  Created by Alexandre Malkov on 11/12/2016.
//  Copyright © 2016 Alexandre Malkov. All rights reserved.
//

import Foundation
import Alamofire

class ApiService {
    
    var testMode = false
    var mockUpFile = ""
    
    func getAllProducts(onFinish: @escaping (String?)->Void) {
        if testMode {
            if let jsonArray = readJsonFromFile(mockUpFile) as? Array<Dictionary<String, AnyObject>> {
                if self.parseAllProducts(jsonArray: jsonArray) {
                    onFinish(nil)
                } else {
                    onFinish("JSON parsing error")
                }
            }
        } else {
            let url = "https://private-anon-e64edcd5bc-ddshop.apiary-mock.com/products"
            Alamofire.request(url).responseJSON { response in
                
                var errorMessage: String? = "Network response contain no value"
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        if let result = response.result.value {
                            errorMessage = "Can't parse JSON response"
                            let jsonArray = result as! Array<Dictionary<String, AnyObject>>
                            if self.parseAllProducts(jsonArray: jsonArray) {
                                errorMessage = nil
                            }
                        }
                    default:
                        errorMessage = "error with response status: \(status)"
                    }
                }
                onFinish(errorMessage)
            }
        }
    }
    
    func parseAllProducts(jsonArray: Array<Dictionary<String, AnyObject>>) -> Bool {
        var success = true
        
        for jsonDictionary: Dictionary<String, AnyObject> in jsonArray {
            if parseProduct(jsonDictionary: jsonDictionary) == false {
                success = false
            }
        }
        
        return success
    }
    
    func getProduct(productId: Int, onFinish: @escaping (String?)->Void) {
        if testMode {
            if let jsonDictionary = readJsonFromFile(mockUpFile) as? Dictionary<String, AnyObject> {
                if parseProduct(jsonDictionary: jsonDictionary) {
                    onFinish(nil)
                } else {
                    onFinish("JSON parsing error")
                }
            }
        } else {
            let url = "https://private-anon-e64edcd5bc-ddshop.apiary-mock.com/products/\(productId)"
            Alamofire.request(url).responseJSON { response in
                
                var errorMessage: String? = "Network response contain no value"
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        if let result = response.result.value {
                            errorMessage = "Can't parse JSON response"
                            let jsonDictionary = result as! Dictionary<String, AnyObject>
                            if self.parseProduct(jsonDictionary: jsonDictionary) {
                                errorMessage = nil
                            }
                        }
                    default:
                        errorMessage = "error with response status: \(status)"
                    }
                }
                onFinish(errorMessage)
            }
        }
    }
    
    func parseProduct(jsonDictionary: Dictionary<String, AnyObject>) -> Bool {
        if let productId = jsonDictionary["productId"] as? Int {
            
            let product = Product.getItemOrCreate(forId: productId)
            
            product.name = jsonDictionary["name"] as? String
            
            if let price = jsonDictionary["price"] as? Int {
                product.price = Int64(price)
            }
            
            if let category = jsonDictionary["category"] as? String {
                product.productCategory = ProductCategory.getItemOrCreate(forName: category)
            }
            
            if let stock = jsonDictionary["stock"] as? Int {
                let catalogue = Catalogue.getItemOrCreate(forProduct: product)
                if catalogue.stock == 0 { // Local stock value have priority over server value, because server doesn't update stock value when I add product to the shopping cart
                    catalogue.stock = Int64(stock)
                }
            }
            
            return true
        }
        
        return false
    }
    
    func addProductToCart(productId: Int, onFinish: @escaping (String?)->Void) {
        if testMode {
            onFinish(nil)
        } else {
            let url = "https://private-anon-e64edcd5bc-ddshop.apiary-mock.com/cart"
            let parameters: Parameters = [ "productId": productId ]
            Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
                
                var errorMessage: String? = "Network response contain no value"
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 201:
                        errorMessage = nil
                    default:
                        errorMessage = "error with response status: \(status)"
                    }
                }
                onFinish(errorMessage)
            }
        }
    }
    
    func removeProductFromCart(cartId: Int, onFinish: @escaping (String?)->Void) {
        if testMode {
            onFinish(nil)
        } else {
            let url = "https://private-anon-e64edcd5bc-ddshop.apiary-mock.com/cart/\(cartId)"
            let parameters: Parameters = [ "cartId": cartId ]
            Alamofire.request(url, method: .delete, parameters: parameters).responseJSON { response in
                
                var errorMessage: String? = "Network response contain no value"
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 204:
                        errorMessage = nil
                    default:
                        errorMessage = "error with response status: \(status)"
                    }
                }
                onFinish(errorMessage)
            }
        }
    }
    
    private func readJsonFromFile(_ fileName: String) -> Any? {
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let jsonString = try String(contentsOfFile: filePath)
                if let jsonData = jsonString.data(using: .utf8) {
                    return try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions())
                }
            } catch let error {
                print("ERROR: \(error)")
            }
        }
        
        return nil
    }
}
