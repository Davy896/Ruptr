//
//  Mood.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 13/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//
import UIKit

public enum Mood {
    case Sports
    case Music
    case Outdoor
    case Games
    case Food
    case Shopping
    
    var image: UIImage? {
        get {
            switch self {
            case Mood.Sports:
                return UIImage(named: "roguemonkeyblog")
            case Mood.Music:
                return UIImage(named: "roguemonkeyblog")
            case Mood.Outdoor:
                return UIImage(named: "roguemonkeyblog")
            case Mood.Games:
                return UIImage(named: "roguemonkeyblog")
            case Mood.Food:
                return UIImage(named: "roguemonkeyblog")
            case Mood.Shopping:
                return UIImage(named: "roguemonkeyblog")
            }
        }
    }
}
