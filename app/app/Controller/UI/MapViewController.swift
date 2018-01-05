//
//  FirstViewController.swift
//  FirstMini
//
//  Created by Alessio Tortello on 11/12/2017.
//  Copyright © 2017 Alessio Tortello. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import ConnectivityServices

class MapViewController: ConnectivityViewController {
    
    @IBOutlet var panCircleView: UIPanGestureRecognizer!
    @IBOutlet var tapCircleView: UITapGestureRecognizer!
    
    var circleView: CircleView!
    var avatarButtons: [String: AvatarPlanetButton] = [:]
    var selectedAvatarButton: AvatarPlanetButton? = nil {
        willSet {
            if let value = newValue {
                self.previousSelectedAvatarButtonCenter = value.center - self.circleView.translation
            } else {
                self.previousSelectedAvatarButtonCenter = nil
            }
        }
    }
    
    var previousSelectedAvatarButtonCenter: CGPoint? = nil
    
    override var isPromptVisible: Bool {
        didSet {
            if let items = self.tabBarController?.tabBar.items {
                for button in items {
                    button.isEnabled = !self.isPromptVisible
                }
            }
            self.isGestureEnabled = false
            UIView.animate(withDuration: 0.35) {
                if (self.isPromptVisible) {
                    self.circleView.alpha = 0
                    for (_ , button) in self.avatarButtons {
                        if (button != self.selectedAvatarButton) {
                            button.alpha = 0
                        }
                    }
                } else {
                    self.circleView.alpha = 1
                    for (_ , button) in self.avatarButtons {
                        button.alpha = 1
                    }
                }
            }
        }
    }
    
    var isGestureEnabled: Bool = true {
        didSet {
            self.panCircleView.isEnabled = self.isGestureEnabled
            self.tapCircleView.isEnabled = self.isGestureEnabled
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpPromptViews()
        UIViewController.setViewBackground(for: self)
        self.circleView = CircleView(frame: self.view.frame)
        self.circleView.radius = 60
        self.circleView.delegate = self
        self.view.addSubview(self.circleView)
        self.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func peerFound(withId id: MCPeerID) {
        super.peerFound(withId: id)
        self.reloadData()
    }
    
    override func peerLost(withId id: MCPeerID) {
        super.peerLost(withId: id)
        self.avatarButtons.removeValue(forKey: id.displayName.components(separatedBy: "|")[0])
        self.reloadData()
    }
    
    override func invitePeer(withId id: MCPeerID, profile: ProfileRequirements) {
        super.invitePeer(withId: id, profile: profile)
        self.isPromptVisible = true
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: self.translateCirclesWith(button: self.selectedAvatarButton),
                       completion: { completed in self.isGestureEnabled = false })
        self.view.insertSubview(self.invitationView, belowSubview: self.selectedAvatarButton! )
        self.usernameLabel.text = self.selectedAvatarButton!.userNameLabel.text
        self.gameButton.backgroundColor = self.selectedAvatarButton!.faceImageView.backgroundColor
        self.chatButton.backgroundColor = self.selectedAvatarButton!.faceImageView.backgroundColor
        self.centerCircles()
    }
    
    override func dismissInvitationPrompt() {
        super.dismissInvitationPrompt()
        UIView.animate(withDuration: 0.35,
                       animations: {
                        if let button = self.selectedAvatarButton {
                            if let center = self.previousSelectedAvatarButtonCenter {
                                button.center = center
                            }
                        }
        },
                       completion: { completed in
                        if (completed) {
                            self.selectedAvatarButton = nil
                            self.isGestureEnabled = true
                        }
        })
        
        self.isPromptVisible = false
    }
    
    @IBAction func panCircles(_ sender: UIPanGestureRecognizer) {
        if self.people.count != 0 {
            switch sender.state {
            case UIGestureRecognizerState.began:
                break
            case UIGestureRecognizerState.changed:
                let translation = sender.translation(in: self.view)
                self.circleView.center += translation
                for (_, button) in self.avatarButtons {
                    button.center += translation
                }
                
                self.circleView.translation += translation
                sender.setTranslation(CGPoint.zero, in: self.view)
                break
            case UIGestureRecognizerState.ended:
                UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseOut,
                               animations: self.translateCirclesWith(velocity: sender.velocity(in: self.view)),
                               completion: nil)
                break
            default:
                break
            }
        }
    }
    
