//
//  ChatService.swift
//  ConnectivityServices
//
//  Created by Lucas Assis Rodrigues on 11/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import MultipeerConnectivity

public class ChatService: NSObject {
    
    private let _serviceType: String
    private let _peerId: MCPeerID
    private let _serviceAdvertiser: MCNearbyServiceAdvertiser
    private let _serviceBrowser: MCNearbyServiceBrowser
    private var _profile: ProfileRequirements
    private var _peers: [MCPeerID]
    
    private lazy var _session: MCSession = {
        let session = MCSession(peer: self._peerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    public var delegate : ChatServiceDelegate?
    
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
    
    public init(profile: ProfileRequirements) {
        self._serviceType = ServiceTypes.chat
        self._profile = profile
        self._peerId = MCPeerID(displayName: "\(self._profile.id)\(self._serviceType)")
        self._serviceAdvertiser = MCNearbyServiceAdvertiser(peer: _peerId, discoveryInfo: nil, serviceType: self._serviceType)
        self._serviceBrowser = MCNearbyServiceBrowser(peer: _peerId, serviceType: self._serviceType)
        self._peers = []
        
        super.init()
        
        self._serviceAdvertiser.delegate = self
        self._serviceAdvertiser.startAdvertisingPeer()
        self._serviceBrowser.delegate = self
        self._serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self._serviceAdvertiser.stopAdvertisingPeer()
        self._serviceBrowser.stopBrowsingForPeers()
    }
}

extension ChatService: MCNearbyServiceAdvertiserDelegate {
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {}
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("advertiser")
        delegate?.handleInvitation(from: peerID.displayName)
    }
}

extension ChatService: MCNearbyServiceBrowserDelegate {
    
    public func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {}
    
    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if !(self._peers.contains(peerID)) {
            self._peers.append(peerID)
        }
        
        delegate?.peerFound(withId: peerID)
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for i in 0 ... (self._peers.count - 1) {
            if (self._peers[i] == peerID) {
                self._peers.remove(at: i)
                break
            }
        }
        
        delegate?.peerLost(withId: peerID)
    }
}

extension ChatService: MCSessionDelegate {
    
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {}
    
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {}
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}
