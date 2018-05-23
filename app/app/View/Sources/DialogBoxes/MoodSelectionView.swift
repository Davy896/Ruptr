//
//  MoodSelectionView.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 07/01/2018.
//  Copyright © 2018 Apple Dev Academy. All rights reserved.
//

import UIKit

class MoodSelectionView: UIView {
    
    var titleLabel: UILabel
    var moodAlertButtons: [(mood: Mood, button: RoundButton)]
    var lastClickedButton: UIButton?
    var finishButton: RoundButton
    var moodAlertButtonsAction: (() -> Void)
    var finishButtonAction: (() -> Void)
    
    static let margin: CGFloat = 16
    
    private override init(frame: CGRect) {
        self.titleLabel = UILabel()
        self.moodAlertButtons  = [(Mood.food, RoundButton()),
               (Mood.games, RoundButton()),
               (Mood.music, RoundButton()),
               (Mood.outdoor, RoundButton()),
               (Mood.shopping, RoundButton()),
               (Mood.sports, RoundButton())]
        self.finishButton = RoundButton()
        self.moodAlertButtonsAction = {}
        self.finishButtonAction = {}
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use factory method")
    }
    
    static func createMoodSelectionView(buttonSize: CGSize) -> MoodSelectionView {
        let alert = MoodSelectionView()
        for (_, button) in alert.moodAlertButtons {
            button.frame.size = buttonSize
            button.cornerRadius = 5
            button.bottomLeftCorner = true
            button.bottomRightCorner = true
            button.topLeftCorner = true
            button.topRightCorner = true
            button.maskToBounds = true
        }
        
        alert.finishButton.frame.size.height = 50
        
        alert.frame.size = CGSize(width: max(alert.moodAlertButtons[0].button.bounds.width * 3 + self.margin,
                                             alert.titleLabel.bounds.width) + self.margin * 2,
                                  height: alert.titleLabel.bounds.height +
                                    alert.moodAlertButtons[0].button.bounds.height * 2 +
                                    alert.finishButton.bounds.height +
                                    self.margin * 5)
        
        alert.finishButton.frame.size.width = alert.bounds.width - self.margin * 2
        alert.finishButton.cornerRadius = 5
        alert.finishButton.bottomLeftCorner = true
        alert.finishButton.bottomRightCorner = true
        alert.finishButton.topLeftCorner = true
        alert.finishButton.topRightCorner = true
        alert.finishButton.maskToBounds = true
        alert.finishButton.bgColor = Colours.backgroundSecondary
        
        alert.titleLabel.center = CGPoint(x: alert.bounds.midX,
                                            y: alert.bounds.minY +
                                                alert.titleLabel.bounds.midY +
                                                self.margin)
        alert.moodAlertButtons[0].button.center = CGPoint(x: alert.moodAlertButtons[0].button.bounds.midX + self.margin,
                                                          y: alert.bounds.minY +
                                                            alert.titleLabel.bounds.maxY +
                                                            alert.moodAlertButtons[0].button.bounds.midY
                                                            + self.margin * 2)
        
        alert.moodAlertButtons[1].button.center = CGPoint(x: alert.bounds.midX,
                                                          y: alert.bounds.minY +
                                                            alert.titleLabel.bounds.maxY +
                                                            alert.moodAlertButtons[0].button.bounds.midY
                                                            + self.margin * 2)
        
        alert.moodAlertButtons[2].button.center = CGPoint(x: alert.bounds.maxX - alert.moodAlertButtons[0].button.bounds.midX - self.margin,
                                                          y: alert.bounds.minY +
                                                            alert.titleLabel.bounds.maxY +
                                                            alert.moodAlertButtons[0].button.bounds.midY
                                                            + self.margin * 2)
        
        alert.moodAlertButtons[3].button.center = CGPoint(x: alert.moodAlertButtons[0].button.bounds.midX + self.margin,
                                                          y: alert.bounds.minY +
                                                            alert.titleLabel.bounds.maxY +
                                                            alert.moodAlertButtons[0].button.bounds.maxY * 1.5
                                                            + self.margin * 3)
        
        alert.moodAlertButtons[4].button.center = CGPoint(x: alert.bounds.midX,
                                                          y: alert.bounds.minY +
                                                            alert.titleLabel.bounds.maxY +
                                                            alert.moodAlertButtons[0].button.bounds.maxY * 1.5
                                                            + self.margin * 3)
        
        alert.moodAlertButtons[5].button.center = CGPoint(x: alert.bounds.maxX - alert.moodAlertButtons[0].button.bounds.midX - self.margin,
                                                          y: alert.bounds.minY +
                                                            alert.titleLabel.bounds.maxY +
                                                            alert.moodAlertButtons[0].button.bounds.maxY * 1.5
                                                            + self.margin * 3)
        
        alert.finishButton.center = CGPoint(x: alert.bounds.midX,
                                             y: alert.bounds.minY +
                                                alert.titleLabel.bounds.maxY +
                                                alert.moodAlertButtons[0].button.bounds.maxY * 2 +
                                                alert.finishButton.bounds.midY +
                                                self.margin * 4)
        
        return alert
    }
    
