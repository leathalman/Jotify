//
//  Helper.swift
//  Pods-SQRichTextEditor_Example
//
//  Created by  Jesse on 2019/12/16.
//

import Foundation

struct Helper {
    static func hexToRGBColor(hex string: String) -> UIColor {
        let hex = string.hasPrefix("#")
            ? String(string.dropFirst())
            : string
        guard hex.count == 6 else {
            return UIColor(white: 1.0, alpha: 0.0)
        }
        
        return UIColor(
            red:   CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF) / 255.0,
            green: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF) / 255.0,
            blue:  CGFloat((Int(hex, radix: 16)!) & 0xFF) / 255.0, alpha: 1.0)
    }
    
    static func rgbColorToHex(color: UIColor) -> String {
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
