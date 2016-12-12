//
//  BasketTableViewCell.swift
//  ClothesStore
//
//  Created by Alexandre Malkov on 12/12/2016.
//  Copyright © 2016 Alexandre Malkov. All rights reserved.
//

import UIKit

class BasketTableViewCell: UITableViewCell {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    var product: Product? {
        didSet {
            setName()
            setProductCategory()
            setPrice()
            setCount()
        }
    }
    
    private func setName() {
        if product != nil {
            nameLabel.text = product?.name
        } else {
            nameLabel.text = ""
        }
    }
    
    private func setProductCategory() {
        if product != nil {
            productCategoryLabel.text = (product?.productCategory?.name)!
        } else {
            productCategoryLabel.text = ""
        }
    }
    
    private func setPrice() {
        if product != nil {
            if let price = product?.price {
                priceLabel.text = "£\(price)"
            }
        } else {
            priceLabel.text = ""
        }
    }
    
    private func setCount() {
        if product != nil {
            if let count = product?.basket?.count {
                countLabel.text = "\(count)"
            }
        } else {
            countLabel.text = "0"
        }
    }
}