    private func setupSubviews() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 5
        
        self.titleLabel.text = NSLocalizedString("select_mood_alert", comment: "")
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.font = UIFont(name: "Futura-Medium", size: 17)
        self.titleLabel.sizeToFit()
        self.addSubview(titleLabel)
        
        for (key, button) in moodAlertButtons {
            button.backgroundColor = UIColor.lightGray
            button.addTarget(self, action: #selector(self.chooseMoodForProfile(_:)), for: UIControlEvents.touchUpInside)
            
            switch key {
            case Mood.food:
                button.setBackgroundImage(UIImage(named: "food"), for: UIControlState.normal)
                button.setBackgroundImage(UIImage(named: "food_selected"), for: UIControlState.disabled)
                break
            case Mood.games:
                button.setBackgroundImage(UIImage(named: "games"), for: UIControlState.normal)
                button.setBackgroundImage(UIImage(named: "games_selected"), for: UIControlState.disabled)
                break
            case Mood.music:
                button.setBackgroundImage(UIImage(named: "music"), for: UIControlState.normal)
                button.setBackgroundImage(UIImage(named: "music_selected"), for: UIControlState.disabled)
                break
            case Mood.outdoor:
                button.setBackgroundImage(UIImage(named: "outdoors"), for: UIControlState.normal)
                button.setBackgroundImage(UIImage(named: "outdoors_selected"), for: UIControlState.disabled)
                break
            case Mood.shopping:
                button.setBackgroundImage(UIImage(named: "shopping"), for: UIControlState.normal)
                button.setBackgroundImage(UIImage(named: "shopping_selected"), for: UIControlState.disabled)
                break
            case Mood.sports:
                button.setBackgroundImage(UIImage(named: "sports"), for: UIControlState.normal)
                button.setBackgroundImage(UIImage(named: "sports_selected"), for: UIControlState.disabled)
                break
            }
            
            self.addSubview(button)
        }
        
        self.finishButton.backgroundColor = UIColor.lightGray
        self.finishButton.addTarget(self, action: #selector(self.selectMood(_:)), for: UIControlEvents.touchUpInside)
        self.finishButton.setTitle(NSLocalizedString("done", comment: ""), for: UIControlState.normal)
        self.finishButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.finishButton.titleLabel?.font = UIFont(name: "Futura-Medium", size: 20)
        self.addSubview(self.finishButton)
    }
    
    @IBAction private func chooseMoodForProfile(_ sender: UIButton) {
        self.lastClickedButton = sender
        self.moodAlertButtonsAction()
    }
    
    @IBAction private func selectMood(_ sender: UIButton) {
        self.finishButtonAction()
    }
}
