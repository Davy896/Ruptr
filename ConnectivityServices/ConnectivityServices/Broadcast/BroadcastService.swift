//
//  BroadcastService.swift
//  ConnectivityServices
//
//  Created by Lucas Assis Rodrigues on 10/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import MultipeerConnectivity

public class BroadcastService: Service {
    
    public var delegate: BroadcastServiceDelegate?
    
    public init(profile: ProfileRequirements) {
        super.init(profile: profile, serviceType: ServiceTypes.broadcast)
    }
    
    public func broadcastMessage(message: String) {
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(message.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            }
                
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
    }
}

extension BroadcastService { // MCNearbyServiceAdvertiserDelegate
    
    public override func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
//        invitationHandler(true, self.session)
    }
}

extension BroadcastService { // MCNearbyServiceBrowserDelegate
    
    public override func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
//        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
    
    public override func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {}
}

extension BroadcastService { // MCSessionDelegate
    
    public override func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        guard let message = String(data: data, encoding: String.Encoding.utf8) else {
//            return
//        }
//        
//        self.delegate?.receiveBroadcastedMessage(manager: self, message: message)
    }
}
