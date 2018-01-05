//
//  OperatorOverloadExtention.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 30/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit

typealias CGSizeCGSizeOperations = CGSize
typealias CGSizeCGFloatOperations = CGSize
typealias CGSizeIntOperations = CGSize
typealias CGSizeFloatOperations = CGSize
typealias CGSizeDoubleOperations = CGSize

extension CGSizeCGSizeOperations /* CGSize */ {
    
    //Basic math
    static func +(left: CGSize, right: CGSize) -> CGSize{
        return CGSize(width: left.width + right.width, height: left.height + right.height)
    }
    
    static func -(left: CGSize, right: CGSize) -> CGSize{
        return CGSize(width: left.width - right.width, height: left.height - right.height)
    }
    
    static func *(left: CGSize, right: CGSize) -> CGSize{
        return CGSize(width: left.width * right.width, height: left.height * right.height)
    }
    
    static func /(left: CGSize, right: CGSize) -> CGSize{
        return CGSize(width: left.width / right.width, height: left.height / right.height)
    }
    
    //Basic math assignment
    static func +=(left: inout CGSize, right: CGSize) {
        left = CGSize(width: left.width + right.width, height: left.height + right.height)
    }
    
    static func -=(left: inout CGSize, right: CGSize) {
        left = CGSize(width: left.width - right.width, height: left.height - right.height)
    }
    
    static func *=(left: inout CGSize, right: CGSize) {
        left = CGSize(width: left.width * right.width, height: left.height * right.height)
    }
    
    static func /=(left: inout CGSize, right: CGSize) {
        left = CGSize(width: left.width / right.width, height: left.height / right.height)
    }
}

extension CGSizeCGFloatOperations /* CGFloat */ {
    
    //Basic math
    static func +(left: CGSize, right: CGFloat) -> CGSize{
        return CGSize(width: left.width + right, height: left.height + right)
    }
    
    static func -(left: CGSize, right: CGFloat) -> CGSize{
        return CGSize(width: left.width - right, height: left.height - right)
    }
    
    static func *(left: CGSize, right: CGFloat) -> CGSize{
        return CGSize(width: left.width * right, height: left.height * right)
    }
    
    static func /(left: CGSize, right: CGFloat) -> CGSize{
        return CGSize(width: left.width / right, height: left.height / right)
    }
    
    //Basic math mirrored
    static func +(left: CGFloat, right: CGSize) -> CGSize{
        return CGSize(width: left + right.width, height: left + right.height)
    }
    
    static func -(left: CGFloat, right: CGSize) -> CGSize{
        return CGSize(width: left - right.width, height: left - right.height)
    }
    
    static func *(left: CGFloat, right: CGSize) -> CGSize{
        return CGSize(width: left * right.width, height: left * right.height)
    }
    
    static func /(left: CGFloat, right: CGSize) -> CGSize{
        return CGSize(width: left / right.width, height: left / right.height)
    }
    
    //Basic math assignment
    static func +=(left: inout CGSize, right: CGFloat) {
        left = CGSize(width: left.width + right, height: left.height + right)
    }
    
    static func -=(left: inout CGSize, right: CGFloat) {
        left = CGSize(width: left.width - right, height: left.height - right)
    }
    
    static func *=(left: inout CGSize, right: CGFloat) {
        left = CGSize(width: left.width * right, height: left.height * right)
    }
    
    static func /=(left: inout CGSize, right: CGFloat) {
        left = CGSize(width: left.width / right, height: left.height / right)
    }
}

extension CGSizeIntOperations /* Int */ {
    
    //Basic math
    static func +(left: CGSize, right: Int) -> CGSize{
        return CGSize(width: left.width + CGFloat(right), height: left.height + CGFloat(right))
    }
    
    static func -(left: CGSize, right: Int) -> CGSize{
        return CGSize(width: left.width - CGFloat(right), height: left.height - CGFloat(right))
    }
    
    static func *(left: CGSize, right: Int) -> CGSize{
        return CGSize(width: left.width * CGFloat(right), height: left.height * CGFloat(right))
    }
    
    static func /(left: CGSize, right: Int) -> CGSize{
        return CGSize(width: left.width / CGFloat(right), height: left.height / CGFloat(right))
    }
    
    //Basic math mirrored
    static func +(left: Int, right: CGSize) -> CGSize{
        return CGSize(width: CGFloat(left) + right.width, height: CGFloat(left) + right.height)
    }
    
    static func -(left: Int, right: CGSize) -> CGSize{
        return CGSize(width: CGFloat(left) - right.width, height: CGFloat(left) - right.height)
    }
    
    static func *(left: Int, right: CGSize) -> CGSize{
        return CGSize(width: CGFloat(left) * right.width, height: CGFloat(left) * right.height)
    }
    
    static func /(left: Int, right: CGSize) -> CGSize{
        return CGSize(width: CGFloat(left) / right.width, height: CGFloat(left) / right.height)
    }
    
