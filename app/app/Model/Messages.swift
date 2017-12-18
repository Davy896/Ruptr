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
    var avatar: String
    var isSend: Bool = false
    
    init(text: String, username: String, avatar: String, isSend: Bool) {
        self.text = text
//        self.date = date
        self.username = username
        self.avatar = avatar
        self.isSend = isSend
    }
}
