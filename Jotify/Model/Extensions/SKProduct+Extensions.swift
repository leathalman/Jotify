//
//  SKProduct+Extensions.swift
//  Jotify
//
//  Created by Harrison Leath on 2/18/20.
//  Copyright © 2020 Harrison Leath. All rights reserved.
//

import StoreKit

extension SKProduct {
    
    var localizedPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)
    }
}
