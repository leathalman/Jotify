//
//  Extensions.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/8/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

//when logincontroller is fixed, remove photo download part, also check that photo library access is not required for app, in build settings/capabilities
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

public extension CALayer {
    
    func addShadow(color: UIColor) {
        self.shadowOffset = .zero
        self.shadowOpacity = 0.3
        self.shadowRadius = 5
        self.shadowColor = color.cgColor
        self.masksToBounds = false
        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    func roundCorners(radius: CGFloat) {
        self.cornerRadius = radius
        if shadowOpacity != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    func showShadow(duration: CFTimeInterval?) {
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = self.shadowOpacity
        animation.toValue = 0.3
        animation.duration = (duration) ?? (0)
        self.add(animation, forKey: animation.keyPath)
        self.shadowOpacity = 0.3
    }
    
    func hideShadow(duration: CFTimeInterval?) {
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = self.shadowOpacity
        animation.toValue = 0.0
        animation.duration = (duration) ?? (0)
        self.add(animation, forKey: animation.keyPath)
        self.shadowOpacity = 0.0
    }
}

extension CALayer {
    
    private func addShadowWithRoundedCorners() {
        if let contents = self.contents {
            let contentLayerName = "contentLayer"
            masksToBounds = false
            sublayers?.filter { $0.frame.equalTo(self.bounds) }.forEach {
                $0.roundCorners(radius: self.cornerRadius)
            }
            self.contents = nil
            if let sublayer = sublayers?.first,
                sublayer.name == contentLayerName {
                sublayer.removeFromSuperlayer()
            }
            let contentLayer = CALayer()
            contentLayer.name = contentLayerName
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = cornerRadius
            contentLayer.masksToBounds = true
            insertSublayer(contentLayer, at: 0)
        }
    }
}

extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
}
