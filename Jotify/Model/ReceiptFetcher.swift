//
//  ReceiptFetcher.swift
//  Jotify
//
//  Created by Harrison Leath on 12/7/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import Foundation
import StoreKit

class ReceiptFetcher : NSObject, SKRequestDelegate {
    let receiptRefreshRequest = SKReceiptRefreshRequest()

    override init() {
        super.init()
        
        receiptRefreshRequest.delegate = self
    }
    
    func fetchReceipt() {
        guard let receiptUrl = Bundle.main.appStoreReceiptURL else {
            print("unable to retrieve receipt url")
            return
        }
        
        do {
            // if the receipt does not exist, start refreshing
            let reachable = try receiptUrl.checkResourceIsReachable()
            
            // the receipt does not exist, start refreshing
            if reachable == false {
                receiptRefreshRequest.start()
            }
        } catch {
            // the receipt does not exist, start refreshing
            print("error: \(error.localizedDescription)")
            // error: The file “sandboxReceipt” couldn’t be opened because there is no such file
            receiptRefreshRequest.start()
        }
    }
    
    // MARK: SKRequestDelegate methods
    func requestDidFinish(_ request: SKRequest) {
        print("request finished successfully")
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("request failed with error \(error.localizedDescription)")
    }
}

