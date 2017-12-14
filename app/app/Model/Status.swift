//
//  Status.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 13/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

public enum Status {
    
    case ghost
    case chatful
    case open
    case playful
    
    var enumToString: String {
        get {
            switch self {
            case Status.ghost:
                return "Ghost"
            case Status.chatful:
                return "Chatful"
            case Status.open:
                return "Open"
            case Status.playful:
                return "Playful"
            }
        }
    }
    
    static func stringToEnum(from string: String) -> Status {
        switch string {
        case "Ghost":
            return Status.ghost
        case "Chatful":
            return Status.chatful
        case "Open":
            return Status.open
        case "Playful":
            return Status.playful
        default:
            return Status.playful
        }
    }
}

