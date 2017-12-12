//
//  ConnectivityViewController.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 12/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit
import ConnectivityServices
import MultipeerConnectivity

class ConnectivityViewController: UIViewController {

    private let profile: UserProfile
    private let profileService: ProfileService
    private let broadcastService: BroadcastService
    private let chatService: ChatService
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.profile = UserProfile(id: String.randomAlphaNumericString(length: 20), userName: "Lucas", avatar: "avatar0", isVisible: true)
        self.profileService = ProfileService(profile: self.profile)
        self.broadcastService = BroadcastService(profile: self.profile)
        self.chatService = ChatService(profile: self.profile)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.profile = UserProfile(id: String.randomAlphaNumericString(length: 20), userName: "Lucas", avatar: "avatar0", isVisible: true)
        self.profileService = ProfileService(profile: self.profile)
        self.broadcastService = BroadcastService(profile: self.profile)
        self.chatService = ChatService(profile: self.profile)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileService.delegate = self
        self.broadcastService.delegate = self
        self.chatService.delegate = self
        self.updateVisibility()
    }
    
    func updateVisibility() {
        if (self.profile.isVisible) {
            self.profileService.serviceAdvertiser.startAdvertisingPeer()
            self.profileService.serviceBrowser.startBrowsingForPeers()
            
            self.broadcastService.serviceAdvertiser.startAdvertisingPeer()
            self.broadcastService.serviceBrowser.startBrowsingForPeers()
            
            self.chatService.serviceAdvertiser.startAdvertisingPeer()
            self.chatService.serviceBrowser.startBrowsingForPeers()
        } else {
            self.profileService.serviceAdvertiser.stopAdvertisingPeer()
            self.profileService.serviceBrowser.stopBrowsingForPeers()
            
            self.broadcastService.serviceAdvertiser.stopAdvertisingPeer()
            self.broadcastService.serviceBrowser.stopBrowsingForPeers()
            
            self.chatService.serviceAdvertiser.stopAdvertisingPeer()
            self.chatService.serviceBrowser.stopBrowsingForPeers()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ConnectivityViewController: ProfileServiceDelegate {
    func connectedDevicesChanged(manager: ProfileService, connectedDevices: [String]) {
        
    }
}

extension ConnectivityViewController: BroadcastServiceDelegate {
    func receiveBroadcastedMessage(manager: BroadcastService, message: String) {
    }
}

extension ConnectivityViewController: ChatServiceDelegate {
    func invitePeer(withId id: MCPeerID) {
    }
    
    func handleInvitation(from: String) {
    }
    
    func peerFound(withId id: MCPeerID) {
    }
    
    func peerLost(withId id: MCPeerID) {
    }
}

