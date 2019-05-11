//
//  Extensions.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/8/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            }
        }).resume() }
}

extension String {
    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}

extension Notification.Name {
    static let darkModeEnabled = Notification.Name("com.chat.notifications.darkModeEnabled")
    static let darkModeDisabled = Notification.Name("com.chat.notifications.darkModeDisabled")
}

extension UIViewController {
    func darkTheme(tableView: UITableView) {
        view.backgroundColor = Colors.lighterDarkBlue
        tableView.backgroundColor = Colors.lighterDarkBlue
        navigationController?.navigationBar.barTintColor = Colors.lighterDarkBlue
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
    }
    
    func lightTheme(tableView: UITableView) {
        view.backgroundColor = UIColor.white
        tableView.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = Colors.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
//        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
        
    }
}
