//
//  DecodedUserDAtaKEys.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 19/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import Foundation

enum DecodedUserDataKeys {
    case username
    case avatarHair
    case avatarFace
    case avatarSkinTone
    case avatarSkinToneIndex
    case moodOne
    case moodTwo
    case moodThree
    case status
    case interactionType
    
    var enumToString: String {
        get {
            switch self {
            case DecodedUserDataKeys.username:
                return "username"
            case DecodedUserDataKeys.avatarHair:
                return "avatarHair"
            case DecodedUserDataKeys.avatarFace:
                return "avatarFace"
            case DecodedUserDataKeys.avatarSkinTone:
                return "avatarSkinTone"
            case DecodedUserDataKeys.avatarSkinToneIndex:
                return "avatarSkinToneIndex"
            case DecodedUserDataKeys.moodOne:
                return "moodOne"
            case DecodedUserDataKeys.moodTwo:
                return "moodTwo"
            case DecodedUserDataKeys.moodThree:
                return "moodThree"
            case DecodedUserDataKeys.status:
                return "status"
            case DecodedUserDataKeys.interactionType:
                return "interactionType"
            }
        }
    }
}
