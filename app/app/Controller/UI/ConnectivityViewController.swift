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

    override func viewDidLoad() {
        super.viewDidLoad()
        ServiceManager.instance.profileService.delegate = self
        ServiceManager.instance.broadcastService.delegate = self
        ServiceManager.instance.chatService.delegate = self
        self.updateVisibility()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ServiceManager.instance.profileService.delegate = nil
        ServiceManager.instance.broadcastService.delegate = nil
        ServiceManager.instance.chatService.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ServiceManager.instance.profileService.delegate = self
        ServiceManager.instance.broadcastService.delegate = self
        ServiceManager.instance.chatService.delegate = self
    }
    
    func updateVisibility() {
        if (ServiceManager.instance.userProfile.status != Status.ghost) {
            ServiceManager.instance.profileService.serviceAdvertiser.startAdvertisingPeer()
            ServiceManager.instance.profileService.serviceBrowser.startBrowsingForPeers()
            
            ServiceManager.instance.broadcastService.serviceAdvertiser.startAdvertisingPeer()
            ServiceManager.instance.broadcastService.serviceBrowser.startBrowsingForPeers()

            ServiceManager.instance.chatService.serviceAdvertiser.startAdvertisingPeer()
            ServiceManager.instance.chatService.serviceBrowser.startBrowsingForPeers()
        } else {
            ServiceManager.instance.profileService.serviceAdvertiser.stopAdvertisingPeer()
            ServiceManager.instance.profileService.serviceBrowser.stopBrowsingForPeers()

            ServiceManager.instance.broadcastService.serviceAdvertiser.stopAdvertisingPeer()
            ServiceManager.instance.broadcastService.serviceBrowser.stopBrowsingForPeers()

            ServiceManager.instance.chatService.serviceAdvertiser.stopAdvertisingPeer()
            ServiceManager.instance.chatService.serviceBrowser.stopBrowsingForPeers()
        }
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

