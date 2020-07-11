//
//  ReceiptHandler.swift
//  Jotify
//
//  Created by Harrison Leath on 7/11/20.
//  Copyright © 2020 Harrison Leath. All rights reserved.
//

import Foundation

class ReceiptHandler {
    
    func handleReceiptValidation() {
        let receiptFetcher = ReceiptFetcher()
        
        // fetch receipt if receipt file doesn't exist yet
        receiptFetcher.fetchReceipt()
        
        // validage receipt
        let receiptValidator = ReceiptValidator()
        let validationResult = receiptValidator.validateReceipt()

        switch validationResult {
        case .success(let receipt):
            // receipt validation success
            // Work with parsed receipt data.
            print("original receipt app version is \(receipt.originalAppVersion ?? "n/a")")
            grantPremiumToPreviousUser(receipt: receipt)
        case .error(let error):
            // receipt validation failed, refer to enum ReceiptValidationError
            print("error is \(error.localizedDescription)")
        }
    }
    
    func grantPremiumToPreviousUser(receipt: ParsedReceipt) {
        let originalAppVersionString = receipt.originalAppVersion
        
        // the last build version when the app is still a paid app
        if originalAppVersionString == "1.0" || originalAppVersionString == "1.1.0" || originalAppVersionString == "1.1.1" || originalAppVersionString == "1.1.2" || originalAppVersionString == "1.1.3" {
            // grant user premium
            UserDefaults.standard.set(true, forKey: "com.austinleath.Jotify.Premium")
            print("premium granted from receipt")
        }
    }
}
