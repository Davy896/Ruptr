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
    var avatarButtons: [MCPeerID: AvatarPlanetButton] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.setViewBackground(for: self)
        self.title = NSLocalizedString("map", comment: "")
        
        self.circleView = CircleView(frame: self.view.frame)
        self.circleView.isUserInteractionEnabled = true
        self.circleView.radius = 80
        self.circleView.delegate = self
        self.updateNumberOf(peers: ServiceManager.instance.chatService.peers.count)
        self.view.addSubview(self.circleView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func peerFound(withId id: MCPeerID) {
        super.peerFound(withId: id)
        if let peer = self.people.last {
            self.updateNumberOf(peers: ServiceManager.instance.chatService.peers.count)
            let button = AvatarPlanetButton.createAvatarButton(from: peer, size: CGSize(width: 65, height: 65))
            button.center = self.circleView.points[Int(arc4random_uniform(UInt32(self.circleView.points.count)))]
            button.addTarget(self, action: #selector(showInvitationPrompt(_:)), for: UIControlEvents.touchUpInside)
            self.avatarButtons[id] = button
            self.view.addSubview(button)
        }
    }
    
    override func peerLost(withId id: MCPeerID) {
        super.peerLost(withId: id)
        if let peerRemoved = self.avatarButtons.removeValue(forKey: id) {
            UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                peerRemoved.alpha = 0
            }, completion: nil)
            peerRemoved.removeFromSuperview()
        }
        
        self.updateNumberOf(peers: ServiceManager.instance.chatService.peers.count)
    }
    
    @IBAction func showInvitationPrompt(_ sender: AvatarPlanetButton) {
        print("\(sender.userNameLabel.text ?? "nil")")
    }
    
    @IBAction func moveCircles(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case UIGestureRecognizerState.began:
            break
        case UIGestureRecognizerState.changed:
            let translation = sender.translation(in: self.view)
            self.circleView.center = CGPoint(x: self.circleView.center.x + translation.x,
                                             y: self.circleView.center.y + translation.y)
            for (_, button) in self.avatarButtons {
                button.center = CGPoint(x: button.center.x + translation.x,
                                        y: button.center.y + translation.y)
            }
            
            sender.setTranslation(CGPoint.zero, in: self.view)
            break
        case UIGestureRecognizerState.ended:
            let velocity = sender.velocity(in: self.view)
            var endPosition = CGPoint(x: self.circleView.center.x + (velocity.x * 0.1),
                                      y: self.circleView.center.y + (velocity.y * 0.1))
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.circleView.center = endPosition
                for (_, button) in self.avatarButtons {
                    endPosition = CGPoint(x: button.center.x + (velocity.x * 0.1), y: button.center.y + (velocity.y * 0.1))
                    button.center = endPosition
                }
            }, completion: nil)
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
    
    func updateNumberOf(peers numberOfPeers: Int) {
        var peersMissing: Int = numberOfPeers
        var circlePopulation: Int = 1
        var circleIndex: Int = 0
        while peersMissing > 0 {
            peersMissing -= circlePopulation
            circlePopulation += (circleIndex + 1)
            circleIndex += 1
        }
        
        self.circleView.numberOfCircles = circleIndex
    }
}

extension MapViewController: CircleViewDelegate  {
    func handleDrawingCompletion() {
        for (_, button) in self.avatarButtons {
            UIView.animate(withDuration: 0.35,
                           delay: 0,
                           options: UIViewAnimationOptions.curveEaseIn,
                           animations: { button.alpha = 1 },
                           completion: nil)
        }
    }
}

extension Dictionary where Key: Comparable, Value: Equatable {
    func minus(dict: [Key:Value]) -> [Key:Value] {
        let entriesInSelfAndNotInDict = filter { dict[$0.key] != self[$0.0] }
        return entriesInSelfAndNotInDict.reduce([Key:Value]()) { (res, entry) -> [Key:Value] in
            var res = res
            res[entry.0] = entry.1
            return res
        }
    }
}

