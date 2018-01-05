//
//  CGPoint.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 30/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit

typealias CGPointCGPointOperations = CGPoint
typealias CGPointCGFloatOperations = CGPoint
typealias CGPointIntOperations = CGPoint
typealias CGPointFloatOperations = CGPoint
typealias CGPointDoubleOperations = CGPoint

extension CGPointCGPointOperations /* CGPoint */ {
    
    //Basic math
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func *(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x * right.x, y: left.y * right.y)
    }
    
    static func /(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x / right.x, y: left.y / right.y)
    }
    
    //Basic math assignment
    static func +=( left: inout CGPoint, right: CGPoint) {
        left = CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func -=( left: inout CGPoint, right: CGPoint) {
        left = CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func *=( left: inout CGPoint, right: CGPoint) {
        left = CGPoint(x: left.x * right.x, y: left.y * right.y)
    }
    
    static func /=( left: inout CGPoint, right: CGPoint) {
        left = CGPoint(x: left.x / right.x, y: left.y / right.y)
    }
}

extension CGPointCGFloatOperations /* CGFloat */ {
    
    //Basic math
    static func +(left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x + right, y: left.y + right)
    }
    
    static func -(left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x - right, y: left.y - right)
    }
    
    static func *(left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }
    
    static func /(left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x / right, y: left.y / right)
    }
    
    //Basic math mirrored
    static func +(left: CGFloat, right: CGPoint) -> CGPoint {
        return CGPoint(x: left + right.x, y: left + right.y)
    }
    
    static func -(left: CGFloat, right: CGPoint) -> CGPoint {
        return CGPoint(x: left - right.x, y: left - right.y)
    }
    
    static func *(left: CGFloat, right: CGPoint) -> CGPoint {
        return CGPoint(x: left * right.x, y: left * right.y)
    }
    
    static func /(left: CGFloat, right: CGPoint) -> CGPoint {
        return CGPoint(x: left / right.x, y: left / right.y)
    }
    
    //Basic math assignment
    static func +=(left: inout CGPoint, right: CGFloat) {
        left = CGPoint(x: left.x + right, y: left.y + right)
    }
    
    static func -=(left: inout CGPoint, right: CGFloat) {
        left = CGPoint(x: left.x - right, y: left.y - right)
    }
    
    static func *=(left: inout CGPoint, right: CGFloat) {
        left = CGPoint(x: left.x * right, y: left.y * right)
    }
    
    static func /=(left: inout CGPoint, right: CGFloat) {
        left = CGPoint(x: left.x / right, y: left.y / right)
    }
}

extension CGPointIntOperations /* Int */ {
    
    //Basic math
    static func +(left: CGPoint, right: Int) -> CGPoint {
        return CGPoint(x: left.x + CGFloat(right), y: left.y + CGFloat(right))
    }
    
    static func -(left: CGPoint, right: Int) -> CGPoint {
        return CGPoint(x: left.x - CGFloat(right), y: left.y - CGFloat(right))
    }
    
    static func *(left: CGPoint, right: Int) -> CGPoint {
        return CGPoint(x: left.x * CGFloat(right), y: left.y * CGFloat(right))
    }
    
    static func /(left: CGPoint, right: Int) -> CGPoint {
        return CGPoint(x: left.x / CGFloat(right), y: left.y / CGFloat(right))
    }
    
    //Basic math mirrored
    static func +(left: Int, right: CGPoint) -> CGPoint {
        return CGPoint(x: CGFloat(left) + right.x, y: CGFloat(left) + right.y)
    }
    
    static func -(left: Int, right: CGPoint) -> CGPoint {
        return CGPoint(x: CGFloat(left) - right.x, y: CGFloat(left) - right.y)
    }
    
    static func *(left: Int, right: CGPoint) -> CGPoint {
        return CGPoint(x: CGFloat(left) * right.x, y: CGFloat(left) * right.y)
    }
    
    static func /(left: Int, right: CGPoint) -> CGPoint {
        return CGPoint(x: CGFloat(left) / right.x, y: CGFloat(left) / right.y)
    }
    
    //Basic math assignment
    static func +=(left: inout CGPoint, right: Int) {
        left = CGPoint(x: left.x + CGFloat(right), y: left.y + CGFloat(right))
    }
    
    static func -=(left: inout CGPoint, right: Int) {
        left = CGPoint(x: left.x - CGFloat(right), y: left.y - CGFloat(right))
    }
    
    static func *=(left: inout CGPoint, right: Int) {
        left = CGPoint(x: left.x * CGFloat(right), y: left.y * CGFloat(right))
    }
    
