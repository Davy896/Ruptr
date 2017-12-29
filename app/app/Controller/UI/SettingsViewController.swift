//
//  ThirdViewController.swift
//  FirstMini
//
//  Created by Alessio Tortello on 11/12/2017.
//  Copyright © 2017 Alessio Tortello. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var avatarHairImageView: RoundImgView!
    @IBOutlet weak var avatarFaceImageView: RoundImgView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusView: RoundView!
    @IBOutlet var statusButtons: [RoundButton]!
    @IBOutlet var moodButtons: [RoundButton]!
    @IBOutlet weak var statusTextView: UITextView!
    
    let statusColours: [UIColor] = [UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1), // ghost
        UIColor(red: 255/255, green: 100/255, blue: 100/255, alpha: 1), // chatful
        UIColor(red: 100/255, green: 255/255, blue: 100/255, alpha: 1), // open
        UIColor(red: 100/255, green: 100/255, blue: 255/255, alpha: 1)] // playful
    let deselectedColour: UIColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    let ghostString = NSLocalizedString("ghost", comment: "")
    let statusDescriptions: [String] = ["""
                                                Ghost
                                        Nobody can see you
                                        """, // ghost
        """
                                                Chatful
                                        Can't play games
                                        """, // chatful
        """
                                                Open
                                        Down for anything, kinky!
                                        """, // open
        """
                                                Playful
                                        Can't skip games
                                        """] // playful
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIViewController.setViewBackground(for: self)
        self.avatarHairImageView.image = ServiceManager.instance.userProfile.avatarHair
        self.avatarHairImageView.backgroundColor = UIColor.clear
        self.avatarFaceImageView.image = ServiceManager.instance.userProfile.avatarFace
        self.avatarFaceImageView.backgroundColor = ServiceManager.instance.userProfile.avatarSkin
        self.usernameLabel.text = ServiceManager.instance.userProfile.username
        self.setupColours(forButton: 3)
        for i in 0 ... self.moodButtons.count - 1 {
            self.moodButtons[i].backgroundColor = UIColor.blue
            self.moodButtons[i].setTitle(ServiceManager.instance.userProfile.moods[i].enumToString, for: UIControlState.normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeStatus(_ sender: UIButton) {
        self.setupColours(forButton: sender.tag)
        if sender == statusButtons[0] {
            ServiceManager.instance.chatService.isActive = false
        } else {
            ServiceManager.instance.chatService.isActive = true
        }
    }
    
    func setupColours(forButton tag: Int) {
        if (tag >= self.statusColours.count) {
            return
        }
        self.statusView.backgroundColor = self.deselectedColour
        self.statusTextView.backgroundColor = self.deselectedColour
        
        for button in self.statusButtons {
            button.backgroundColor = self.deselectedColour
        }
        
        for button in self.statusButtons {
            
            if (button.tag == tag) {
                UIView.animate(withDuration: 0.25, animations: {
                    self.statusView.backgroundColor = self.statusColours[tag]
                    button.backgroundColor = self.statusColours[tag]
                    self.statusTextView.backgroundColor = self.statusColours[tag]
                    self.statusTextView.text = self.statusDescriptions[tag]
                }, completion: nil)
                
            } else{
                button.backgroundColor = self.deselectedColour
            }
            
            button.bottomRightCorner = false
            button.bottomLeftCorner = false
        }
        
        switch tag {
        case 0:
            self.statusButtons[1].bottomLeftCorner = true
            break
        case 1:
            self.statusButtons[0].bottomRightCorner = true
            self.statusButtons[2].bottomLeftCorner = true
            break
        case 2:
            self.statusButtons[1].bottomRightCorner = true
            self.statusButtons[3].bottomLeftCorner = true
            break
        case 3:
            self.statusButtons[2].bottomRightCorner = true
            break
        default:
            break
        }
    }
}
