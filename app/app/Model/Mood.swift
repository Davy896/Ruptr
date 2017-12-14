//
//  Mood.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 13/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//
import UIKit

public enum Mood {
    case sports
    case music
    case outdoor
    case games
    case food
    case shopping
    
    var image: UIImage? {
        get {
            switch self {
            case Mood.sports:
                return UIImage(named: "roguemonkeyblog")
            case Mood.music:
                return UIImage(named: "roguemonkeyblog")
            case Mood.outdoor:
                return UIImage(named: "roguemonkeyblog")
            case Mood.games:
                return UIImage(named: "roguemonkeyblog")
            case Mood.food:
                return UIImage(named: "roguemonkeyblog")
            case Mood.shopping:
                return UIImage(named: "roguemonkeyblog")
            }
        }
    }
    
    var enumToString: String {
        get {
            switch self {
            case Mood.sports:
                return "Sport"
            case Mood.music:
                return "Music"
            case Mood.outdoor:
                return "Outdoor"
            case Mood.games:
                return "Game"
            case Mood.food:
                return "Food"
            case Mood.shopping:
                return "Shopping"
            }
        }
    }
    
    static func stringToEnum(from string: String) -> Mood {
        switch string {
        case "Sport":
            return Mood.sports
        case "Music":
            return Mood.music
        case "Outdoor":
            return Mood.outdoor
        case "Game":
            return Mood.games
        case "Food":
            return Mood.food
        case "Shopping":
            return Mood.shopping
        default:
            return Mood.sports
        }
    }
}
