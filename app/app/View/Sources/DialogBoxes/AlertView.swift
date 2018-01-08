//
//  AlertView.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 06/01/2018.
//  Copyright © 2018 Apple Dev Academy. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    var titleLabel: UILabel
    var messageLabel: UILabel
    var dismissButton: RoundButton
    
    var action: (()->Void)
    
    static let margin: CGFloat = 16
    
    private override init(frame: CGRect) {
        self.titleLabel = UILabel()
        self.messageLabel = UILabel()
        self.dismissButton = RoundButton()
        self.action = {}
        
        super.init(frame: frame)
        
        self.action = { self.removeFromSuperview() }
        self.dismissButton.addTarget(self, action: #selector(self.buttonAction(_:)), for: UIControlEvents.touchUpInside)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 5
        self.titleLabel.font = UIFont(name: "Futura-Bold", size: 24)
        self.messageLabel.font = UIFont(name: "Futura-Medium", size: 17)
        self.dismissButton.titleLabel?.font = UIFont(name: "Futura-Medium", size: 17)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use factory method")
    }
    
    @IBAction func buttonAction(_ sender: RoundButton) {
        self.action()
    }
    
    static func createAlert(title: String? = nil, message: String, buttonText: String = "OK", action: (()->Void)? = nil) -> AlertView {
        let alert = AlertView()
        
        alert.addSubview(alert.messageLabel)
        alert.addSubview(alert.dismissButton)
        
        alert.messageLabel.text = message
        alert.messageLabel.sizeToFit()
        
        alert.dismissButton.setTitle(buttonText, for: UIControlState.normal)
        alert.dismissButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        alert.dismissButton.sizeToFit()
        alert.dismissButton.frame.size.height = alert.dismissButton.frame.height < 50 ? 50 : alert.dismissButton.frame.height
        alert.dismissButton.frame.size.width = alert.dismissButton.frame.height < 200 ? 200 : alert.dismissButton.frame.height
        alert.dismissButton.cornerRadius = 5
        alert.dismissButton.bgColor = Colours.backgroundSecondary
        alert.dismissButton.bottomLeftCorner = true
        alert.dismissButton.bottomRightCorner = true
        alert.dismissButton.topLeftCorner = true
        alert.dismissButton.topRightCorner = true
        alert.dismissButton.maskToBounds = true
        if let action = action {
            alert.action = action
        }
        
        alert.frame.size = CGSize(width: max(alert.dismissButton.bounds.width, alert.messageLabel.bounds.width) + margin * 2,
                                  height: alert.dismissButton.bounds.height + alert.messageLabel.bounds.height + margin * 4)
        
        if let title = title {
            alert.titleLabel.text = title
            alert.titleLabel.sizeToFit()
            alert.addSubview(alert.titleLabel)
            
            alert.frame.size.width = max(alert.frame.size.width, alert.titleLabel.frame.width + self.margin * 2)
            alert.frame.size.height += alert.titleLabel.frame.height
            alert.titleLabel.center = CGPoint(x: alert.bounds.midX,
                                              y: alert.bounds.minY +
                                                alert.titleLabel.bounds.midY +
                                                self.margin)
            alert.messageLabel.center = CGPoint(x: alert.bounds.midX,
                                                y: alert.bounds.minY +
                                                    alert.titleLabel.bounds.maxY +
                                                    alert.messageLabel.bounds.midY +
                                                    self.margin * 2)
            alert.dismissButton.center = CGPoint(x: alert.bounds.midX,
                                                 y: alert.bounds.minY +
                                                    alert.titleLabel.bounds.maxY +
                                                    alert.messageLabel.bounds.maxY +
                                                    alert.dismissButton.bounds.midY +
                                                    self.margin * 3)
            return alert
        }
        
        alert.messageLabel.center = CGPoint(x: alert.bounds.midX,
                                            y: alert.bounds.minY + alert.messageLabel.bounds.midY + self.margin)
        alert.dismissButton.center = CGPoint(x: alert.bounds.midX,
                                             y: alert.bounds.minY + alert.messageLabel.bounds.maxY + alert.dismissButton.bounds.midY + self.margin * 2)
        return alert
    }
}
