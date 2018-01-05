//
//  File.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 04/01/2018.
//  Copyright © 2018 Apple Dev Academy. All rights reserved.
//

import UIKit

class PromptView: UIView {
    
    let margin: CGFloat = 16
    
    var invitationView: RoundView
    var avatarFrameView: RoundView
    var avatarDisplayed: AvatarPlanetButton
    var usernameLabel: UILabel
    var messageLabel: UILabel
    var gameButton: RoundButton
    var chatButton: RoundButton
    var cancelButton: RoundButton
    
    var invitationViewSize: CGSize {
        return CGSize(width: 308, height: 300)
    }
    
    var avatarFrameViewSize: CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    override var frame: CGRect {
        didSet {
            self.resizeSubviews()
        }
    }
    
    private var alphaObserverHelper: Bool = true //Stops observer from becoming recursive
    
    override var alpha: CGFloat {
        didSet {
            if (self.alphaObserverHelper) {
                self.invitationView.alpha = self.alpha
                self.avatarFrameView.alpha = self.alpha
                self.backgroundColor = self.alpha > 0.7 ? self.backgroundColor?.withAlphaComponent(0.7) : self.backgroundColor?.withAlphaComponent(self.alpha)
                self.alphaObserverHelper = false
                self.alpha = 1
            } else {
                self.alphaObserverHelper = true
            }
        }
    }
    
    override init(frame: CGRect) {
        self.invitationView = RoundView()
        self.avatarFrameView = RoundView()
        self.avatarDisplayed = AvatarPlanetButton()
        self.usernameLabel = UILabel()
        self.messageLabel = UILabel()
        self.gameButton = RoundButton()
        self.chatButton = RoundButton()
        self.cancelButton = RoundButton()
        
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.invitationView = RoundView()
        self.avatarFrameView = RoundView()
        self.avatarDisplayed = AvatarPlanetButton()
        self.usernameLabel = UILabel()
        self.messageLabel = UILabel()
        self.gameButton = RoundButton()
        self.chatButton = RoundButton()
        self.cancelButton = RoundButton()
        
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override func didMoveToSuperview() {
        if let view = self.superview {
            self.frame = view.frame
        }
    }
    
    private func setup() {
        self.addSubview(invitationView)
        self.addSubview(avatarFrameView)
        
        self.avatarFrameView.addSubview(self.avatarDisplayed)
        
        self.invitationView.addSubview(self.usernameLabel)
        self.invitationView.addSubview(self.messageLabel)
        self.invitationView.addSubview(self.gameButton)
        self.invitationView.addSubview(self.chatButton)
        self.invitationView.addSubview(self.cancelButton)
        
        self.backgroundColor = UIColor.black
        
        self.invitationView.frame.size = self.invitationViewSize
        self.invitationView.center = self.center
        self.invitationView.backgroundColor = UIColor.white
        self.invitationView.cornerRadius = 5
        self.invitationView.maskToBounds = true
        self.invitationView.autoresizesSubviews = true
        
        self.avatarFrameView.frame.size = self.avatarFrameViewSize
        self.avatarFrameView.center = CGPoint(x: self.frame.width / 2, y: self.invitationView.frame.origin.y)
        self.avatarFrameView.backgroundColor = UIColor.white
        self.avatarFrameView.alpha = 0
        self.avatarFrameView.circle = true
        
        self.avatarDisplayed.isUserInteractionEnabled = false
        self.avatarDisplayed.alpha = 1
        self.avatarDisplayed.frame.size = self.avatarFrameView.frame.size - 5
        self.avatarDisplayed.center = self.avatarFrameView.center
        
        self.usernameLabel.frame = CGRect(x: 16, y: 32, width: 276, height: 32)
        self.usernameLabel.font = UIFont(name: "Futura-Medium", size: 24)
        self.usernameLabel.adjustsFontSizeToFitWidth = true
        self.usernameLabel.textAlignment = NSTextAlignment.center
        self.usernameLabel.textColor = UIColor.black
        self.usernameLabel.text = "USER_NAME"
        
        self.messageLabel.frame = CGRect(x: self.usernameLabel.frame.origin.x,
                                         y: self.usernameLabel.frame.origin.y + self.usernameLabel.frame.height + margin,
                                         width: self.usernameLabel.frame.size.width,
                                         height: self.usernameLabel.frame.size.height)
        self.messageLabel.font = UIFont(name: "Futura-Medium", size: 17)
        self.messageLabel.adjustsFontSizeToFitWidth = true
        self.messageLabel.textColor = UIColor.black
        self.messageLabel.textAlignment = NSTextAlignment.center
        self.messageLabel.text = NSLocalizedString("send_invitation", comment: "")
        
        self.gameButton.frame = CGRect(x: 16, y: 129, width: 276, height: 38)
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
        
        
        self.chatButton.frame = CGRect(x: self.gameButton.frame.origin.x,
                                       y: self.gameButton.frame.origin.y + self.gameButton.frame.height + margin,
                                       width: self.gameButton.frame.size.width,
                                       height: self.gameButton.frame.size.height)
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
        
        self.cancelButton.frame = CGRect(x: self.gameButton.frame.origin.x,
                                         y: self.gameButton.frame.origin.y + (self.gameButton.frame.height + margin) * 2,
                                         width: self.gameButton.frame.size.width,
                                         height: self.gameButton.frame.size.height)
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
    }
    
    private func resizeSubviews() {
        self.invitationView.frame.size = self.invitationViewSize
        self.invitationView.center = self.center
        
        self.avatarFrameView.frame.size = self.avatarFrameViewSize
        self.avatarFrameView.center = CGPoint(x: self.frame.width / 2, y: self.invitationView.frame.origin.y)
        
        self.usernameLabel.frame = CGRect(x: 16, y: 32, width: 276, height: 32)
        self.messageLabel.frame = CGRect(x: self.usernameLabel.frame.origin.x,
                                         y: self.usernameLabel.frame.origin.y + self.usernameLabel.frame.height + margin,
                                         width: self.usernameLabel.frame.size.width,
                                         height: self.usernameLabel.frame.size.height)
        
        self.gameButton.frame = CGRect(x: 16, y: 129, width: 276, height: 38)
        self.chatButton.frame = CGRect(x: self.gameButton.frame.origin.x,
                                       y: self.gameButton.frame.origin.y + self.gameButton.frame.height + margin,
                                       width: self.gameButton.frame.size.width,
                                       height: self.gameButton.frame.size.height)
        self.cancelButton.frame = CGRect(x: self.gameButton.frame.origin.x,
                                         y: self.gameButton.frame.origin.y + (self.gameButton.frame.height + margin) * 2,
                                         width: self.gameButton.frame.size.width,
                                         height: self.gameButton.frame.size.height)
        
    }
}

