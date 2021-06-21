//
//  GradientThemes.swift
//  Jotify
//
//  Created by Harrison Leath on 6/20/21.
//

import UIKit

@objc public enum GradientThemes: Int {
    case Sunrise
    case Maldives
    case Amin
    case DIMIGO
    case NeonLife
    case BlueLagoon
    case Celestial
    case Kyoopal
    case SolidStone
    case GentleCare
    case All
    
    public func colors() -> [UIColor] {
        switch self {
        case .Sunrise:
            return [.sunrise1, .sunrise2, .sunrise3, .sunrise4]
        case .Amin:
            return [.amin1, .amin2, .amin3, .amin4]
        case .Maldives:
            return [.maldives1, .maldives2, .maldives3, .maldives4]
        case .DIMIGO:
            return [.dimigo1, .dimigo2, .dimigo3, .dimigo4]
        case .NeonLife:
            return [.neonlife1, .neonlife2, .neonlife3, .neonlife4]
        case .BlueLagoon:
            return [.bluelagoon1, .bluelagoon2, .bluelagoon3, .bluelagoon4]
        case .Celestial:
            return [.celestrial1, .celestrial2, .celestrial3, .celestrial4]
        case .Kyoopal:
            return [.kypool1, .kypool2, .kypool3, .kypool4,]
        case .SolidStone:
            return [.solidstone1, .solidstone2, .solidstone3, .solidstone4]
        case .GentleCare:
            return [.gentlecare1, .gentlecare2, .gentlecare3, .gentlecare4]
        case .All:
            return [.sunrise1, .sunrise2, .sunrise3, .sunrise4, .amin1, .amin2, .amin3, .amin4, .maldives1, .maldives2, .maldives3, .maldives4, .dimigo1, .dimigo2, .dimigo3, .dimigo4, .neonlife1, .neonlife2, .neonlife3, .neonlife4, .bluelagoon1, .bluelagoon2, .bluelagoon3, .bluelagoon4, .celestrial1, .celestrial2, .celestrial3, .celestrial4, .kypool1, .kypool2, .kypool3, .kypool4, .solidstone1, .solidstone2, .solidstone3, .solidstone4, .gentlecare1, .gentlecare2, .gentlecare3, .gentlecare4]
        }
    }
}

extension UIColor {
    //MISC: dark-greyish
    static let mineShaft = UIColor(r: 40, g: 40, b: 40)
    static let lightTrail = UIColor(r: 239, g: 243, b: 244)
    static let gainsboro = UIColor(hex: "#E8ECED")
    
    //sunrise
    static let sunrise1 = #colorLiteral(red: 0.9411764706, green: 0.5960784314, blue: 0.09803921569, alpha: 1)
    static let sunrise2 = #colorLiteral(red: 0.8941176471, green: 0.5764705882, blue: 0.1176470588, alpha: 1)
    static let sunrise3 = #colorLiteral(red: 0.9647058824, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
    static let sunrise4 = #colorLiteral(red: 1, green: 0.3450980392, blue: 0.3450980392, alpha: 1)
    
    //amin
    static let amin1 = #colorLiteral(red: 0.1450980392, green: 0.4588235294, blue: 0.9882352941, alpha: 1)
    static let amin2 = #colorLiteral(red: 0.1450980392, green: 0.4274509804, blue: 0.9019607843, alpha: 1)
    static let amin3 = #colorLiteral(red: 0.4352941176, green: 0.1137254902, blue: 0.7843137255, alpha: 1)
    static let amin4 = #colorLiteral(red: 0.4156862745, green: 0.06666666667, blue: 0.7960784314, alpha: 1)
    
    //maldives
    static let maldives1 = #colorLiteral(red: 0, green: 0.9490196078, blue: 0.9960784314, alpha: 1)
    static let maldives2 = #colorLiteral(red: 0.07058823529, green: 0.9019607843, blue: 0.9411764706, alpha: 1)
    static let maldives3 = #colorLiteral(red: 0.368627451, green: 0.6470588235, blue: 0.8901960784, alpha: 1)
    static let maldives4 = #colorLiteral(red: 0.3098039216, green: 0.6745098039, blue: 0.9960784314, alpha: 1)
    
