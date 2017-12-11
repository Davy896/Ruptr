//
//  ChatServiceDelegate.swift
//  ConnectivityServices
//
//  Created by Lucas Assis Rodrigues on 11/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//
import MultipeerConnectivity

public protocol ChatServiceDelegate {
    
    func invitePeer(withId id: MCPeerID)
    func handleInvitation(from: String)
    func peerFound(withId id: MCPeerID)
    func peerLost(withId id: MCPeerID)
}
