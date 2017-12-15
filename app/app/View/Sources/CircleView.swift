//
//  CircleView.swift
//  App
//
//  Created by Luana Caruso on 12/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    private var radius: Double = 0
    private var numberOfCircles: Int = 0
    
    func drawCircles(numberOf numberOfCircles: Int ,onRectangle rect: CGRect, withRadius radius: Double) {
        self.radius = radius
        self.numberOfCircles = numberOfCircles
        draw(rect)
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        for i in 1 ... numberOfCircles {
            path.move(to: CGPoint(x: center.x + CGFloat(radius * Double(i)), y: center.y))
            for j in stride(from: 0, to: 361.0, by: 1) {
                let radians = j * Double.pi / 180
                let x = Double(center.x) + radius * Double(i) * cos(radians)
                let y = Double(center.y) + radius * Double(i) * sin(radians)
                path.addLine(to: CGPoint(x: x , y: y))
            }
        }
        
        UIColor.white.setStroke()
        path.lineWidth = 1
        path.stroke()
        self.backgroundColor = UIColor.clear
    }
}