    //DIMIGO
    static let dimigo1 = #colorLiteral(red: 0.9960784314, green: 0.3176470588, blue: 0.5882352941, alpha: 1)
    static let dimigo2 = #colorLiteral(red: 0.9254901961, green: 0.2862745098, blue: 0.5411764706, alpha: 1)
    static let dimigo3 = #colorLiteral(red: 0.9098039216, green: 0.3647058824, blue: 0.3058823529, alpha: 1)
    static let dimigo4 = #colorLiteral(red: 0.968627451, green: 0.4392156863, blue: 0.3843137255, alpha: 1)
    
    //neonlife
    static let neonlife1 = #colorLiteral(red: 0, green: 0.8901960784, blue: 0.6823529412, alpha: 1)
    static let neonlife2 = #colorLiteral(red: 0.07843137255, green: 0.7960784314, blue: 0.6274509804, alpha: 1)
    static let neonlife3 = #colorLiteral(red: 0.5333333333, green: 0.8078431373, blue: 0.2901960784, alpha: 1)
    static let neonlife4 = #colorLiteral(red: 0.6078431373, green: 0.8823529412, blue: 0.3647058824, alpha: 1)
    
    //bluelagoon
    static let bluelagoon1 = #colorLiteral(red: 0.2, green: 0.03137254902, blue: 0.4039215686, alpha: 1)
    static let bluelagoon2 = #colorLiteral(red: 0.2666666667, green: 0.1529411765, blue: 0.4039215686, alpha: 1)
    static let bluelagoon3 = #colorLiteral(red: 0.1411764706, green: 0.5725490196, blue: 0.5764705882, alpha: 1)
    static let bluelagoon4 = #colorLiteral(red: 0.1882352941, green: 0.8117647059, blue: 0.8156862745, alpha: 1)
    
    //celestial
    static let celestrial1 = #colorLiteral(red: 0.007843137255, green: 0.3137254902, blue: 0.7725490196, alpha: 1)
    static let celestrial2 = #colorLiteral(red: 0.168627451, green: 0.3450980392, blue: 0.6078431373, alpha: 1)
    static let celestrial3 = #colorLiteral(red: 0.7215686275, green: 0.2196078431, blue: 0.4823529412, alpha: 1)
    static let celestrial4 = #colorLiteral(red: 0.831372549, green: 0.2470588235, blue: 0.5529411765, alpha: 1)
    
    //kypool
    static let kypool1 = #colorLiteral(red: 0.1411764706, green: 0.8235294118, blue: 0.5725490196, alpha: 1)
    static let kypool2 = #colorLiteral(red: 0.1215686275, green: 0.7725490196, blue: 0.5333333333, alpha: 1)
    static let kypool3 = #colorLiteral(red: 0.7607843137, green: 0.2941176471, blue: 0.7137254902, alpha: 1)
    static let kypool4 = #colorLiteral(red: 0.8352941176, green: 0.3450980392, blue: 0.7843137255, alpha: 1)

    //solidstone
    static let solidstone1 = #colorLiteral(red: 0.3176470588, green: 0.4980392157, blue: 0.6431372549, alpha: 1)
    static let solidstone2 = #colorLiteral(red: 0.2745098039, green: 0.4235294118, blue: 0.5450980392, alpha: 1)
    static let solidstone3 = #colorLiteral(red: 0.1764705882, green: 0.2352941176, blue: 0.2784313725, alpha: 1)
    static let solidstone4 = #colorLiteral(red: 0.1411764706, green: 0.2235294118, blue: 0.2862745098, alpha: 1)
    
    //gentlecare
    static let gentlecare1 = #colorLiteral(red: 1, green: 0.6862745098, blue: 0.7411764706, alpha: 1)
    static let gentlecare2 = #colorLiteral(red: 0.9019607843, green: 0.6117647059, blue: 0.662745098, alpha: 1)
    static let gentlecare3 = #colorLiteral(red: 0.9137254902, green: 0.6509803922, blue: 0.4980392157, alpha: 1)
    static let gentlecare4 = #colorLiteral(red: 1, green: 0.7647058824, blue: 0.6274509804, alpha: 1)
    
}
