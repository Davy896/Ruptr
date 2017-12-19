//
//  ServiceManager.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 13/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import MultipeerConnectivity
import ConnectivityServices

class ServiceManager {
    
    internal static let instance: ServiceManager = ServiceManager()
    
    private var _userProfile: UserProfile
    private var _chatService: ChatService
    
    public var userProfile: UserProfile {
        get {
            return _userProfile
        }
        
        set(userProfile) { // Do this only once!!!!!!!
            self._userProfile = userProfile
            self._chatService = ChatService(profile: userProfile)
        }
    }
    
    public var chatService: ChatService {
        get {
            return _chatService
        }
    }
    
    private init(){
        self._userProfile = UserProfile(id: "CALL_SET_USERPROFILE", username: "CALL_SET_USERPROFILE", avatar: [AvatarParts.face: "CALL_SET_USERPROFILE"], moods: [], status: Status.ghost)
        self._chatService = ChatService(profile: _userProfile)
    }
}
