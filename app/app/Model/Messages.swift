//
//  Messages.swift
//  App
//
//  Created by Davide Contaldo on 15/12/17.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class Messages: NSObject {
    var text: String
    var username: String
    var avatarHair: String
    var avatarEyes: String
    var avatarSkinColor: String
    var id: String
    var isText: Bool
    
    
    init(text: String, username: String, avatarHair: String,avatarEyes: String, avatarSkinColor: String, id: String, isText: Bool) {
        self.text = text
        self.username = username
        self.avatarHair = avatarHair
        self.avatarEyes = avatarEyes
        self.avatarSkinColor = avatarSkinColor
        self.id = id
        self.isText = isText
    }
    
    func toString() -> String {
        return "\(self.text)|\(self.username)|\(self.avatarHair)|\(self.avatarEyes)|\(self.avatarSkinColor)|\(self.id)"
    }
    
    static func setMessage(from array: [String]) -> Messages {
        return Messages(text: array[1],
                        username: array[2],
                        avatarHair: array[3],
                        avatarEyes: array[4],
                        avatarSkinColor: "\(array[5])|\(array[6])",
                        id: array[7],
                        isText: array[0] == MPCMessageTypes.message)
    }
}
