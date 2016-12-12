//
//  DetailsViewController.swift
//  ClothesStore
//
//  Created by Alexandre Malkov on 12/12/2016.
//  Copyright © 2016 Alexandre Malkov. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, StoreControllerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var basketLabel: UILabel!
    @IBOutlet weak var wishListButton: UIButton!
    
    let store = StoreController.sharedInstant

    override func viewDidLoad() {
        super.viewDidLoad()
        store.delegate = self
        updateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func basketRemove(_ sender: UIButton) {
        store.removeProductFromBasket(product: store.selectedProduct!)
    }
    
    @IBAction func basketAdd(_ sender: UIButton) {
        store.addProductToBasket(product: store.selectedProduct!)
    }

    @IBAction func wishListToggle(_ sender: UIButton) {
        if store.selectedProduct?.wishList == nil {
            store.addProductToWishList(product: store.selectedProduct!)
        } else {
            store.removeProductFromWishList(product: store.selectedProduct!)
        }
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func storeControllerDataUpdated() {
        DispatchQueue.main.async {
            self.updateLabels()
        }
    }
    
    func storeControllerMessage(title: String, message: String) {
        
    }
    
    func updateLabels() {
        if let product = store.selectedProduct {
            
            nameLabel.text = product.name
            
            categoryLabel.text = product.productCategory?.name
            
            priceLabel.text = "£\(product.price)"
            
            if product.catalogue?.stock == 0 {
                stockLabel.text = "Out of stock!"
                stockLabel.textColor = UIColor.red
            } else if product.catalogue?.stock == 1 {
                stockLabel.text = "Last item in stock"
                stockLabel.textColor = UIColor.purple
            } else {
                if let stock = product.catalogue?.stock {
                    stockLabel.text = "\(stock) items in stock"
                    stockLabel.textColor = UIColor.blue
                }
            }
            
            basketLabel.text = "\(product.basket?.count ?? 0)"
            
            if product.wishList == nil {
                wishListButton.backgroundColor = UIColor.green
                wishListButton.setTitle("Add to Wish List", for: .normal)
            } else {
                wishListButton.backgroundColor = UIColor.yellow
                wishListButton.setTitle("Remove from Wish List", for: .normal)
            }
        }
    }
    
}
