//
//  InviteView.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 06/01/2018.
//  Copyright © 2018 Apple Dev Academy. All rights reserved.
//

import UIKit

class InviteView: DialogBox {
    
    var dialogBoxView: RoundView
    var avatarFrameView: RoundView
    var usernameLabel: UILabel
    var messageLabel: UILabel
    var gameButton: RoundButton
    var chatButton: RoundButton
    var cancelButton: RoundButton
    
    var gameButtonAction: (()->Void)?
    var chatButtonAction: (()->Void)?
    var cancelButtonAction: (()->Void)?
    
    
    let margin: CGFloat = 16
    
    var avatarFrameViewSize: CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    override init(frame: CGRect) {
        self.dialogBoxView = RoundView()
        self.avatarFrameView = RoundView()
        self.usernameLabel = UILabel()
        self.messageLabel = UILabel()
        self.gameButton = RoundButton()
        self.chatButton = RoundButton()
        self.cancelButton = RoundButton()
        
        super.init(frame: frame)
        
        self.setUpSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.dialogBoxView = RoundView()
        self.avatarFrameView = RoundView()
        self.usernameLabel = UILabel()
        self.messageLabel = UILabel()
        self.gameButton = RoundButton()
        self.chatButton = RoundButton()
        self.cancelButton = RoundButton()
        
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
        self.messageLabel.text = NSLocalizedString("send_invitation", comment: "")
        self.messageLabel.sizeToFit()
        
        self.gameButton = RoundButton()
        self.gameButton.frame.size.height = 40
        self.gameButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.gameButton.setTitle(NSLocalizedString("game", comment: ""), for: UIControlState.normal)
        self.gameButton.titleLabel?.font = UIFont(name: "Futura-Medium", size: 20)
        self.gameButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.gameButton.addTarget(self, action: #selector(self.inviteForGame(_:)), for: UIControlEvents.touchUpInside)
        
        
        self.chatButton = RoundButton()
        self.chatButton.frame.size.height = self.gameButton.frame.size.height
        self.chatButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.chatButton.setTitle(NSLocalizedString("chat", comment: ""), for: UIControlState.normal)
        self.chatButton.titleLabel?.font = UIFont(name: "Futura-Medium", size: 20)
        self.chatButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.chatButton.addTarget(self, action: #selector(self.inviteForChat(_:)), for: UIControlEvents.touchUpInside)
        
        
        self.cancelButton = RoundButton()
        self.cancelButton.frame.size.height = self.gameButton.frame.size.height
        self.cancelButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.cancelButton.setTitle(NSLocalizedString("cancel", comment: ""), for: UIControlState.normal)
        self.cancelButton.titleLabel?.font = UIFont(name: "Futura-Medium", size: 20)
        self.cancelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.cancelButton.addTarget(self, action: #selector(self.cancelInvitation(_:)), for: UIControlEvents.touchUpInside)
        
        self.resizeToFit()
        
        self.dialogBoxView.addSubview(self.avatarFrameView)
        self.dialogBoxView.addSubview(self.usernameLabel)
        self.dialogBoxView.addSubview(self.messageLabel)
        self.dialogBoxView.addSubview(self.gameButton)
        self.dialogBoxView.addSubview(self.chatButton)
        self.dialogBoxView.addSubview(self.cancelButton)
    }
    
    public func resizeToFit() {
        self.dialogBoxView.frame.size.height =  self.avatarFrameView.bounds.height / 2 + self.usernameLabel.bounds.height + self.messageLabel.bounds.height + self.gameButton.bounds.height + self.chatButton.bounds.height + self.cancelButton.bounds.height + self.margin * 6
        
        self.gameButton.frame.size.width = self.dialogBoxView.frame.height - self.margin * 2
        self.gameButton.cornerRadius = 5
        self.gameButton.topLeftCorner = true
        self.gameButton.topRightCorner = true
        self.gameButton.bottomLeftCorner = true
        self.gameButton.bottomRightCorner = true
        self.gameButton.maskToBounds = true
        
        self.chatButton.frame.size.width = self.dialogBoxView.frame.height - self.margin * 2
        self.chatButton.cornerRadius = 5
        self.chatButton.topLeftCorner = true
        self.chatButton.topRightCorner = true
        self.chatButton.bottomLeftCorner = true
        self.chatButton.bottomRightCorner = true
        self.chatButton.maskToBounds = true
        
        
        self.cancelButton.frame.size.width = self.dialogBoxView.frame.height - self.margin * 2
        self.cancelButton.cornerRadius = 5
        self.cancelButton.topLeftCorner = true
        self.cancelButton.topRightCorner = true
        self.cancelButton.bottomLeftCorner = true
        self.cancelButton.bottomRightCorner = true
        self.cancelButton.maskToBounds = true
        self.cancelButton.bgColor = UIColor.red
        
        self.dialogBoxView.frame.size.width =  max(self.cancelButton.bounds.width, self.messageLabel.bounds.width) + self.margin * 2
        
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
        
        self.gameButton.center = CGPoint(x: self.dialogBoxView.bounds.midX,
                                           y: self.dialogBoxView.bounds.minY +
                                            self.avatarFrameView.bounds.height / 2 +
                                            self.usernameLabel.bounds.maxY +
                                            self.messageLabel.bounds.maxY +
                                            self.gameButton.bounds.midY +
                                            self.margin * 3)
        
        self.chatButton.center = CGPoint(x: self.dialogBoxView.bounds.midX,
                                           y: self.dialogBoxView.bounds.minY +
                                            self.avatarFrameView.bounds.height / 2 +
                                            self.usernameLabel.bounds.maxY +
                                            self.messageLabel.bounds.maxY +
                                            self.gameButton.bounds.maxY +
                                            self.chatButton.bounds.midY +
                                            self.margin * 4)
        
        self.cancelButton.center = CGPoint(x: self.dialogBoxView.bounds.midX,
                                           y: self.dialogBoxView.bounds.minY +
                                            self.avatarFrameView.bounds.height / 2 +
                                            self.usernameLabel.bounds.maxY +
                                            self.messageLabel.bounds.maxY +
                                            self.gameButton.bounds.maxY +
                                            self.chatButton.bounds.maxY +
                                            self.cancelButton.bounds.midY +
                                            self.margin * 5)
    }
    
    @IBAction private func inviteForGame(_ sender: RoundButton) {
        if let action = self.gameButtonAction {
            action()
        }
    }
    
    @IBAction private func inviteForChat(_ sender: RoundButton) {
        if let action = self.chatButtonAction {
            action()
        }
    }
    
    @IBAction private func cancelInvitation(_ sender: RoundButton) {
        if let action = self.cancelButtonAction {
            action()
        }
    }
}
