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
    internal let _serviceAdvertiser: MCNearbyServiceAdvertiser
    internal let _serviceBrowser: MCNearbyServiceBrowser
    internal var _profile: ProfileRequirements
    internal var _peers: [MCPeerID]
    
    internal lazy var _session: MCSession = {
        let session = MCSession(peer: self._peerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
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
    }
    
    public var session: MCSession {
        
        get {
            return self._session
        }
    }
    
    internal init(profile: ProfileRequirements, serviceType: String) {
        self._profile = profile
        self._serviceType = serviceType
        self._peerId = MCPeerID(displayName: "\(self._profile.id)")
        self._serviceAdvertiser = MCNearbyServiceAdvertiser(peer: _peerId, discoveryInfo: ["seviceType": self._serviceType, "avatar": self._profile.avatar, "userName": self._profile.userName ], serviceType: self._serviceType)
        self._serviceBrowser = MCNearbyServiceBrowser(peer: _peerId, serviceType: self._serviceType)
        self._peers = []
        
        super.init()
        
        self._serviceAdvertiser.delegate = self
        self._serviceBrowser.delegate = self
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
    }
}

extension Service: MCNearbyServiceBrowserDelegate {
    
    public func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {}
    
    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if (self.peerId.displayName.components(separatedBy: "|")[1] != self.serviceType && info != nil) {
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
    
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {}
    
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
}

