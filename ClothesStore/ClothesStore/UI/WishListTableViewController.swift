//
//  WishListTableViewController.swift
//  ClothesStore
//
//  Created by Alexandre Malkov on 12/12/2016.
//  Copyright © 2016 Alexandre Malkov. All rights reserved.
//

import UIKit

class WishListTableViewController: UITableViewController, StoreControllerDelegate {
    
    let storeController = StoreController.sharedInstant
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Wish List"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        storeController.delegate = self
        tableView.reloadData()
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WishList.getAllItems().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishListCell", for: indexPath) as! WishListTableViewCell
        
        let wishList = WishList.getAllItems()
        if wishList.count > indexPath.row {
            let basket = wishList[indexPath.row]
            cell.product = basket.product
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let wishList = WishList.getAllItems()
        if wishList.count > indexPath.row {
            let wishItem = wishList[indexPath.row]
            storeController.selectedProduct = wishItem.product
            performSegue(withIdentifier: "showDetails", sender: self)
        }
    }
    
}
