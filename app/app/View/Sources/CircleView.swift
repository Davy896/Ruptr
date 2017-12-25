//
//  CircleView.swift
//  App
//
//  Created by Luana Caruso on 12/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    var radius: Double = 0 {
        didSet {
            draw(self.frame)
            self.setNeedsDisplay()
        }
    }
    var numberOfCircles: Int = 0 {
        didSet {
            draw(self.frame)
            self.setNeedsDisplay()
        }
    }
    var points: [CGPoint] = []
    var endCircleIndex: [Int] = []
    var delegate: CircleViewDelegate?
    
    override func draw(_ rect: CGRect) {
        self.layer.sublayers = nil
        self.points.removeAll()
        self.endCircleIndex.removeAll()
        if self.numberOfCircles > 0 {            
            let center = CGPoint(x: (rect.width  / 2) - rect.minX, y: (rect.height / 2) - rect.minY)
            var layers: [CAShapeLayer] = []
            for i in 1 ... self.numberOfCircles {
                let shapeLayer = CAShapeLayer()
                shapeLayer.fillColor = UIColor.clear.cgColor
                shapeLayer.strokeColor = UIColor.white.cgColor
                shapeLayer.lineWidth = 4
                let path = UIBezierPath()
                path.move(to: CGPoint(x: center.x + CGFloat(self.radius * Double(i)), y: center.y))
                for j in 0 ... 362 {
                    let angle = Double (j) * Double.pi / 180
                    let x = CGFloat(Double(center.x) + self.radius * Double(i) * cos(angle))
                    let y = CGFloat(Double(center.y) + self.radius * Double(i) * sin(angle))
                    let point = CGPoint(x: x, y: y)
                    self.points.append(point)
                    path.addLine(to: point)
                }
                
                self.endCircleIndex.append((i + 1) * 361)
                path.close()
                shapeLayer.path = path.cgPath
                
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.fromValue = 0
                animation.duration = 0.35
                animation.delegate = self
                shapeLayer.add(animation, forKey: "StrokeAnimations")
                
                layers.append(shapeLayer)
            }
            
            for layer in layers {
                self.layer.addSublayer(layer)
            }
        }
        
        self.backgroundColor = UIColor.clear
    }
}

extension CircleView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if (flag) {
            delegate?.handleDrawingCompletion()
        }
    }
}

