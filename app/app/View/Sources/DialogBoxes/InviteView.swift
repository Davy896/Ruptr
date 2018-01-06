//
//  InviteView.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 06/01/2018.
//  Copyright © 2018 Apple Dev Academy. All rights reserved.
//

import UIKit

class InviteView: UIView {
    
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
    
    var dialogBoxViewSize: CGSize {
        return CGSize(width: 308, height: 300)
    }
    
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
        self.dialogBoxView.frame.size = self.dialogBoxViewSize
        self.dialogBoxView.center = self.center
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
        
        self.usernameLabel = UILabel(frame: CGRect(x: 16, y: 40, width: 276, height: 32))
        self.usernameLabel.font = UIFont(name: "Futura-Medium", size: 24)
        self.usernameLabel.adjustsFontSizeToFitWidth = true
        self.usernameLabel.textAlignment = NSTextAlignment.center
        self.usernameLabel.textColor = UIColor.black
        self.usernameLabel.text = "USER_NAME"
        
        self.messageLabel = UILabel(frame: CGRect(x: self.usernameLabel.frame.origin.x,
                                                  y: self.usernameLabel.frame.origin.y + self.usernameLabel.frame.height + self.margin,
                                                  width: self.usernameLabel.frame.size.width,
                                                  height: self.usernameLabel.frame.size.height))
        self.messageLabel.font = UIFont(name: "Futura-Medium", size: 17)
        self.messageLabel.adjustsFontSizeToFitWidth = true
        self.messageLabel.textColor = UIColor.black
        self.messageLabel.textAlignment = NSTextAlignment.center
        self.messageLabel.text = NSLocalizedString("send_invitation", comment: "")
        
        self.gameButton = RoundButton(frame: CGRect(x: 16, y: 129, width: 276, height: 38))
        self.gameButton.cornerRadius = 5
        self.gameButton.topLeftCorner = true
        self.gameButton.topRightCorner = true
        self.gameButton.bottomLeftCorner = true
        self.gameButton.bottomRightCorner = true
        self.gameButton.maskToBounds = true
        self.gameButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.gameButton.setTitle(NSLocalizedString("game", comment: ""), for: UIControlState.normal)
        self.gameButton.titleLabel?.font = UIFont(name: "Futura-Medium", size: 20)
        self.gameButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.gameButton.addTarget(self, action: #selector(self.inviteForGame(_:)), for: UIControlEvents.touchUpInside)
        
        
        self.chatButton = RoundButton(frame: CGRect(x: self.gameButton.frame.origin.x,
                                                    y: self.gameButton.frame.origin.y + self.gameButton.frame.height + self.margin,
                                                    width: self.gameButton.frame.size.width,
                                                    height: self.gameButton.frame.size.height))
        self.chatButton.cornerRadius = 5
        self.chatButton.topLeftCorner = true
        self.chatButton.topRightCorner = true
        self.chatButton.bottomLeftCorner = true
        self.chatButton.bottomRightCorner = true
        self.chatButton.maskToBounds = true
        self.chatButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.chatButton.setTitle(NSLocalizedString("chat", comment: ""), for: UIControlState.normal)
        self.chatButton.titleLabel?.font = UIFont(name: "Futura-Medium", size: 20)
        self.chatButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.chatButton.addTarget(self, action: #selector(self.inviteForChat(_:)), for: UIControlEvents.touchUpInside)
        
        
        self.cancelButton = RoundButton(frame: CGRect(x: self.gameButton.frame.origin.x,
                                                      y: self.gameButton.frame.origin.y + (self.gameButton.frame.height + self.margin) * 2,
                                                      width: self.gameButton.frame.size.width,
                                                      height: self.gameButton.frame.size.height))
        self.cancelButton.cornerRadius = 5
        self.cancelButton.topLeftCorner = true
        self.cancelButton.topRightCorner = true
        self.cancelButton.bottomLeftCorner = true
        self.cancelButton.bottomRightCorner = true
        self.cancelButton.maskToBounds = true
        self.cancelButton.bgColor = UIColor.red
        self.cancelButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.cancelButton.setTitle(NSLocalizedString("cancel", comment: ""), for: UIControlState.normal)
        self.cancelButton.titleLabel?.font = UIFont(name: "Futura-Medium", size: 20)
        self.cancelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.cancelButton.addTarget(self, action: #selector(self.refuseInvitation(_:)), for: UIControlEvents.touchUpInside)
        
        self.dialogBoxView.addSubview(self.avatarFrameView)
        self.dialogBoxView.addSubview(self.usernameLabel)
        self.dialogBoxView.addSubview(self.messageLabel)
        self.dialogBoxView.addSubview(self.gameButton)
        self.dialogBoxView.addSubview(self.chatButton)
        self.dialogBoxView.addSubview(self.cancelButton)
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
    
    @IBAction private func refuseInvitation(_ sender: RoundButton) {
        if let action = self.cancelButtonAction {
            action()
        }
    }
}
