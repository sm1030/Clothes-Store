//
//  CatalogueTableViewController.swift
//  ClothesStore
//
//  Created by Alexandre Malkov on 12/12/2016.
//  Copyright © 2016 Alexandre Malkov. All rights reserved.
//

import UIKit

class CatalogueTableViewController: UITableViewController, StoreControllerDelegate {
    
    let storeController = StoreController.sharedInstant

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Product catalogue"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        storeController.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func storeControllerDataUpdated() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func storeControllerMessage(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let actionCancel = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction) in
            }
            alert.addAction(actionCancel)
            self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ProductCategory.getAllItems().count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let productCategories = ProductCategory.getAllItems()
        if productCategories.count > section {
            let productCategory = productCategories[section]
            if let products = productCategory.products {
                return products.count
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        label.textAlignment = .center
        label.backgroundColor = UIColor.blue
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        
        let productCategories = ProductCategory.getAllItems()
        if productCategories.count > section {
            let productCategory = productCategories[section]
            label.text = productCategory.name
        }
        
        return label
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catalogueCell", for: indexPath) as! CatalogueTableViewCell

        let productCategories = ProductCategory.getAllItems()
        if productCategories.count > indexPath.section {
            let productCategory = productCategories[indexPath.section]
            if let products = productCategory.products {
                if products.count > indexPath.row {
                    let product = (products.allObjects)[indexPath.row]
                    cell.product = product as? Product
                }
            }
        }

        return cell
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let productCategories = ProductCategory.getAllItems()
        if productCategories.count > indexPath.section {
            let productCategory = productCategories[indexPath.section]
            if let products = productCategory.products {
                if products.count > indexPath.row {
                    let product = (products.allObjects)[indexPath.row]
                    storeController.selectedProduct = product as? Product
                    performSegue(withIdentifier: "showDetails", sender: self)
                }
            }
        }
    }

}
