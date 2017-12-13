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

class RoundView: UIView {
    
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

class RoundImgView: UIImageView {
    
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

class StatusTextView: UITextView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
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

class StatusButton: UIButton {
        
    @IBInspectable var topRightCorner: Bool = false {
        didSet {
            drawCorners()
        }
    }
    
    @IBInspectable var topLeftCorner: Bool = false {
        didSet {
            drawCorners()
        }
    }
    
    @IBInspectable var bottomRightCorner: Bool = false {
        didSet {
            drawCorners()
        }
    }
    
    @IBInspectable var bottomLeftCorner: Bool = false {
        didSet {
            drawCorners()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
           drawCorners()
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
    
    private func drawCorners(){
        var corners: UIRectCorner = []
        if (topRightCorner) {
            corners.insert(.topRight)
        }
        
        if (topLeftCorner) {
            corners.insert(.topLeft)
        }
        
        if (bottomRightCorner) {
            corners.insert(.bottomRight)
        }
        
        if (bottomLeftCorner) {
            corners.insert(.bottomLeft)
        }
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

