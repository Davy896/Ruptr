//
//  SpeechBubble.swift
//  App
//
//  Created by Luana Caruso on 12/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit


class SpeechBubble: UIView {
    
    var color:UIColor = UIColor.gray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required convenience init(withColor frame: CGRect, color:UIColor? = none) {
        self.init(frame: frame)
        
        if let color = color {
            self.color = color
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let rounding:CGFloat = rect.width * 0.02
        
        //Draw the main frame
        let bubbleFrame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height * 2 / 3)
        let bubblePath = UIBezierPath(roundedRect: bubbleFrame, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: rounding, height: rounding))
        
        //Color the bubbleFrame
        color.setStroke()
        color.setFill()
        bubblePath.stroke()
        bubblePath.fill()
        
        //Add the point
        let context = UIGraphicsGetCurrentContext()
        
        //Start the line
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, CGRectGetMinX(bubbleFrame) + bubbleFrame.width * 1/3, CGRectGetMaxY(bubbleFrame))
        
        //Draw a rounded point
        CGContextAddArcToPoint(context, CGRectGetMaxX(rect) * 1/3, CGRectGetMaxY(rect), CGRectGetMaxX(bubbleFrame), CGRectGetMinY(bubbleFrame), rounding)
        
        //Close the line
        CGContextAddLineToPoint(context, CGRectGetMinX(bubbleFrame) + bubbleFrame.width * 2/3, CGRectGetMaxY(bubbleFrame))
        CGContextClosePath(context)
        
        //fill the color
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillPath(context);
    }
}



