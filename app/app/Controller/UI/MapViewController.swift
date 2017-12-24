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
        let a = AvatarPlanetButton(frame: CGRect(x: 50, y: 200, width: 40, height: 40))
        a.hairImageView.image = ServiceManager.instance.userProfile.avatarHair
        a.faceImageView.image = ServiceManager.instance.userProfile.avatarFace
        a.backgroundColor = ServiceManager.instance.userProfile.avatarSkin
        a.borderColor = UIColor.blue
        a.addTarget(self, action: #selector(showInvitationPrompt(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(a)
        self.view.bringSubview(toFront: a)
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
        var circleIndex: Int = 0
        while peersMissing > 0 {
            peersMissing -= circlePopulation
            circlePopulation += (circleIndex + 1)
            circleIndex += 1
        }
        
        self.circleView.drawCircles(numberOf: circleIndex, onRectangle: circleView.frame, withRadius: 40)
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
    
    @IBAction func showInvitationPrompt(_ sender: UIButton) {
        print("ndaklsjdkladjlksakldasjkldsajdklsjdlkas")
    }
}


