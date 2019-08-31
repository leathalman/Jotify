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
        
    var products: [SKProduct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Jotify Products"
        
        tableView.register(ProductCell.self, forCellReuseIdentifier: "cell")
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(PremiumPurchaseController.reload), for: .valueChanged)
        
        let restoreButton = UIBarButtonItem(title: "Restore",
                                            style: .plain,
                                            target: self,
                                            action: #selector(PremiumPurchaseController.restoreTapped(_:)))
        navigationItem.rightBarButtonItem = restoreButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(PremiumPurchaseController.handlePurchaseNotification(_:)),
                                               name: .IAPHelperPurchaseNotification,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reload()
    }
    
    @objc func reload() {
        products = []
                
        JotifyProducts.store.requestProducts{ [weak self] success, products in
            guard let self = self else { return }
            if success {
                self.products = products!
                
                print(products?.count as Any)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    @objc func restoreTapped(_ sender: AnyObject) {
        JotifyProducts.store.restorePurchases()
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard
            let productID = notification.object as? String,
            let index = products.firstIndex(where: { product -> Bool in
                product.productIdentifier == productID
            })
            else { return }
        
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
}

// MARK: - UITableViewDataSource

extension PremiumPurchaseController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCell
        
        let product = products[(indexPath as NSIndexPath).row]
        
        cell.product = product
        cell.buyButtonHandler = { product in
            JotifyProducts.store.buyProduct(product)
        }
        
        return cell
    }
}
