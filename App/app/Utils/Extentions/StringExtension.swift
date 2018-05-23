//
//  Sgr.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 13/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import Foundation

public extension String {
    public var isAlphanumeric: Bool {
        return !self.isEmpty && self.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    public static func randomAlphaNumericString(length: Int) -> String {
        
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_"
        var randomString = ""
        
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(UInt32(allowedChars.count)))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
}
