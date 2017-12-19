//
//  Service.swift
//  ConnectivityServices
//
//  Created by Lucas Assis Rodrigues on 11/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import MultipeerConnectivity

public class Service: NSObject {
    
    internal let _serviceType: String
    internal let _peerId: MCPeerID
    internal var _serviceAdvertiser: MCNearbyServiceAdvertiser
    internal let _serviceBrowser: MCNearbyServiceBrowser
    internal var _profile: ProfileRequirements
    internal var _peers: [MCPeerID]
    internal var _peersDiscoveryInfos: [[String:String]]
    internal var _discoveryInfo: [String : String]
    internal var _invitationHandler: ((Bool, MCSession?)->Void)!
    internal var _session: MCSession
    
    public var serviceType: String {
        
        get {
            return self._serviceType
        }
    }
    
    public var peerId: MCPeerID {
        
        get {
            return self._peerId
        }
    }
    
    public var serviceAdvertiser: MCNearbyServiceAdvertiser {
        
        get {
            return self._serviceAdvertiser
        }
    }
    
    public var serviceBrowser: MCNearbyServiceBrowser {
        
        get {
            return self._serviceBrowser
        }
    }
    
    public var profile: ProfileRequirements {
        
        get {
            return self._profile
        }
    }
    
    public var peers: [MCPeerID] {
        
        get {
            return self._peers
        }
        
        set(peers) {
            self._peers = peers
        }
    }
    
    public var peersDiscoveryInfos: [[String : String]] {
        
        get {
            return self._peersDiscoveryInfos
        }
        
        set(peersDiscoveryInfos) {
            self._peersDiscoveryInfos = peersDiscoveryInfos
        }
    }
    
    public var discoveryInfo: [String : String] {
        
        get {
            return self._discoveryInfo
        }
        
        set(discoveryInfo) {
            self.serviceAdvertiser.stopAdvertisingPeer()
            self.serviceBrowser.stopBrowsingForPeers()
            self._discoveryInfo = discoveryInfo
            self._serviceAdvertiser = MCNearbyServiceAdvertiser(peer: _peerId, discoveryInfo: discoveryInfo, serviceType: self._serviceType)
            self._serviceAdvertiser.delegate = self
            if (self.isActive) {
                self.serviceAdvertiser.startAdvertisingPeer()
                self.serviceBrowser.startBrowsingForPeers()
            }
        }
    }
    
    public var session: MCSession {
        
        get {
            return self._session
        }
    }
    
    public var isActive: Bool = false {
        didSet {
            if (self.isActive) {
                self.serviceAdvertiser.startAdvertisingPeer()
                self.serviceBrowser.startBrowsingForPeers()
            } else {
                self.serviceAdvertiser.stopAdvertisingPeer()
                self.serviceBrowser.stopBrowsingForPeers()
            }
        }
    }
    
    public var invitationHandler: ((Bool, MCSession?)->Void)! {
        get {
            return _invitationHandler
        }
    }
    
    internal init(profile: ProfileRequirements, serviceType: String) {
        self._profile = profile
        self._serviceType = serviceType
        self._peerId = MCPeerID(displayName: "\(self._profile.id)|\(self._serviceType)")
        self._serviceAdvertiser = MCNearbyServiceAdvertiser(peer: _peerId,
                                                            discoveryInfo: ["seviceType": self._serviceType,
                                                                            "username": self._profile.username],
                                                            serviceType: self._serviceType)
        self._serviceBrowser = MCNearbyServiceBrowser(peer: _peerId, serviceType: self._serviceType)
        self._peers = []
        self._peersDiscoveryInfos = []
        self._discoveryInfo = [:]
        self._session = MCSession(peer: self._peerId, securityIdentity: nil, encryptionPreference: .none)
        
        super.init()
        
        self._serviceAdvertiser.delegate = self
        self._serviceBrowser.delegate = self
        self._session.delegate = self
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
}

extension Service: MCNearbyServiceAdvertiserDelegate {
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {}
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        if (self.peerId.displayName.components(separatedBy: "|")[1] != self.serviceType) {
            return
        }
        
        _invitationHandler = invitationHandler
    }
}

extension Service: MCNearbyServiceBrowserDelegate {
    
    public func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {}
    
    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if (self.peerId.displayName.components(separatedBy: "|")[1] != self.serviceType) {
            return
        }
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        if (self.peerId.displayName.components(separatedBy: "|")[1] != self.serviceType) {
            return
        }
    }
}

extension Service: MCSessionDelegate {
    
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("-----------Connected-----------")
            break
        case MCSessionState.connecting:
            print("-----------Connecting-----------")
            break
        case MCSessionState.notConnected:
            print("-----------Not Connected-----------")
            break
        }
    }
    
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if (self.peerId.displayName.components(separatedBy: "|")[1] != self.serviceType) {
            return
        }
    }
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        if (self.peerId.displayName.components(separatedBy: "|")[1] != self.serviceType) {
            return
        }
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        if (self.peerId.displayName.components(separatedBy: "|")[1] != self.serviceType) {
            return
        }
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        if (self.peerId.displayName.components(separatedBy: "|")[1] != self.serviceType) {
            return
        }
    }
    
    public func send(message: String, toPeer peer: MCPeerID) {
        if (session.connectedPeers.contains(peer)) {
            do {
              try session.send(message.data(using: String.Encoding.utf8)!, toPeers: [peer], with: .reliable)
            } catch let error {
                print(error)
            }
        }
    }
}