    static func /=(left: inout CGPoint, right: Int) {
        left = CGPoint(x: left.x / CGFloat(right), y: left.y / CGFloat(right))
    }
}

extension CGPointFloatOperations /* Float */ {
    
    //Basic math
    static func +(left: CGPoint, right: Float) -> CGPoint {
        return CGPoint(x: left.x + CGFloat(right), y: left.y + CGFloat(right))
    }
    
    static func -(left: CGPoint, right: Float) -> CGPoint {
        return CGPoint(x: left.x - CGFloat(right), y: left.y - CGFloat(right))
    }
    
    static func *(left: CGPoint, right: Float) -> CGPoint {
        return CGPoint(x: left.x * CGFloat(right), y: left.y * CGFloat(right))
    }
    
    static func /(left: CGPoint, right: Float) -> CGPoint {
        return CGPoint(x: left.x / CGFloat(right), y: left.y / CGFloat(right))
    }
    
    //Basic math mirrored
    static func +(left: Float, right: CGPoint) -> CGPoint {
        return CGPoint(x: CGFloat(left) + right.x, y: CGFloat(left) + right.y)
    }
    
    static func -(left: Float, right: CGPoint) -> CGPoint {
        return CGPoint(x: CGFloat(left) - right.x, y: CGFloat(left) - right.y)
    }
    
    static func *(left: Float, right: CGPoint) -> CGPoint {
        return CGPoint(x: CGFloat(left) * right.x, y: CGFloat(left) * right.y)
    }
    
    static func /(left: Float, right: CGPoint) -> CGPoint {
        return CGPoint(x: CGFloat(left) / right.x, y: CGFloat(left) / right.y)
    }
    
    //Basic math assignment
    static func +=(left: inout CGPoint, right: Float) {
        left = CGPoint(x: left.x + CGFloat(right), y: left.y + CGFloat(right))
    }
    
    static func -=(left: inout CGPoint, right: Float) {
        left = CGPoint(x: left.x - CGFloat(right), y: left.y - CGFloat(right))
    }
    
    static func *=(left: inout CGPoint, right: Float) {
        left = CGPoint(x: left.x * CGFloat(right), y: left.y * CGFloat(right))
    }
    
    static func /=(left: inout CGPoint, right: Float) {
        left = CGPoint(x: left.x / CGFloat(right), y: left.y / CGFloat(right))
    }
}

extension CGPointDoubleOperations /* Double */ {
    
    //Basic math
    static func +(left: CGPoint, right: Double) -> CGPoint {
        return CGPoint(x: left.x + CGFloat(right), y: left.y + CGFloat(right))
    }
    
    static func -(left: CGPoint, right: Double) -> CGPoint {
        return CGPoint(x: left.x - CGFloat(right), y: left.y - CGFloat(right))
    }
    
    static func *(left: CGPoint, right: Double) -> CGPoint {
        return CGPoint(x: left.x * CGFloat(right), y: left.y * CGFloat(right))
    }
    
    static func /(left: CGPoint, right: Double) -> CGPoint {
        return CGPoint(x: left.x / CGFloat(right), y: left.y / CGFloat(right))
    }
    
    //Basic math mirrored
    static func +(left: Double, right: CGPoint) -> CGPoint {
        return CGPoint(x: CGFloat(left) + right.x, y: CGFloat(left) + right.y)
    }
    
    static func -(left: Double, right: CGPoint) -> CGPoint {
        return CGPoint(x: CGFloat(left) - right.x, y: CGFloat(left) - right.y)
    }
    
    static func *(left: Double, right: CGPoint) -> CGPoint {
        return CGPoint(x: CGFloat(left) * right.x, y: CGFloat(left) * right.y)
    }
    
    static func /(left: Double, right: CGPoint) -> CGPoint {
        return CGPoint(x: CGFloat(left) / right.x, y: CGFloat(left) / right.y)
    }
    
    //Basic math assignment
    static func +=(left: inout CGPoint, right: Double) {
        left = CGPoint(x: left.x + CGFloat(right), y: left.y + CGFloat(right))
    }
    
    static func -=(left: inout CGPoint, right: Double) {
        left = CGPoint(x: left.x - CGFloat(right), y: left.y - CGFloat(right))
    }
    
    static func *=(left: inout CGPoint, right: Double) {
        left = CGPoint(x: left.x * CGFloat(right), y: left.y * CGFloat(right))
    }
    
    static func /=(left: inout CGPoint, right: Double) {
        left = CGPoint(x: left.x / CGFloat(right), y: left.y / CGFloat(right))
    }
}
