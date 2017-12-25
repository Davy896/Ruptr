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
    var circleCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.setViewBackground(for: self)
        self.title = NSLocalizedString("map", comment: "")
        
        
        self.circleView = CircleView(frame: self.view.frame)
        self.circleCenter = self.view.frame.origin
        
        circleView.isUserInteractionEnabled = true
        
        self.view.addSubview(self.circleView)
        
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
    
    @IBAction func moveCircles(_ sender: UIPanGestureRecognizer) {
        self.circleView.isPanned = true
        switch sender.state {
        case UIGestureRecognizerState.began:
            break
        case UIGestureRecognizerState.changed:
            let translation = sender.translation(in: self.view)
            self.circleView.center.x = self.circleView.center.x + translation.x
            self.circleView.center.y = self.circleView.center.y + translation.y
            sender.setTranslation(CGPoint.zero, in: self.view)
            break
        case UIGestureRecognizerState.ended:
            let velocity = sender.velocity(in: self.view)
            let endPosition = CGPoint(x: self.circleView.center.x + (velocity.x * 0.1),
                                      y: self.circleView.center.y + (velocity.y * 0.1))
            UIView.animate(withDuration: 0.35,
                           delay: 0,
                           options: UIViewAnimationOptions.curveEaseOut,
                           animations: { self.circleView.center = endPosition },
                           completion: { finished in self.circleView.isPanned = false })
            break
        default:
            break
        }
    }
    
    @IBAction func centerCircles(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: { self.circleView.center = self.view.center },
                       completion: nil)
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
        
        self.circleView.drawCircles(numberOf: circleIndex,
                                    onRectangle: CGRect(origin: self.circleCenter,
                                                        size: self.view.frame.size),
                                    withRadius: 80)
        self.circleView.setNeedsDisplay()
    }
}


