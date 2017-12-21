//
//  FirstViewController.swift
//  FirstMini
//
//  Created by Alessio Tortello on 11/12/2017.
//  Copyright © 2017 Alessio Tortello. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MapViewController: ConnectivityViewController {
    
    var circleView: CircleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.setViewBackground(for: self)
        self.circleView = CircleView(frame: self.view.frame)
        self.view.addSubview(self.circleView)
        self.title = NSLocalizedString("map", comment: "")
        let a = AvatarPlanetButton(frame: CGRect(x: 0, y: 0, width: 110, height: 93))
        a.faceImageView.image = UIImage(named: "food")
        self.view.bringSubview(toFront: a)
        self.view.addSubview(a)
        self.updateCircles(numberOfPeers: ServiceManager.instance.chatService.peers.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateCircles(numberOfPeers: ServiceManager.instance.chatService.peers.count)
    }
    
    func updateCircles(numberOfPeers: Int) {
        var peersMissing: Int = numberOfPeers
        var circlePopulation: Int = 1
        var circleIndex: Int = 1
        while peersMissing > 0 {
            peersMissing -= circlePopulation
            circlePopulation += circleIndex
            circleIndex += 1
        }
        
        self.circleView.drawCircles(numberOf: circleIndex, onRectangle: circleView.frame, withRadius: 80)
        self.circleView.setNeedsDisplay()
    }
    
    override func peerFound(withId id: MCPeerID) {
        super.peerFound(withId: id)
        self.updateCircles(numberOfPeers: ServiceManager.instance.chatService.peers.count)
    }
    
    override func peerLost(withId id: MCPeerID) {
        super.peerLost(withId: id)
        self.updateCircles(numberOfPeers: ServiceManager.instance.chatService.peers.count)
    }
}


