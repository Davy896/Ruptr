//
//  RoundImgViewSettings.swift
//  App
//
//  Created by Luana Caruso on 12/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable

// class to add UIImageView settings (corner radius)
class RoundImgView: UIImageView {
    
    var openSts:Bool = false
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var bgColor: UIColor = UIColor.clear {
        didSet{
            self.layer.backgroundColor = bgColor.cgColor
        }
    }
    
    @IBInspectable var maskToBounds: Bool = false {
        didSet{
            self.layer.masksToBounds = maskToBounds
        }
    }
}
