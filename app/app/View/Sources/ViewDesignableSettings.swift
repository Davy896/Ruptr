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
    
    private var _leftBorder = CALayer()
    private var _rightBorder = CALayer()
    private var _topBorder = CALayer()
    private var _bottomBorder = CALayer()
    
    @IBInspectable var leftBorder: Bool = false {
        didSet {
            if (self.leftBorder) {
                self.layer.addSublayer(self._leftBorder)
            } else {
                self._leftBorder.removeFromSuperlayer()
            }
        }
    }
    
    @IBInspectable var rightBorder: Bool = false {
        didSet {
            if (self.rightBorder) {
                self.layer.addSublayer(self._rightBorder)
            } else {
                self._rightBorder.removeFromSuperlayer()
            }
        }
    }
    
    @IBInspectable var topBorder: Bool = false {
        didSet {
            print(self.borderWidth)
            
            if (self.topBorder) {
                self.layer.addSublayer(self._topBorder)
                for layer in self.layer.sublayers ?? [] {
                    print(layer.frame)
                }
            } else {
                self._topBorder.removeFromSuperlayer()
            }
         
        }
    }
    @IBInspectable var bottomBorder: Bool = false {
        didSet {
            if (self.bottomBorder) {
                self.layer.addSublayer(self._bottomBorder)
            } else {
                self._bottomBorder.removeFromSuperlayer()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self._leftBorder.frame = CGRect(x: 0, y: 0, width: self.borderWidth, height: self.frame.size.height)
            self._rightBorder.frame =  CGRect(x: self.frame.size.width, y: 0, width: self.borderWidth, height: self.frame.size.height)
            self._topBorder.frame =   CGRect(x: 0, y: 300, width: self.frame.size.width, height: self.borderWidth)
            self._bottomBorder.frame =  CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: self.borderWidth)
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable var bgColor: UIColor = UIColor.clear {
        didSet {
            self.layer.backgroundColor = self.bgColor.cgColor
        }
    }
    
    @IBInspectable var maskToBounds: Bool = false {
        didSet {
            self.layer.masksToBounds = self.maskToBounds
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

