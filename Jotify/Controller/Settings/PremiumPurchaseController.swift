//
//  PremiumPurchaseController.swift
//  Jotify
//
//  Created by Harrison Leath on 8/14/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import StoreKit

class PremiumPurchaseController: UITableViewController {
    
    //test product arrays/approval from Apple Payments
    
    var productsArray: [SKProduct] = []
    var productIDs: [String] = ["com.austinleath.Jotify.premium"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Jotify Premium"
        
        self.tableView.register(SettingsCell.self, forCellReuseIdentifier: "cell")
        
        IAPHandler.shared.setProductIds(ids: self.productIDs)
        IAPHandler.shared.fetchAvailableProducts { [weak self](products)   in
            self?.productsArray = products
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        IAPHandler.shared.purchase(product: self.productsArray[indexPath.row]) { (alert, product, transaction) in
            if let tran = transaction, let prod = product {
                print(tran)
                print(prod)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingsCell
        
        let product = productsArray[indexPath.row]
        cell.textLabel?.text = product.localizedTitle
        
        return cell
    }
}
