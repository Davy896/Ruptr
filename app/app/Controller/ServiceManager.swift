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
    private var _profileService: ProfileService
    private var _broadcastService: BroadcastService
    private var _chatService: ChatService
    
    public var userProfile: UserProfile {
        get {
            return _userProfile
        }
        
        set(userProfile) { // Do this only once!!!!!!!
            self._userProfile = userProfile
            self._profileService = ProfileService(profile: userProfile)
            self._broadcastService = BroadcastService(profile: userProfile)
            self._chatService = ChatService(profile: userProfile)
        }
    }
    
    public var profileService: ProfileService {
        get {
            return _profileService
        }
    }
    
    public var broadcastService: BroadcastService {
        get {
            return _broadcastService
        }
    }
    
    public var chatService: ChatService {
        get {
            return _chatService
        }
    }
    
    private init(){
        self._userProfile = UserProfile(id: "", userName: "", avatar: "", moods: [], status: Status.ghost)
        self._profileService = ProfileService(profile: _userProfile)
        self._broadcastService = BroadcastService(profile: _userProfile)
        self._chatService = ChatService(profile: _userProfile)
    }
}