    //Basic math assignment
    static func +=(left: inout CGSize, right: Int) {
        left = CGSize(width: left.width + CGFloat(right), height: left.height + CGFloat(right))
    }
    
    static func -=(left: inout CGSize, right: Int) {
        left = CGSize(width: left.width - CGFloat(right), height: left.height - CGFloat(right))
    }
    
    static func *=(left: inout CGSize, right: Int) {
        left = CGSize(width: left.width * CGFloat(right), height: left.height * CGFloat(right))
    }
    
    static func /=(left: inout CGSize, right: Int) {
        left = CGSize(width: left.width / CGFloat(right), height: left.height / CGFloat(right))
    }
}

extension CGSizeFloatOperations /* Float */ {
    
    //Basic math
    static func +(left: CGSize, right: Float) -> CGSize{
        return CGSize(width: left.width + CGFloat(right), height: left.height + CGFloat(right))
    }
    
    static func -(left: CGSize, right: Float) -> CGSize{
        return CGSize(width: left.width - CGFloat(right), height: left.height - CGFloat(right))
    }
    
    static func *(left: CGSize, right: Float) -> CGSize{
        return CGSize(width: left.width * CGFloat(right), height: left.height * CGFloat(right))
    }
    
    static func /(left: CGSize, right: Float) -> CGSize{
        return CGSize(width: left.width / CGFloat(right), height: left.height / CGFloat(right))
    }
    
    //Basic math mirrored
    static func +(left: Float, right: CGSize) -> CGSize{
        return CGSize(width: CGFloat(left) + right.width, height: CGFloat(left) + right.height)
    }
    
    static func -(left: Float, right: CGSize) -> CGSize{
        return CGSize(width: CGFloat(left) - right.width, height: CGFloat(left) - right.height)
    }
    
    static func *(left: Float, right: CGSize) -> CGSize{
        return CGSize(width: CGFloat(left) * right.width, height: CGFloat(left) * right.height)
    }
    
    static func /(left: Float, right: CGSize) -> CGSize{
        return CGSize(width: CGFloat(left) / right.width, height: CGFloat(left) / right.height)
    }
    
    //Basic math assignment
    static func +=(left: inout CGSize, right: Float) {
        left = CGSize(width: left.width + CGFloat(right), height: left.height + CGFloat(right))
    }
    
    static func -=(left: inout CGSize, right: Float) {
        left = CGSize(width: left.width - CGFloat(right), height: left.height - CGFloat(right))
    }
    
    static func *=(left: inout CGSize, right: Float) {
        left = CGSize(width: left.width * CGFloat(right), height: left.height * CGFloat(right))
    }
    
    static func /=(left: inout CGSize, right: Float) {
        left = CGSize(width: left.width / CGFloat(right), height: left.height / CGFloat(right))
    }
}

extension CGSizeDoubleOperations /* Double */ {
    
    //Basic math
    static func +(left: CGSize, right: Double) -> CGSize{
        return CGSize(width: left.width + CGFloat(right), height: left.height + CGFloat(right))
    }
    
    static func -(left: CGSize, right: Double) -> CGSize{
        return CGSize(width: left.width - CGFloat(right), height: left.height - CGFloat(right))
    }
    
    static func *(left: CGSize, right: Double) -> CGSize{
        return CGSize(width: left.width * CGFloat(right), height: left.height * CGFloat(right))
    }
    
    static func /(left: CGSize, right: Double) -> CGSize{
        return CGSize(width: left.width / CGFloat(right), height: left.height / CGFloat(right))
    }
    
    //Basic math mirrored
    static func +(left: Double, right: CGSize) -> CGSize{
        return CGSize(width: CGFloat(left) + right.width, height: CGFloat(left) + right.height)
    }
    
    static func -(left: Double, right: CGSize) -> CGSize{
        return CGSize(width: CGFloat(left) - right.width, height: CGFloat(left) - right.height)
    }
    
    static func *(left: Double, right: CGSize) -> CGSize{
        return CGSize(width: CGFloat(left) * right.width, height: CGFloat(left) * right.height)
    }
    
    static func /(left: Double, right: CGSize) -> CGSize{
        return CGSize(width: CGFloat(left) / right.width, height: CGFloat(left) / right.height)
    }
    
    //Basic math assignment
    static func +=(left: inout CGSize, right: Double) {
        left = CGSize(width: left.width + CGFloat(right), height: left.height + CGFloat(right))
    }
    
    static func -=(left: inout CGSize, right: Double) {
        left = CGSize(width: left.width - CGFloat(right), height: left.height - CGFloat(right))
    }
    
    static func *=(left: inout CGSize, right: Double) {
        left = CGSize(width: left.width * CGFloat(right), height: left.height * CGFloat(right))
    }
    
    static func /=(left: inout CGSize, right: Double) {
        left = CGSize(width: left.width / CGFloat(right), height: left.height / CGFloat(right))
    }
}
