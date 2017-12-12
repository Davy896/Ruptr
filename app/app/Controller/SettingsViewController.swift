//
//  ThirdViewController.swift
//  FirstMini
//
//  Created by Alessio Tortello on 11/12/2017.
//  Copyright © 2017 Alessio Tortello. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var statusButtons: [UIButton]!
    @IBOutlet var moodButtons: [UIButton]!
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
        setupColours(forButton: 3)
        for button in moodButtons {
            button.backgroundColor = UIColor.blue
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeStatus(_ sender: UIButton) {
        setupColours(forButton: sender.tag)
    }
    
    func setupColours(forButton tag: Int) {
        if (tag >= statusColours.count) {
            return
        }
        
        for button in statusButtons {
            if (button.tag == tag) {
                button.backgroundColor = statusColours[tag]
                statusTextView.backgroundColor = statusColours[tag]
                statusTextView.text = statusDescriptions[tag]
            } else{
                button.backgroundColor = deselectedColour
            }
        }
    }
}
