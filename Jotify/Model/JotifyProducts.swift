//
//  JotifyProducts.swift
//  Jotify
//
//  Created by Harrison Leath on 8/20/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import Foundation

public struct JotifyProducts {
    
    public static let premium = "com.austinleath.Jotify.premium"
    
    private static let productIdentifiers: Set<ProductIdentifier> = [JotifyProducts.premium]
    
    public static let store = IAPHelper(productIds: JotifyProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    
    return productIdentifier.components(separatedBy: ".").last
}
