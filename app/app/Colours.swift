//
//  Colours.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 15/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit

class Colours {
    static let background = #colorLiteral(red: 0.06666666667, green: 0.1294117647, blue: 0.2431372549, alpha: 1)
    static let backgroundSecondary = #colorLiteral(red: 0.2039215686, green: 0.2823529412, blue: 0.4352941176, alpha: 1)
    static let errorBackground = UIColor.white.withAlphaComponent(0.7)
    static let skinTones = [ #colorLiteral(red: 0.8078431373, green: 0.7411764706, blue: 0.6274509804, alpha: 1), #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1), #colorLiteral(red: 0.5725490196, green: 0.4745098039, blue: 0.3490196078, alpha: 1), #colorLiteral(red: 0.2509803922, green: 0.1647058824, blue: 0.1098039216, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)]
    static let saveProfileButtonInvalidBackground = #colorLiteral(red: 0.7490196078, green: 0.7568627451, blue: 0.737254902, alpha: 1)
    static let alerts = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    static func getColour(named name: String, index: Int?) -> UIColor{
        switch name {
        case "background":
        return background
        case "errorBackground":
            return errorBackground
        case "skinTones":
            guard let i = index else {
                return UIColor.clear
            }
            
            return skinTones[i]
        default:
            return UIColor.clear
        }
    }
}

extension UIColor {
    
    func toHexUInt() -> UInt {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (UInt)(r*255)<<16 | (UInt)(g*255)<<8 | (UInt)(b*255)<<0
    }
}
