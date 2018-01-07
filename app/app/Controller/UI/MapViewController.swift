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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        for (_, button) in self.avatarButtons {
            button.removeFromSuperview()
        }
        
        self.circleView.center = self.view.center
        self.circleView.translation = CGPoint.zero
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
        self.view.insertSubview(self.inviteView.dialogBoxView, belowSubview: self.selectedAvatarButton! )
        self.inviteView.usernameLabel.text = self.selectedAvatarButton!.userNameLabel.text
        self.inviteView.gameButton.backgroundColor = self.selectedAvatarButton!.faceImageView.backgroundColor
        self.inviteView.chatButton.backgroundColor = self.selectedAvatarButton!.faceImageView.backgroundColor
        self.centerCircles()
    }
    
    override func dismissInvitationPrompt() {
        super.dismissInvitationPrompt()
        UIView.animate(withDuration: 0.35,
                       animations: {
                        if let button = self.selectedAvatarButton {
                            if let center = self.previousSelectedAvatarButtonCenter {
                                button.center = center
                                self.view.insertSubview(button, aboveSubview: self.circleView)
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
        self.isBusy = false
    }
    
    override func connectionLost() {
        OperationQueue.main.addOperation {
            self.isGestureEnabled = false
            self.view.isUserInteractionEnabled = true
            self.view.bringSubview(toFront: self.transparencyView)
            UIView.animate(withDuration: 0.2) {
                self.isBusy = false
            }
            
            let alert = AlertView.createAlert(title: "Busy", message: "Invited peer appears to be busy", action: {
                for view in self.view.subviews {
                    if let alert = view as? AlertView {
                        UIView.animate(withDuration: 0.35, animations: {
                            self.transparencyView.alpha = 0
                            alert.alpha = 0
                        }, completion: { finished in
                            if (finished) {
                                alert.removeFromSuperview()
                                self.isGestureEnabled = true
                            }
                        })
                        
                        break
                    }
                }
            })
            
            alert.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            alert.alpha = 0
            self.view.addSubview(alert)
            UIView.animate(withDuration: 0.35, animations: {
                self.transparencyView.alpha = 0.7
                alert.alpha = 1
            })
        }
    }
    
    override func handleInvitation(from: MCPeerID, withContext context: Data?, invitationHandler: @escaping ((Bool, MCSession?) -> Void)) {
        if (!self.isBusy) {
            self.isBusy = true
            self.isGestureEnabled = false
            if let context = context {
                if let data = String(data: context, encoding: String.Encoding.utf8) {
                    if let items = self.tabBarController?.tabBar.items {
                        for item in items {
                            item.isEnabled = false
                        }
                        
                        let chatService = ServiceManager.instance.chatService
                        let userData = ConnectivityViewController.decodeUserData(from: data)
                        let invitationText = userData[DecodedUserDataKeys.interactionType] == "chat" ? NSLocalizedString("chat_invite_message", comment: "") : NSLocalizedString("game_invite_message", comment: "")
                        OperationQueue.main.addOperation {
                            self.view.bringSubview(toFront: self.invitationView)
                            self.invitationView.avatarInviting.hairImageView.image = UIImage(named: userData[DecodedUserDataKeys.avatarHair]!)
                            self.invitationView.avatarInviting.faceImageView.image = UIImage(named: userData[DecodedUserDataKeys.avatarFace]!)
                            self.invitationView.avatarInviting.faceImageView.backgroundColor = Colours.getColour(named: userData[DecodedUserDataKeys.avatarSkinTone]!,
                                                                                                                 index: Int(userData[DecodedUserDataKeys.avatarSkinToneIndex]!))
                            
                            self.invitationView.usernameLabel.text = userData[DecodedUserDataKeys.username]!
                            self.invitationView.messageLabel.text = "\(NSLocalizedString("invite_message", comment: "")) \(invitationText)"
                            self.invitationView.acceptButton.bgColor = Colours.getColour(named: userData[DecodedUserDataKeys.avatarSkinTone]!,
                                                                                         index: Int(userData[DecodedUserDataKeys.avatarSkinToneIndex]!))
                            self.invitationView.acceptButtonAction = {
                                self.isGame = userData[DecodedUserDataKeys.interactionType]! == "game"
                                for item in items {
                                    item.isEnabled = true
                                }
                                
                                GameViewController.randomEmoji = userData[DecodedUserDataKeys.emoji]!
                                GameViewController.isPlayerOne = false
                                ServiceManager.instance.selectedPeer = (from,
                                                                        userData[DecodedUserDataKeys.username]!,
                                                                        userData[DecodedUserDataKeys.avatarHair]!,
                                                                        userData[DecodedUserDataKeys.avatarFace]!,
                                                                        userData[DecodedUserDataKeys.avatarSkinTone]!,
                                                                        userData[DecodedUserDataKeys.avatarSkinToneIndex]!)
                                self.isBusy = false
                                invitationHandler(true, chatService.session)
                                UIView.animate(withDuration: 0.35, animations: {
                                    self.invitationView.alpha = 0
                                    self.transparencyView.alpha = 0
                                }) { finished in
                                    if (finished) {
                                        self.isGestureEnabled = true
                                    }
                                }
                            }
                            
                            self.invitationView.refuseButtonAction = {
                                UIImpactFeedbackGenerator(style: UIImpactFeedbackStyle.heavy).impactOccurred()
                                for item in items {
                                    item.isEnabled = true
                                }
                                
                                self.isBusy = false
                                invitationHandler(false, chatService.session)
                                UIView.animate(withDuration: 0.35, animations: {
                                    self.invitationView.alpha = 0
                                    self.transparencyView.alpha = 0
                                }) { finished in
                                    if (finished) {
                                        self.isGestureEnabled = true
                                    }
                                }
                            }
                            
                            UIView.animate(withDuration: 0.35, animations: {
                                self.invitationView.alpha = 1
                                self.transparencyView.alpha = 0.7
                            })
                        }
                    }
                }
            }
        } else {
            invitationHandler(false, ServiceManager.instance.chatService.session)
        }
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
        if (sender.center != self.inviteView.avatarFrameView.center) {
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
                    self.view.bringSubview(toFront: self.inviteView)
                    self.view.bringSubview(toFront: sender)
                    self.invitePeer(withId: id!, profile: profile)
                }
            }
        }
    }
    
    func centerCircles(animated: Bool = true) {
        self.isGestureEnabled = false
        UIView.animate(withDuration: animated ? 0.35 : 0,
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
                let button = AvatarPlanetButton.createAvatarButton(from: self.people[i], size: self.inviteView.avatarFrameView.frame.size - 5)
                repeat {
                    let center = self.circleView.points[Int(arc4random_uniform(UInt32(361))) + 361 * self.circleView.circleFirstIndex[circleIndex] ]
                    button.center = CGPoint(x: center.x, y: center.y)
                } while (self.checkButtonColision(button))
                
                button.addTarget(self, action: #selector(showInvitationPrompt(_:)), for: UIControlEvents.touchUpInside)
                self.avatarButtons[self.people[i].id] = button
                self.view.addSubview(button)
                self.view.insertSubview(button, aboveSubview: self.circleView)
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
                sender.center = self.inviteView.avatarFrameView.center + CGPoint(x: self.inviteView.dialogBoxView.frame.minX,
                                                                                 y: self.inviteView.dialogBoxView.frame.minY)
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

