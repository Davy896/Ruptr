//
//  InvitationView.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 06/01/2018.
//  Copyright © 2018 Apple Dev Academy. All rights reserved.
//

import UIKit

class InvitationView: UIView {
    
    var dialogBoxView: RoundView
    var avatarFrameView: RoundView
    var avatarInviting: AvatarPlanetButton
    var usernameLabel: UILabel
    var messageLabel: UILabel
    var acceptButton: RoundButton
    var refuseButton: RoundButton
    
    var acceptButtonAction: (()->Void)?
    var refuseButtonAction: (()->Void)?
    
    let margin: CGFloat = 16
    
    var avatarFrameViewSize: CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    override init(frame: CGRect) {
        self.dialogBoxView = RoundView()
        self.avatarFrameView = RoundView()
        self.avatarInviting = AvatarPlanetButton()
        self.usernameLabel = UILabel()
        self.messageLabel = UILabel()
        self.acceptButton = RoundButton()
        self.refuseButton = RoundButton()
        super.init(frame: frame)
        
        self.setUpSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.dialogBoxView = RoundView()
        self.avatarFrameView = RoundView()
        self.avatarInviting = AvatarPlanetButton()
        self.usernameLabel = UILabel()
        self.messageLabel = UILabel()
        self.acceptButton = RoundButton()
        self.refuseButton = RoundButton()
        
        super.init(coder: aDecoder)
        
        self.setUpSubviews()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    private func setUpSubviews() {
        self.dialogBoxView = RoundView()
        self.dialogBoxView.backgroundColor = UIColor.white
        self.dialogBoxView.cornerRadius = 5
        self.dialogBoxView.autoresizesSubviews = true
        self.alpha = 0
        self.addSubview(self.dialogBoxView)
        
        self.avatarFrameView = RoundView()
        self.avatarFrameView.frame.size = self.avatarFrameViewSize
        self.avatarFrameView.center = CGPoint(x: self.dialogBoxView.bounds.midX, y: self.dialogBoxView.bounds.minY)
        self.avatarFrameView.backgroundColor = UIColor.white
        self.avatarFrameView.circle = true
        
        self.avatarInviting = AvatarPlanetButton()
        self.avatarInviting.frame.size = self.avatarFrameView.frame.size - 5
        self.avatarInviting.center = CGPoint(x: self.avatarFrameView.bounds.midX, y: self.avatarFrameView.bounds.midY)
        self.avatarInviting.isUserInteractionEnabled = false
        self.avatarInviting.alpha = 1
        self.avatarFrameView.addSubview(self.avatarInviting)
        
        self.usernameLabel = UILabel()
        self.usernameLabel.font = UIFont(name: "Futura-Bold", size: 24)
        self.usernameLabel.adjustsFontSizeToFitWidth = true
        self.usernameLabel.textAlignment = NSTextAlignment.center
        self.usernameLabel.textColor = UIColor.black
        self.usernameLabel.text = "USER_NAME"
        self.usernameLabel.sizeToFit()
        
        
        self.messageLabel = UILabel()
        self.messageLabel.font = UIFont(name: "Futura-Medium", size: 17)
        self.messageLabel.adjustsFontSizeToFitWidth = true
        self.messageLabel.textColor = UIColor.black
        self.messageLabel.textAlignment = NSTextAlignment.center
        self.messageLabel.text = "\(NSLocalizedString("invite_message", comment: "")) to play a game."
        self.messageLabel.sizeToFit()
        
        self.acceptButton = RoundButton()
        self.acceptButton.frame.size.height = 40
        self.acceptButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.acceptButton.setTitle(NSLocalizedString("accept", comment: ""), for: UIControlState.normal)
        self.acceptButton.titleLabel?.font = UIFont(name: "Futura-Medium", size: 20)
        self.acceptButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.acceptButton.addTarget(self, action: #selector(self.acceptInvitation(_:)), for: UIControlEvents.touchUpInside)
        
        self.refuseButton = RoundButton()
        self.refuseButton.frame.size.height = self.acceptButton.frame.height
        self.refuseButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.refuseButton.setTitle(NSLocalizedString("refuse", comment: ""), for: UIControlState.normal)
        self.refuseButton.titleLabel?.font = UIFont(name: "Futura-Medium", size: 20)
        self.refuseButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.refuseButton.addTarget(self, action: #selector(self.refuseInvitation(_:)), for: UIControlEvents.touchUpInside)
        
        self.resizeToFit()
        
        self.dialogBoxView.addSubview(self.avatarFrameView)
        self.dialogBoxView.addSubview(self.usernameLabel)
        self.dialogBoxView.addSubview(self.messageLabel)
        self.dialogBoxView.addSubview(self.acceptButton)
        self.dialogBoxView.addSubview(self.refuseButton)
    }
    
    public func resizeToFit() {
        self.dialogBoxView.frame.size.height =  self.avatarFrameView.bounds.height / 2 + self.usernameLabel.bounds.height + self.messageLabel.bounds.height + self.acceptButton.bounds.height + self.refuseButton.bounds.height + self.margin * 5
        
        self.acceptButton.frame.size.width = max(self.dialogBoxView.frame.height - self.margin * 2, self.messageLabel.bounds.width)
        self.acceptButton.cornerRadius = 5
        self.acceptButton.topLeftCorner = true
        self.acceptButton.topRightCorner = true
        self.acceptButton.bottomLeftCorner = true
        self.acceptButton.bottomRightCorner = true
        self.acceptButton.maskToBounds = true
        
        self.refuseButton.frame.size.width = self.acceptButton.frame.size.width
        self.refuseButton.cornerRadius = 5
        self.refuseButton.topLeftCorner = true
        self.refuseButton.topRightCorner = true
        self.refuseButton.bottomLeftCorner = true
        self.refuseButton.bottomRightCorner = true
        self.refuseButton.maskToBounds = true
        self.refuseButton.bgColor = UIColor.red
        
        self.dialogBoxView.frame.size.width =  max(self.refuseButton.bounds.width, self.messageLabel.bounds.width) + self.margin * 2
        
        self.dialogBoxView.center = self.center
        self.avatarFrameView.center = CGPoint(x: self.dialogBoxView.bounds.midX, y: self.dialogBoxView.bounds.minY)
        
        self.usernameLabel.center = CGPoint(x: self.dialogBoxView.bounds.midX,
                                            y: self.dialogBoxView.bounds.minY +
                                                self.avatarFrameView.bounds.height / 2 +
                                                self.usernameLabel.bounds.midY +
                                                self.margin)
        
        self.messageLabel.center = CGPoint(x: self.dialogBoxView.bounds.midX,
                                           y: self.dialogBoxView.bounds.minY +
                                            self.avatarFrameView.bounds.height / 2 +
                                            self.usernameLabel.bounds.maxY +
                                            self.messageLabel.bounds.midY +
                                            self.margin * 2)
        
        self.acceptButton.center = CGPoint(x: self.dialogBoxView.bounds.midX,
                                         y: self.dialogBoxView.bounds.minY +
                                            self.avatarFrameView.bounds.height / 2 +
                                            self.usernameLabel.bounds.maxY +
                                            self.messageLabel.bounds.maxY +
                                            self.acceptButton.bounds.midY +
                                            self.margin * 3)
        
        self.refuseButton.center = CGPoint(x: self.dialogBoxView.bounds.midX,
                                         y: self.dialogBoxView.bounds.minY +
                                            self.avatarFrameView.bounds.height / 2 +
                                            self.usernameLabel.bounds.maxY +
                                            self.messageLabel.bounds.maxY +
                                            self.acceptButton.bounds.maxY +
                                            self.refuseButton.bounds.midY +
                                            self.margin * 4)
    }
    
    @IBAction private func acceptInvitation(_ sender: RoundButton) {
        if let action = self.acceptButtonAction {
            action()
        }
    }
    
    @IBAction private func refuseInvitation(_ sender: RoundButton) {
        if let action = self.refuseButtonAction {
            action()
        }
    }
}
