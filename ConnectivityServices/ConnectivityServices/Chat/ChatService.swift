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
        super.advertiser(advertiser, didReceiveInvitationFromPeer: peerID, withContext: context, invitationHandler: invitationHandler)
        delegate?.handleInvitation(from: peerID, withContext: context)
    }
}

extension ChatService { // MCNearbyServiceBrowserDelegate
    
    public override func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {}
    
    public override func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        super.browser(browser, foundPeer: peerID, withDiscoveryInfo: info)
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
        super.browser(browser, lostPeer: peerID)
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
    public override func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        super.session(session, didReceive: data, fromPeer: peerID)
        if let message = String(data: data, encoding: String.Encoding.utf8) {
            self.delegate?.handleMessage(from: peerID, message: message)
        }
    }
    
    public override func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
       super.session(session, peer: peerID, didChange: state)
        switch state {
        case MCSessionState.connecting:
            break
        case MCSessionState.connected:
            self.delegate?.connectedSuccessfully(with: peerID)
            break
        case MCSessionState.notConnected:
            break
        
        }
    }
    
    public override func send(message: String, toPeer peer: MCPeerID) {
        super.send(message: message, toPeer: peer)
        self.delegate?.handleMessage(from: peer, message: message)
    }
}
