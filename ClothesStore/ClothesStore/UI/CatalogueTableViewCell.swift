//
//  CatalogueTableViewCell.swift
//  ClothesStore
//
//  Created by Alexandre Malkov on 12/12/2016.
//  Copyright © 2016 Alexandre Malkov. All rights reserved.
//

import UIKit

class CatalogueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var product: Product? {
        didSet {
            setName()
            setStock()
            setPrice()
        }
    }
    
    private func setName() {
        if product != nil {
            nameLabel.text = product?.name
        } else {
            nameLabel.text = ""
        }
    }
    
    private func setStock() {
        if product != nil {
            if product?.catalogue?.stock == 0 {
                stockLabel.text = "Out of stock!"
                stockLabel.textColor = UIColor.red
            } else if product?.catalogue?.stock == 1 {
                stockLabel.text = "Last item in stock"
                stockLabel.textColor = UIColor.purple
            } else {
                if let stock = product?.catalogue?.stock {
                    stockLabel.text = "\(stock) items in stock"
                    stockLabel.textColor = UIColor.blue
                }
            }
        } else {
            stockLabel.text = ""
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

}
