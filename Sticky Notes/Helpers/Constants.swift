//
//  Constants.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/8/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

struct Colors {
    
    static var lightPurple = UIColor(red:90/255, green: 50/255, blue: 120/255, alpha: 1)
    
    static var darkPurple = UIColor(red:70/255, green: 38/255, blue: 92/255, alpha: 1)
    
    static var white = UIColor(red:255/255, green: 255/255, blue: 255/255, alpha: 1)
    
    static var darkBlue = UIColor(red: 36/255, green: 39/225, blue: 47/55, alpha: 1)
    
    static var lighterDarkBlue = UIColor(red: 36, green: 41, blue: 50, alpha: 1)
    
    static var gray = UIColor(red: 50, green: 54, blue: 63, alpha: 1)
    
    static var offWhite = UIColor(red: 247, green: 247, blue: 247, alpha: 1)
    
    static var placeholder = UIColor(red: 136, green: 180, blue: 177, alpha: 1)
    
    var blueGradient:CAGradientLayer!
    
    init() {
        let startBlue = UIColor(red: 164 / 255.0, green: 237 / 255.0, blue: 221 / 255.0, alpha: 1.0).cgColor
        let endBlue = UIColor(red: 108 / 255.0, green: 209 / 255.0, blue: 221 / 255.0, alpha: 1.0).cgColor
        
        self.blueGradient = CAGradientLayer()
        self.blueGradient.colors = [startBlue, endBlue]
        self.blueGradient.locations = [0.0, 1.0]
    }
    
}

//only use following if WelcomeViewController is used

#if os(OSX)
import AppKit.NSImage
internal typealias AssetColorTypeAlias = NSColor
internal typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
import UIKit.UIImage
internal typealias AssetColorTypeAlias = UIColor
internal typealias AssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
    internal static let banks = ImageAsset(name: "Banks")
    internal static let hotels = ImageAsset(name: "Hotels")
    internal static let key = ImageAsset(name: "Key")
    internal static let shoppingCart = ImageAsset(name: "Shopping-cart")
    internal static let stores = ImageAsset(name: "Stores")
    internal static let wallet = ImageAsset(name: "Wallet")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ColorAsset {
    internal fileprivate(set) var name: String
    
    #if swift(>=3.2)
    @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
    internal var color: AssetColorTypeAlias {
        return AssetColorTypeAlias(asset: self)
    }
    #endif
}

internal extension AssetColorTypeAlias {
    #if swift(>=3.2)
    @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
    convenience init!(asset: ColorAsset) {
        let bundle = Bundle(for: BundleToken.self)
        #if os(iOS) || os(tvOS)
        self.init(named: asset.name, in: bundle, compatibleWith: nil)
        #elseif os(OSX)
        self.init(named: asset.name, bundle: bundle)
        #elseif os(watchOS)
        self.init(named: asset.name)
        #endif
    }
    #endif
}

internal struct DataAsset {
    internal fileprivate(set) var name: String
    
    #if (os(iOS) || os(tvOS) || os(OSX)) && swift(>=3.2)
    @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
    internal var data: NSDataAsset {
        return NSDataAsset(asset: self)
    }
    #endif
}

#if (os(iOS) || os(tvOS) || os(OSX)) && swift(>=3.2)
@available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
internal extension NSDataAsset {
    convenience init!(asset: DataAsset) {
        let bundle = Bundle(for: BundleToken.self)
        self.init(name: asset.name, bundle: bundle)
    }
}
#endif

internal struct ImageAsset {
    internal fileprivate(set) var name: String
    
    internal var image: AssetImageTypeAlias {
        let bundle = Bundle(for: BundleToken.self)
        #if os(iOS) || os(tvOS)
        let image = AssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
        #elseif os(OSX)
        let image = bundle.image(forResource: name)
        #elseif os(watchOS)
        let image = AssetImageTypeAlias(named: name)
        #endif
        guard let result = image else { fatalError("Unable to load image named \(name).") }
        return result
    }
}

internal extension AssetImageTypeAlias {
    @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
    @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
    convenience init!(asset: ImageAsset) {
        #if os(iOS) || os(tvOS)
        let bundle = Bundle(for: BundleToken.self)
        self.init(named: asset.name, in: bundle, compatibleWith: nil)
        #elseif os(OSX) || os(watchOS)
        self.init(named: asset.name)
        #endif
    }
}

private final class BundleToken {}

