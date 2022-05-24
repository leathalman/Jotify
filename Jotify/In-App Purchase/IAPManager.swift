//
//  IAPManager.swift
//  Jotify
//
//  Created by Harrison Leath on 5/23/22.
//

//MARK: Adapted from https://www.appcoda.com/in-app-purchases-guide/

import StoreKit

class IAPManager: NSObject {
    
    enum IAPManagerError: Error {
        case noProductIDsFound
        case noProductsFound
        case paymentWasCancelled
        case productRequestFailed
    }
    
    static let shared = IAPManager()
    
    static var products = [SKProduct]()
    
    var onReceiveProductsHandler: ((Result<[SKProduct], IAPManagerError>) -> Void)?
    
    var onBuyProductHandler: ((Result<Bool, Error>) -> Void)?
    
    var totalRestoredPurchases = 0
    
    private override init() {
        super.init()
    }
    
    fileprivate func getProductIDs() -> [String]? {
        guard let url = Bundle.main.url(forResource: "IAP_ProductIDs", withExtension: "plist") else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let productIDs = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? [String] ?? []
            return productIDs
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getProducts(withHandler productsReceiveHandler: @escaping (_ result: Result<[SKProduct], IAPManagerError>) -> Void) {
        // Keep the handler (closure) that will be called when requesting for
        // products on the App Store is finished.
        onReceiveProductsHandler = productsReceiveHandler
        
        // Get the product identifiers.
        guard let productIDs = getProductIDs() else {
            productsReceiveHandler(.failure(.noProductIDsFound))
            return
        }
        
        // Initialize a product request.
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        
        // Set self as the its delegate.
        request.delegate = self
        
        // Make the request.
        request.start()
    }
    
    func getPriceFormatted(for product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
    
    func startObserving() {
        SKPaymentQueue.default().add(self)
    }
    
    
    func stopObserving() {
        SKPaymentQueue.default().remove(self)
    }
    
    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func buy(product: SKProduct, withHandler handler: @escaping ((_ result: Result<Bool, Error>) -> Void)) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        
        // Keep the completion handler.
        onBuyProductHandler = handler
    }
    
    func restorePurchases(withHandler handler: @escaping ((_ result: Result<Bool, Error>) -> Void)) {
        onBuyProductHandler = handler
        totalRestoredPurchases = 0
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension IAPManager.IAPManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noProductIDsFound: return "No In-App Purchase product identifiers were found."
        case .noProductsFound: return "No In-App Purchases were found."
        case .productRequestFailed: return "Unable to fetch available In-App Purchase products at the moment."
        case .paymentWasCancelled: return "In-App Purchase process was cancelled."
        }
    }
}

extension IAPManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        // Get the available products contained in the response.
        let products = response.products
        
        // Check if there are any products available.
        if products.count > 0 {
            // Call the following handler passing the received products.
            onReceiveProductsHandler?(.success(products))
        } else {
            // No products were found.
            onReceiveProductsHandler?(.failure(.noProductsFound))
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        onReceiveProductsHandler?(.failure(.productRequestFailed))
    }
    
    
    func requestDidFinish(_ request: SKRequest) {
        // Implement this method OPTIONALLY and add any custom logic
        // you want to apply when a product request is finished.
        print("IAP was fetched")
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { (transaction) in
            switch transaction.transactionState {
            case .purchased:
                onBuyProductHandler?(.success(true))
                SKPaymentQueue.default().finishTransaction(transaction)
                print("purchase was successful")
            case .restored:
                totalRestoredPurchases += 1
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .failed:
                if let error = transaction.error as? SKError {
                    if error.code != .paymentCancelled {
                        onBuyProductHandler?(.failure(error))
                    } else {
                        onBuyProductHandler?(.failure(IAPManagerError.paymentWasCancelled))
                    }
                    print("IAP Error:", error.localizedDescription)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .deferred, .purchasing: break
            @unknown default: break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if totalRestoredPurchases != 0 {
            onBuyProductHandler?(.success(true))
        } else {
            print("IAP: No purchases to restore!")
            onBuyProductHandler?(.success(false))
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        if let error = error as? SKError {
            if error.code != .paymentCancelled {
                print("IAP Restore Error:", error.localizedDescription)
                onBuyProductHandler?(.failure(error))
            } else {
                onBuyProductHandler?(.failure(IAPManagerError.paymentWasCancelled))
            }
        }
    }
}

extension IAPManager {

    func requestIAP() {
        IAPManager.shared.getProducts { (result) in
            switch result {
            case .success(let products): IAPManager.products = products
            case .failure(let error): self.showIAPError(error: error)
            }
        }
    }
    
    func showIAPError(error: Error) {
        let message = error.localizedDescription
        print(message)
    }
    
    func purchase(product: SKProduct) -> Bool {
        if !IAPManager.shared.canMakePayments() {
            return false
        } else {
            IAPManager.shared.buy(product: product) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_): self.grantHasPremium()
                    case .failure(let error): self.showIAPError(error: error)
                    }
                }
            }
        }
        return true
    }
    
    func grantHasPremium() {
        DataManager.updateUserSettings(setting: "hasPremium", value: true) { success in
            if success! {
                User.updateSettings()
            } else {
                print("Error updating Firestore when enabling premium")
            }
        }
    }
}
