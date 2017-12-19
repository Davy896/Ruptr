//
//  Messages.swift
//  App
//
//  Created by Davide Contaldo on 15/12/17.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit


class Messages: NSObject {
    var text: String
//    var date: NSDate
    var username: String
    var avatarHair: String
    var avatarEyes: String
    var avatarSkinColor: String
    var isSend: Bool = false
    
    
    init(text: String, username: String, avatarHair: String,avatarEyes: String, avatarSkinColor: String, isSend: Bool) {
        self.text = text
//        self.date = date
        self.username = username
        self.avatarHair = avatarHair
        self.avatarEyes = avatarEyes
        self.avatarSkinColor = avatarSkinColor
        self.isSend = isSend
    }
}
