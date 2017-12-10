//
//  BroadcastServiceDelegate.swift
//  ConnectivityServices
//
//  Created by Lucas Assis Rodrigues on 10/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

public protocol BroadcastServiceDelegate {
    
    func receiveBroadcastedMessage(manager: BroadcastService, message: String)
}

