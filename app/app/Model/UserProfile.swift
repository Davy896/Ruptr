//
//  UserProfile.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 10/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

//whatever

import ConnectivityServices

public class UserProfile: ProfileRequirements {
    
    private let _id: String
    private var _username: String
    private var _avatar: [String]
    private var _moods: [Mood]
    private var _status: Status

    public var id: String {
        get {
            
            return self._id
        }
    }
    
    public var username: String {
        get {
            
            return self._username
        }
        
        set(username) {
            self._username = username
        }
    }
    
    public var avatar: [String] {
        get {
            
            return self._avatar
        }
        
        set(avatar) {
            
            self._avatar = avatar
        }
    }
    
    public var moods: [Mood] {
        get {
            
            return self._moods
        }
        
        set(moods) {
            
            self._moods = moods
        }
    }
    
    public var status: Status {
        get {
            
            return self._status
        }
        
        set(status) {
            
            self._status = status
        }
    }
    
    public var avatarHair: UIImage? {
        get {
            return UIImage(named: self.avatar[0])
        }
    }
    
    public var avatarFace: UIImage? {
        get {
            return UIImage(named: self.avatar[1])
        }
    }
    
    public var avatarSkin: UIColor {
        get {
            return Colours.getColour(named: self.avatar[2].components(separatedBy: "|")[0],
                                     index: Int(self.avatar[2].components(separatedBy: "|")[1]))
        }
    }
    
    public init(id: String, username: String, avatar: [String], moods: [Mood], status: Status) {
        self._id = id
        self._username = username
        self._avatar = avatar
        self._moods = moods
        self._status = status
    }
}
