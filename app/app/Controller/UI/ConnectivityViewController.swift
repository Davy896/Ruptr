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

class ConnectivityViewController: UIViewController, ProfileServiceDelegate, BroadcastServiceDelegate , ChatServiceDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
//        ServiceManager.instance.profileService.delegate = self
//        ServiceManager.instance.broadcastService.delegate = self
        ServiceManager.instance.chatService.delegate = self
        self.setDiscoveryInfo(from: ServiceManager.instance.userProfile)
        self.updateVisibility()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        ServiceManager.instance.profileService.delegate = nil
//        ServiceManager.instance.broadcastService.delegate = nil
//        ServiceManager.instance.chatService.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        ServiceManager.instance.profileService.delegate = self
//        ServiceManager.instance.broadcastService.delegate = self
        ServiceManager.instance.chatService.delegate = self
    }
    
    func updateVisibility() {
        if (ServiceManager.instance.userProfile.status != Status.ghost) {
//            ServiceManager.instance.profileService.serviceAdvertiser.startAdvertisingPeer()
//            ServiceManager.instance.profileService.serviceBrowser.startBrowsingForPeers()
//            
//            ServiceManager.instance.broadcastService.serviceAdvertiser.startAdvertisingPeer()
//            ServiceManager.instance.broadcastService.serviceBrowser.startBrowsingForPeers()

            ServiceManager.instance.chatService.serviceAdvertiser.startAdvertisingPeer()
            ServiceManager.instance.chatService.serviceBrowser.startBrowsingForPeers()
        } else {
//            ServiceManager.instance.profileService.serviceAdvertiser.stopAdvertisingPeer()
//            ServiceManager.instance.profileService.serviceBrowser.stopBrowsingForPeers()
//
//            ServiceManager.instance.broadcastService.serviceAdvertiser.stopAdvertisingPeer()
//            ServiceManager.instance.broadcastService.serviceBrowser.stopBrowsingForPeers()

            ServiceManager.instance.chatService.serviceAdvertiser.stopAdvertisingPeer()
            ServiceManager.instance.chatService.serviceBrowser.stopBrowsingForPeers()
        }
    }
    
    func connectedDevicesChanged(manager: ProfileService, connectedDevices: [String]) {
    }
    
    func receiveBroadcastedMessage(manager: BroadcastService, message: String) {
    }
    
    func setDiscoveryInfo(from profile: ProfileRequirements) {
        let info = ["avatar": ServiceManager.instance.userProfile.avatar,
                    "username": ServiceManager.instance.userProfile.username,
                    "moodOne": ServiceManager.instance.userProfile.moods[0].enumToString,
                    "moodTwo": ServiceManager.instance.userProfile.moods[1].enumToString,
                    "moodThree": ServiceManager.instance.userProfile.moods[2].enumToString,
                    "status": ServiceManager.instance.userProfile.status.enumToString]
        ServiceManager.instance.chatService.discoveryInfo = info
    }
    
    func invitePeer(withId id: MCPeerID, profile: ProfileRequirements) {
    }
    
    func handleInvitation(from: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    }
    
    func handleMessage(from: MCPeerID, message: String) {
        switch message {
        case "chat":
            self.show(UIStoryboard(name: "Interactions", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController"), sender: self)
            break
        case "game":
            self.show(UIStoryboard(name: "Interactions", bundle: nil).instantiateViewController(withIdentifier: "GameViewController"), sender: self)
            break
        default:
            break
        }
    }
    
    func peerFound(withId id: MCPeerID) {
    }
    
    func peerLost(withId id: MCPeerID) {
    }
}
