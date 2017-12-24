//
//  AvatarPlanetView.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 19/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit

class AvatarPlanetButton: RoundButton {

    var hairImageView: RoundImgView!
    var faceImageView: RoundImgView!
    var userNameLabel: RoundLabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       self.setupSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }

    private func setupSubviews() {
        self.hairImageView = RoundImgView()
        self.hairImageView.frame.size = self.frame.size
        self.hairImageView.circle = true
        self.hairImageView.maskToBounds = true
        
        self.faceImageView = RoundImgView()
        self.faceImageView.frame.size = self.frame.size
        self.faceImageView.circle = true
        self.faceImageView.maskToBounds = true

        self.userNameLabel = RoundLabel(frame: CGRect(x: 0, y: 72, width: 110, height: 21))
        self.userNameLabel.cornerRadius = 5
        self.userNameLabel.maskToBounds = true
        
        self.addSubview(hairImageView)
        self.addSubview(faceImageView)
        self.addSubview(userNameLabel)
        
        self.circle = true
        self.maskToBounds = true
        self.borderWidth = 5
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
