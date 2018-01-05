//
//  AvatarPlanetView.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 19/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class AvatarPlanetButton: RoundButton {
    
    var hairImageView: RoundImgView
    var faceImageView: RoundImgView
    var userNameLabel: RoundLabel
    var userProfile: UserProfile?
    
    override var frame: CGRect {
        didSet {
            self.circle = true
            self.hairImageView.frame.size = self.frame.size
            self.hairImageView.circle = true
            self.faceImageView.frame.size = self.frame.size
            self.faceImageView.circle = true
        }
    }
    
    override var bounds: CGRect {
        didSet {
            self.circle = true
            self.hairImageView.frame.size = self.frame.size
            self.hairImageView.circle = true
            self.faceImageView.frame.size = self.frame.size
            self.faceImageView.circle = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.hairImageView = RoundImgView()
        self.faceImageView = RoundImgView()
        self.userNameLabel = RoundLabel(frame: CGRect(x: 0, y: 72, width: 110, height: 21))
        super.init(coder: aDecoder)
        self.setupSubviews()
    }
    
    
    override init(frame: CGRect) {
        self.hairImageView = RoundImgView()
        self.faceImageView = RoundImgView()
        self.userNameLabel = RoundLabel(frame: CGRect(x: 0, y: 72, width: 110, height: 21))
        super.init(frame: frame)
        self.setupSubviews()
    }
    
     convenience init() {
        self.init(frame: CGRect.zero)
        self.setupSubviews()
    }
        
    
    private func setupSubviews() {
        self.hairImageView.frame.size = self.frame.size
        self.hairImageView.circle = true
        self.hairImageView.maskToBounds = true
        
        self.faceImageView.frame.size = self.frame.size
        self.faceImageView.circle = true
        self.faceImageView.maskToBounds = true
        
        self.userNameLabel.cornerRadius = 5
        self.userNameLabel.maskToBounds = true
        
        self.addSubview(self.hairImageView)
        self.addSubview(self.faceImageView)
        self.addSubview(self.userNameLabel)
        
        self.bringSubview(toFront: self.hairImageView)
        
        self.circle = true
        self.maskToBounds = true
        self.bgColor = UIColor.clear
        self.alpha = 0
    }
    
    public func cloneAttributesFrom(listTableViewCell cell: ListTableViewCell) {
        self.userProfile = cell.userProfile
        self.hairImageView.image = cell.hairImageView.image
        self.faceImageView.image = cell.faceImageView.image
        self.faceImageView.backgroundColor = cell.faceImageView.backgroundColor
        self.userNameLabel.text = cell.userNameLabel.text
    }
    
    public static func createAvatarButton(from profile: UserProfile, size: CGSize) -> AvatarPlanetButton {
        let button = AvatarPlanetButton(frame: CGRect(origin: CGPoint.zero, size: size))
        button.userProfile = profile
        button.hairImageView.image = profile.avatarHair
        button.faceImageView.image = profile.avatarFace
        button.faceImageView.backgroundColor = profile.avatarSkin
        button.userNameLabel.text = profile.username
        return button
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
