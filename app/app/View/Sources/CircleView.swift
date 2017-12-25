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
    var points: [CGPoint] = []
    var endCircleIndex: [Int] = []
    var isPanned = false
    
    func drawCircles(numberOf numberOfCircles: Int, onRectangle rect: CGRect, withRadius radius: Double) {
        self.radius = radius
        self.numberOfCircles = numberOfCircles
        self.draw(rect)
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.sublayers = nil
        let path = UIBezierPath()
        let center = CGPoint(x: (rect.width  / 2) - rect.minX, y: (rect.height / 2) - rect.minY)
        for i in 0 ... self.numberOfCircles {
            path.move(to: CGPoint(x: center.x + CGFloat(self.radius * Double(i)), y: center.y))
            for j in 0 ... 362 {
                let angle = Double (j) * Double.pi / 180
                let x = CGFloat(Double(center.x) + self.radius * Double(i) * cos(angle))
                let y = CGFloat(Double(center.y) + self.radius * Double(i) * sin(angle))
                let point = CGPoint(x: x, y: y)
                self.points.append(point)
                path.addLine(to: point)
            }
            endCircleIndex.append((i + 1) * 361)
        }
        
        path.close()
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 1
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.path = path.cgPath
        if !(self.isPanned) {
            shapeLayer.add(animation, forKey: "StrokeAnimations")
        }
        
        self.layer.addSublayer(shapeLayer)
        self.backgroundColor = UIColor.clear
    }
}


