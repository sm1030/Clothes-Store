//
//  BasketTableViewController.swift
//  ClothesStore
//
//  Created by Alexandre Malkov on 12/12/2016.
//  Copyright © 2016 Alexandre Malkov. All rights reserved.
//

import UIKit

class BasketTableViewController: UITableViewController, StoreControllerDelegate {
    
    let storeController = StoreController.sharedInstant
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        storeController.delegate = self
        tableView.reloadData()
        updateTitle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func storeControllerDataUpdated() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateTitle()
        }
    }
    
    func updateTitle() {
        self.navigationItem.title = "Total amount: £\(storeController.getTotalAmount())"
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
        return Basket.getAllItems().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basketCell", for: indexPath) as! BasketTableViewCell
        
        let basketList = Basket.getAllItems()
        if basketList.count > indexPath.row {
            let basket = basketList[indexPath.row]
            cell.product = basket.product
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let basketList = Basket.getAllItems()
        if basketList.count > indexPath.row {
            let basket = basketList[indexPath.row]
            storeController.selectedProduct = basket.product
            performSegue(withIdentifier: "showDetails", sender: self)
        }
    }
    
}
