//
//  ViewController.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 10/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit
import ConnectivityServices
import MultipeerConnectivity

class ViewController: UIViewController, ProfileServiceDelegate, BroadcastServiceDelegate, ChatServiceDelegate {
    
    private let profile: UserProfile
    private let profileService: ProfileService
    private let broadcastService: BroadcastService
    private let chatService: ChatService
    
    @IBOutlet weak var connectedDevices: UITextView!
    @IBOutlet weak var broadcastedMessage: UITextView!
    @IBOutlet weak var messageToBeBroadcasted: UITextView!
    
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.profile = UserProfile(id: String.randomAlphaNumericString(length: 20), userName: "Lucas", avatar: "avatar0", isVisible: true)
        self.profileService = ProfileService(profile: self.profile)
        self.broadcastService = BroadcastService(profile: self.profile)
        self.chatService = ChatService(profile: self.profile)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.profile = UserProfile(id: String.randomAlphaNumericString(length: 20), userName: "Lucas", avatar: "avatar0", isVisible: true)
        self.profileService = ProfileService(profile: self.profile)
        self.broadcastService = BroadcastService(profile: self.profile)
        self.chatService = ChatService(profile: self.profile)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileService.delegate = self
        self.broadcastService.delegate = self
        self.chatService.delegate = self
        self.updateVisibility()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateVisibility() {
        if (self.profile.isVisible) {
            self.profileService.serviceAdvertiser.startAdvertisingPeer()
            self.profileService.serviceBrowser.startBrowsingForPeers()
            
            self.broadcastService.serviceAdvertiser.startAdvertisingPeer()
            self.broadcastService.serviceBrowser.startBrowsingForPeers()
            
            self.chatService.serviceAdvertiser.startAdvertisingPeer()
            self.chatService.serviceBrowser.startBrowsingForPeers()
        } else {
            self.profileService.serviceAdvertiser.stopAdvertisingPeer()
            self.profileService.serviceBrowser.stopBrowsingForPeers()
            
            self.broadcastService.serviceAdvertiser.stopAdvertisingPeer()
            self.broadcastService.serviceBrowser.stopBrowsingForPeers()
            
            self.chatService.serviceAdvertiser.stopAdvertisingPeer()
            self.chatService.serviceBrowser.stopBrowsingForPeers()
        }
    }
    
    @IBAction func broadcastMessage(_ sender: UIButton) {
        broadcastService.broadcastMessage(message: messageToBeBroadcasted.text)
    }
    
    func connectedDevicesChanged(manager: ProfileService, connectedDevices: [String]) {
//        OperationQueue.main.addOperation {
//            for device in connectedDevices {
//                self.connectedDevices.text =  "\(self.connectedDevices.text!)\(device)\n"
//            }
//        }
    }
    
    func receiveBroadcastedMessage(manager: BroadcastService, message: String) {
//        OperationQueue.main.addOperation {
//            self.broadcastedMessage.text = message
//        }
    }
    var aa: MCPeerID?
    
    func peerFound(withId id: MCPeerID) {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        button.setTitle(chatService.peers[0].displayName, for: .normal)
        button.isHidden = false
        button.isEnabled = true
        button.addTarget(self, action: #selector(ViewController.inviteForChat(sender:)), for: .touchUpInside)
        aa = id
        self.view.addSubview(button)
    }
    
    @IBAction func inviteForChat(sender: UIButton!){
        invitePeer(withId: aa!)
    }
    
    func invitePeer(withId id: MCPeerID) {
        chatService.serviceBrowser.invitePeer(id, to: chatService.session, withContext: nil, timeout: 20)
    }
    
    func peerLost(withId id: MCPeerID) {
        if (self.view.subviews.count > 0) {
            self.view.subviews[0].removeFromSuperview()
        }
    }
    
    func handleInvitation(from: String) {
        let alert = UIAlertController(title: "Invitation", message: "received an invitation", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        OperationQueue.main.addOperation {
            self.present(alert, animated: true, completion: nil)
        }
    }
}


