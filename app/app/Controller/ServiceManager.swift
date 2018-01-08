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
    private var _isBusy: Bool
    private var _selectedPeer: (key: MCPeerID, name: String, hair: String, face: String, skinTone: String, skinToneIndex: String)?
    
    public var userProfile: UserProfile {
        get {
            return self._userProfile
        }
        
        set(userProfile) { // Do this only once!!!!!!!
            self._userProfile = userProfile
            self._chatService = ChatService(profile: userProfile)
        }
    }
    
    public var chatService: ChatService {
        get {
            return self._chatService
        }
    }
    
    public var isBusy: Bool {
        get {
            return self._isBusy
        }
        
        set(isBusy) {
            self._isBusy = isBusy
        }
    }
    
    public var selectedPeer: (key: MCPeerID,name: String, hair: String, face: String, skinTone: String, skinToneIndex: String)? {
        get {
            return self._selectedPeer
        }
        set(selectedPeer) {
            self._selectedPeer = selectedPeer
        }
    }
    
    private init(){
        self._userProfile = UserProfile(id: "CALL_SET_USERPROFILE", username: "CALL_SET_USERPROFILE", avatar: [AvatarParts.face: "CALL_SET_USERPROFILE"], moods: [], status: Status.ghost)
        self._chatService = ChatService(profile: _userProfile)
        self._isBusy = false
    }
}
