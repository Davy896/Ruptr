//
//  Mood.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 13/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//
import UIKit

public enum Mood: String {
    case sports = "Sports"
    case music = "Music"
    case outdoor = "Outdoor"
    case games = "Games"
    case food = "Food"
    case shopping = "Shopping"
    
    public var image: UIImage? {
        get {
            switch self {
            case Mood.sports:
                return UIImage(named: "sports")
            case Mood.music:
                return UIImage(named: "music")
            case Mood.outdoor:
                return UIImage(named: "outdoors")
            case Mood.games:
                return UIImage(named: "games")
            case Mood.food:
                return UIImage(named: "food")
            case Mood.shopping:
                return UIImage(named: "shopping")
            }
        }
    }
    
    public var squaredImage: UIImage? {
        get {
            switch self {
            case Mood.sports:
                return UIImage(named: "sports_square")
            case Mood.music:
                return UIImage(named: "music_square")
            case Mood.outdoor:
                return UIImage(named: "outdoors_square")
            case Mood.games:
                return UIImage(named: "games_square")
            case Mood.food:
                return UIImage(named: "food_square")
            case Mood.shopping:
                return UIImage(named: "shopping_square")
            }
        }
    }
}
