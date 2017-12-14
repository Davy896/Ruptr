//
//  ChatService.swift
//  ConnectivityServices
//
//  Created by Lucas Assis Rodrigues on 11/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import MultipeerConnectivity

public class ChatService: Service {
    
    public var delegate : ChatServiceDelegate?
    
    public init(profile: ProfileRequirements) {
        super.init(profile: profile, serviceType: ServiceTypes.chat)
    }
}

extension ChatService { // MCNearbyServiceAdvertiserDelegate
    
    public override func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
            delegate?.handleInvitation(from: peerID.displayName)
    }
}

extension ChatService { // MCNearbyServiceBrowserDelegate
    
    public override func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {}
    
    public override func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard let info = info else {
            return
        }
        
        if !(self._peers.contains(peerID)) {
            self._peers.append(peerID)
            self._peersDiscoveryInfos.append(info)
        }
        
        delegate?.peerFound(withId: peerID)
    }
    
    public override func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for i in 0 ... self.peers.count - 1 {
            if (self._peers[i] == peerID) {
                self._peers.remove(at: i)
                self._peersDiscoveryInfos.remove(at: i)
                break
            }
        }
        
        delegate?.peerLost(withId: peerID)
    }
}

extension ChatService { // MCSessionDelegate
    
}
