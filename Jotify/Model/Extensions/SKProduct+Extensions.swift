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

extension UIPageViewController {

    func goToNextPage() {
       guard let currentViewController = self.viewControllers?.first else { return }
       guard let nextViewController = dataSource?.pageViewController( self, viewControllerAfter: currentViewController ) else { return }
       setViewControllers([nextViewController], direction: .forward, animated: false, completion: nil)
    }

    func goToPreviousPage() {
       guard let currentViewController = self.viewControllers?.first else { return }
       guard let previousViewController = dataSource?.pageViewController( self, viewControllerBefore: currentViewController ) else { return }
       setViewControllers([previousViewController], direction: .reverse, animated: false, completion: nil)
    }

}
