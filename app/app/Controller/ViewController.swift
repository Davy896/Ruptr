//
//  ViewController.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 10/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit
import ConnectivityServices

class ViewController: UIViewController, ProfileServiceDelegate, BroadcastServiceDelegate {
    
    private let profile: UserProfile
    private let profileService: ProfileService
    private let broadcastService: BroadcastService
    
    @IBOutlet weak var connectedDevices: UITextView!
    @IBOutlet weak var broadcastedMessage: UITextView!
    @IBOutlet weak var messageToBeBroadcasted: UITextView!
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.profile = UserProfile(id: String.randomAlphaNumericString(length: 20), userName: "Lucas", avatar: "avatar0")
        self.profileService = ProfileService(profile: self.profile)
        self.broadcastService = BroadcastService(profile: self.profile)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // This is also necessary when extending the superclass.
    required init?(coder aDecoder: NSCoder) {
        self.profile = UserProfile(id: String.randomAlphaNumericString(length: 20), userName: "Lucas", avatar: "avatar0")
        self.profileService = ProfileService(profile: self.profile)
        self.broadcastService = BroadcastService(profile: self.profile)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.profileService.delegate = self
        self.broadcastService.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func broadcastMessage(_ sender: UIButton) {
        broadcastService.broadcastMessage(message: messageToBeBroadcasted.text)
    }
    
    func connectedDevicesChanged(manager: ProfileService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            for device in connectedDevices {
                self.connectedDevices.text =  "\(self.connectedDevices.text!)\(device)\n"
            }
        }
    }
    
    func receiveBroadcastedMessage(manager: BroadcastService, message: String) {
        OperationQueue.main.addOperation {
            self.broadcastedMessage.text = message
        }
    }
}

