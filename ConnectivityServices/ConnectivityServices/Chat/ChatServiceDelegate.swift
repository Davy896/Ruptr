//
//  ChatServiceDelegate.swift
//  ConnectivityServices
//
//  Created by Lucas Assis Rodrigues on 11/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//
import MultipeerConnectivity

public protocol ChatServiceDelegate {
    
    func invitePeer(withId id: MCPeerID, profile: ProfileRequirements)
    func handleInvitation(from: MCPeerID, withContext context: Data?)
    func handleMessage(from: MCPeerID, message: String)
    func peerFound(withId id: MCPeerID)
    func peerLost(withId id: MCPeerID)
    func connectedSuccessfully(with id: MCPeerID)
    func setDiscoveryInfo(from profile: ProfileRequirements)
}