    @IBAction func tapCenterCircles(_ sender: UITapGestureRecognizer) {
        self.centerCircles()
    }
    
    @IBAction func showInvitationPrompt(_ sender: AvatarPlanetButton) {
        if (sender.center != self.avatarFrameView.center) {
            if let profile = sender.userProfile {
                var id: MCPeerID? = nil
                for peer in ServiceManager.instance.chatService.peers {
                    if (peer.displayName.components(separatedBy: "|")[0] == profile.id) {
                        id = peer
                        break
                    }
                }
                
                if (id != nil) {
                    self.selectedAvatarButton = sender
                    self.invitePeer(withId: id!, profile: profile)
                }
            }
        }
    }
    
    func centerCircles() {
        self.isGestureEnabled = false
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: self.translateCirclesWith(),
                       completion: { completed in
                        if (completed) {
                            self.circleView.translation = CGPoint.zero
                            self.isGestureEnabled = true
                        }
        })
    }
    
    override func reloadData() {
        super.reloadData()
        self.centerCircles()
        if (self.people.count > 0) {
            for view in self.view.subviews {
                if let button = view as? AvatarPlanetButton {
                    button.removeFromSuperview()
                }
            }
            
            var peersMissing = self.people.count
            var circlePopulation = 1
            var circleIndex = 0
            
            while (peersMissing > 0) {
                peersMissing -= circlePopulation
                circlePopulation += (circleIndex + 1)
                circleIndex += 1
            }
            
            self.circleView.numberOfCircles = circleIndex
            
            circleIndex = 0
            circlePopulation = 1
            for i in 0 ... self.people.count - 1 {
                let button = AvatarPlanetButton.createAvatarButton(from: self.people[i], size: self.avatarFrameView.frame.size - 5)
                repeat {
                    let center = self.circleView.points[Int(arc4random_uniform(UInt32(361))) + 361 * self.circleView.circleFirstIndex[circleIndex] ]
                    button.center = CGPoint(x: center.x, y: center.y)
                } while (self.checkButtonColision(button))
                
                button.addTarget(self, action: #selector(showInvitationPrompt(_:)), for: UIControlEvents.touchUpInside)
                self.avatarButtons[self.people[i].id] = button
                self.view.addSubview(button)
                if (i == 0 || circlePopulation == i) {
                    circleIndex += 1
                    circlePopulation += i + 1
                }
            }
        }
    }
    
    private func checkButtonColision(_ button: AvatarPlanetButton) -> Bool {
        let margins: CGFloat = 10
        let extendedFrame = CGRect(origin: button.frame.origin,
                                   size: CGSize(width: button.frame.width + margins,
                                                height: button.frame.height + margins))
        for (_, existingButton) in self.avatarButtons {
            let existingFrame = CGRect(origin: existingButton.frame.origin - (margins / 2),
                                       size: existingButton.frame.size + margins)
            if (extendedFrame.intersects(existingFrame)) {
                return true
            }
        }
        
        return false
    }
    
    private func translateCirclesWith(button: AvatarPlanetButton? = nil, velocity: CGPoint? = nil) -> () -> Void {
        if var velocity = velocity {
            return {
                velocity *= 0.1
                self.circleView.center += velocity
                for (_, button) in self.avatarButtons {
                    button.center += velocity
                }
                
                self.circleView.translation += velocity
            }
        } else if let sender = button {
            return  {
                self.isGestureEnabled = false
                sender.center = self.avatarFrameView.center
            }
        } else {
            return  {
                self.circleView.center -= self.circleView.translation
                for (_, button) in self.avatarButtons {
                    if (button != self.selectedAvatarButton) {
                        button.center -= self.circleView.translation
                    }
                }
            }
        }
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

