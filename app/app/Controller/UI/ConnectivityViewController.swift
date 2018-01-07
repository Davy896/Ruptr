//
//  ConnectivityViewController.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 12/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit
import ConnectivityServices
import MultipeerConnectivity
import SCLAlertView

class ConnectivityViewController: UIViewController, ChatServiceDelegate {
    
    @IBOutlet var transparencyView: UIView!
    @IBOutlet var inviteView: InviteView!
    @IBOutlet var invitationView: InvitationView!
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    var isGame = true
    var isInviting = false
    
    var people: [UserProfile] = []
    var userBeingInvited: UserProfile?
    var idOfUserBeingInvited: MCPeerID?
    
    let alertAppearence = SCLAlertView.SCLAppearance(kCircleIconHeight: -56,
                                                     kTitleFont: UIFont(name: "Futura-Bold", size: 17)!,
                                                     kTextFont: UIFont(name: "Futura-Medium", size: 14)!,
                                                     kButtonFont: UIFont(name: "Futura-Medium", size: 17)!,
                                                     showCloseButton: false,
                                                     showCircularIcon: true)
    
    var isPromptVisible: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.35, animations: {
                if (self.isPromptVisible) {
                    self.transparencyView.alpha = 0.7
                    self.inviteView.dialogBoxView.alpha = 1
                } else {
                    self.transparencyView.alpha = 0
                    self.inviteView.dialogBoxView.alpha = 0
                    self.activityIndicator.alpha = 0
                }
            })
        }
    }
    
    var isBusy = false {
        didSet {
            self.activityIndicator.alpha = self.isBusy ? 1 : 0
            if let items = self.tabBarController?.tabBar.items {
                for item in items {
                    item.isEnabled = !self.isBusy
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ServiceManager.instance.chatService.delegate = self
        self.setDiscoveryInfo(from: ServiceManager.instance.userProfile)
        self.updateVisibility()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ServiceManager.instance.chatService.delegate = self
        self.isBusy = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateFoundPeers()
        self.reloadData()
        self.isBusy = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.people.removeAll()
        self.reloadData()
        self.isBusy = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ChatController {
            vc.stringEmoji = ""
        }
    }
    
    func inviteForGame() {
        if let user = self.userBeingInvited {
            if let id = self.idOfUserBeingInvited {
                self.isGame = true
                ServiceManager.instance.selectedPeer = (key: id,
                                                        name: user.username,
                                                        hair: user.avatar[AvatarParts.hair]!,
                                                        face: user.avatar[AvatarParts.face]!,
                                                        skinTone: (user.avatar[AvatarParts.skin]!).components(separatedBy: "|")[0],
                                                        skinToneIndex: (user.avatar[AvatarParts.skin]!).components(separatedBy: "|")[1])
                GameViewController.randomEmoji = GameViewController.randomizeEmoji()
                GameViewController.isPlayerOne = true
                ServiceManager.instance.chatService.serviceBrowser.invitePeer(id,
                                                                              to: ServiceManager.instance.chatService.session,
                                                                              withContext: ConnectivityViewController.createUserData(for: "game"),
                                                                              timeout: 20)
                self.dismissInvitationPrompt()
                self.isBusy = true
                self.view.bringSubview(toFront: self.activityIndicator)
                self.view.isUserInteractionEnabled = false
            }
        }
    }
    
    func inviteForChat() {
        if let user = self.userBeingInvited {
            if let id = self.idOfUserBeingInvited {
                self.isGame = false
                ServiceManager.instance.selectedPeer = (key: id,
                                                        name: user.username,
                                                        hair: user.avatar[AvatarParts.hair]!,
                                                        face: user.avatar[AvatarParts.face]!,
                                                        skinTone: (user.avatar[AvatarParts.skin]!).components(separatedBy: "|")[0],
                                                        skinToneIndex: (user.avatar[AvatarParts.skin]!).components(separatedBy: "|")[1])
                ServiceManager.instance.chatService.serviceBrowser.invitePeer(id,
                                                                              to: ServiceManager.instance.chatService.session,
                                                                              withContext: ConnectivityViewController.createUserData(for: "chat"),
                                                                              timeout: 20)
                self.dismissInvitationPrompt()
                self.isBusy = true
                self.view.bringSubview(toFront: self.activityIndicator)
                self.view.isUserInteractionEnabled = false
            }
        }
    }
    
    func cancelInvite() {
        UIImpactFeedbackGenerator(style: UIImpactFeedbackStyle.heavy).impactOccurred()
        self.dismissInvitationPrompt()
    }
    
    func setUpPromptViews() {
        self.activityIndicator.frame = self.view.frame
        self.activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.activityIndicator.startAnimating()
        self.activityIndicator.alpha = 0
        self.view.addSubview(activityIndicator)
        
        self.transparencyView = UIView(frame: self.view.frame)
        self.transparencyView.backgroundColor = UIColor.black
        self.transparencyView.alpha = 0
        self.view.addSubview(self.transparencyView)
        
        self.inviteView = InviteView(frame: self.view.frame)
        self.view.addSubview(self.inviteView)
        self.inviteView.gameButtonAction = self.inviteForGame
        self.inviteView.chatButtonAction = self.inviteForChat
        self.inviteView.cancelButtonAction = self.cancelInvite
        
        self.invitationView = InvitationView(frame: self.view.frame)
        self.view.addSubview(self.invitationView)
    }
    
    func updateVisibility() {
        if (ServiceManager.instance.userProfile.status != Status.ghost) {
            ServiceManager.instance.chatService.serviceAdvertiser.startAdvertisingPeer()
            ServiceManager.instance.chatService.serviceBrowser.startBrowsingForPeers()
        } else {
            ServiceManager.instance.chatService.serviceAdvertiser.stopAdvertisingPeer()
            ServiceManager.instance.chatService.serviceBrowser.stopBrowsingForPeers()
        }
    }
    
    func setDiscoveryInfo(from profile: ProfileRequirements) {
        let userProfile = ServiceManager.instance.userProfile
        let info = ["avatarHair": userProfile.avatar[AvatarParts.hair]!,
                    "avatarFace": userProfile.avatar[AvatarParts.face]!,
                    "avatarSkinTone": userProfile.avatar[AvatarParts.skin]!,
                    "username": userProfile.username,
                    "moodOne": userProfile.moods[0].rawValue,
                    "moodTwo": userProfile.moods[1].rawValue,
                    "moodThree": userProfile.moods[2].rawValue,
                    "status":  userProfile.status.rawValue]
        ServiceManager.instance.chatService.discoveryInfo = info
    }
    
    func invitePeer(withId id: MCPeerID, profile: ProfileRequirements) {
        if let userBeingInvited = profile as? UserProfile {
            self.userBeingInvited = userBeingInvited
            self.idOfUserBeingInvited = id
            self.isBusy = true
            self.isInviting = true
        }
    }
    
    func handleInvitation(from: MCPeerID, withContext context: Data?, invitationHandler: @escaping ((Bool, MCSession?) -> Void)) {
        if (!self.isBusy) {
            self.isBusy = true
            if let context = context {
                if let data = String(data: context, encoding: String.Encoding.utf8) {
                    if let items = self.tabBarController?.tabBar.items {
                        for item in items {
                            item.isEnabled = false
                        }
                        
                        let chatService = ServiceManager.instance.chatService
                        let userData = ConnectivityViewController.decodeUserData(from: data)
                        let invitationText = userData[DecodedUserDataKeys.interactionType] == "chat" ? NSLocalizedString("chat_invite_message", comment: "") : NSLocalizedString("game_invite_message", comment: "")
                        OperationQueue.main.addOperation {
                            self.view.bringSubview(toFront: self.invitationView)
                            self.invitationView.avatarInviting.hairImageView.image = UIImage(named: userData[DecodedUserDataKeys.avatarHair]!)
                            self.invitationView.avatarInviting.faceImageView.image = UIImage(named: userData[DecodedUserDataKeys.avatarFace]!)
                            self.invitationView.avatarInviting.faceImageView.backgroundColor = Colours.getColour(named: userData[DecodedUserDataKeys.avatarSkinTone]!,
                                                                                                                 index: Int(userData[DecodedUserDataKeys.avatarSkinToneIndex]!))
                            self.invitationView.usernameLabel.text = userData[DecodedUserDataKeys.username]!
                            self.invitationView.messageLabel.text = "\(NSLocalizedString("invite_message", comment: "")) \(invitationText)"
                            self.invitationView.acceptButton.bgColor = Colours.getColour(named: userData[DecodedUserDataKeys.avatarSkinTone]!,
                                                                                         index: Int(userData[DecodedUserDataKeys.avatarSkinToneIndex]!))
                            
                            self.invitationView.acceptButtonAction = {
                                self.isGame = userData[DecodedUserDataKeys.interactionType]! == "game"
                                for item in items {
                                    item.isEnabled = true
                                }
                                
                                GameViewController.randomEmoji = userData[DecodedUserDataKeys.emoji]!
                                GameViewController.isPlayerOne = false
                                ServiceManager.instance.selectedPeer = (from,
                                                                        userData[DecodedUserDataKeys.username]!,
                                                                        userData[DecodedUserDataKeys.avatarHair]!,
                                                                        userData[DecodedUserDataKeys.avatarFace]!,
                                                                        userData[DecodedUserDataKeys.avatarSkinTone]!,
                                                                        userData[DecodedUserDataKeys.avatarSkinToneIndex]!)
                                self.isBusy = false
                                invitationHandler(true, chatService.session)
                                UIView.animate(withDuration: 0.35, animations: {
                                    self.invitationView.alpha = 0
                                    self.transparencyView.alpha = 0
                                })
                            }
                            
                            self.invitationView.refuseButtonAction = {
                                UIImpactFeedbackGenerator(style: UIImpactFeedbackStyle.heavy).impactOccurred()
                                for item in items {
                                    item.isEnabled = true
                                }
                                
                                self.isBusy = false
                                invitationHandler(false, chatService.session)
                                UIView.animate(withDuration: 0.35, animations: {
                                    self.invitationView.alpha = 0
                                    self.transparencyView.alpha = 0
                                })
                            }
                            
                            UIView.animate(withDuration: 0.35, animations: {
                                self.invitationView.alpha = 1
                                self.transparencyView.alpha = 0.7
                            })
                            
                            //                        let alert = SCLAlertView(appearance: self.alertAppearence)
                            //
                            //                        alert.addButton(NSLocalizedString("accept", comment: "")) {
                            //                            self.isGame = userData[DecodedUserDataKeys.interactionType]! == "game"
                            //                            for item in items {
                            //                                item.isEnabled = true
                            //                            }
                            //
                            //                            GameViewController.randomEmoji = userData[DecodedUserDataKeys.emoji]!
                            //                            GameViewController.isPlayerOne = false
                            //                            ServiceManager.instance.selectedPeer = (from,
                            //                                                                    userData[DecodedUserDataKeys.username]!,
                            //                                                                    userData[DecodedUserDataKeys.avatarHair]!,
                            //                                                                    userData[DecodedUserDataKeys.avatarFace]!,
                            //                                                                    userData[DecodedUserDataKeys.avatarSkinTone]!,
                            //                                                                    userData[DecodedUserDataKeys.avatarSkinToneIndex]!)
                            //                            invitationHandler(true, chatService.session)
                            //                            self.isBusy = false
                            //                        }
                            //
                            //                        alert.addButton(NSLocalizedString("refuse", comment: ""), backgroundColor: UIColor.red) {
                            //                            UIImpactFeedbackGenerator(style: UIImpactFeedbackStyle.heavy).impactOccurred()
                            //                            for item in items {
                            //                                item.isEnabled = true
                            //                            }
                            //                            self.isBusy = false
                            //                            invitationHandler(false, chatService.session)
                            //                        }
                            //
                            //                            alert.showInfo(userData[DecodedUserDataKeys.username]!,
                            //                                           subTitle: "\(NSLocalizedString("invite_message", comment: "")) \(invitationText)",
                            //                                colorStyle: Colours.getColour(named: userData[DecodedUserDataKeys.avatarSkinTone]!,
                            //                                                              index: Int(userData[DecodedUserDataKeys.avatarSkinToneIndex]!)).toHexUInt(),
                            //                                circleIconImage: UIImage.imageByCombiningImage(firstImage: UIImage(named: userData[DecodedUserDataKeys.avatarHair]!)!,
                            //                                                                               withImage: UIImage(named: userData[DecodedUserDataKeys.avatarFace]!)!))
                        }
                    }
                }
            }
        } else {
            invitationHandler(false, ServiceManager.instance.chatService.session)
        }
    }
    
    func handleMessage(from: MCPeerID, message: String) {
        let (key, value) = (message.components(separatedBy: "|")[0], message.components(separatedBy: "|")[1])
        switch key {
        case MPCMessageTypes.closeConnection:
            sleep(1)
            ServiceManager.instance.chatService.session.disconnect()
            OperationQueue.main.addOperation {
                if let navigationController = self.navigationController {
                    if let tabBarController = self.tabBarController {
                        tabBarController.tabBar.isHidden = false
                        _ = navigationController.popToRootViewController(animated: true)
                    }
                }
            }
            
            break
        case MPCMessageTypes.emoji:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "received_emoji"), object: nil, userInfo: ["emoji": value])
            break
        case MPCMessageTypes.message:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "received_message"), object: nil, userInfo: ["message": message.components(separatedBy: "|")])
            break
        default:
            break
        }
    }
    
    func peerFound(withId id: MCPeerID) {
        self.updateFoundPeers()
        self.reloadData()
    }
    
    func peerLost(withId id: MCPeerID) {
        if (self.people.count > 0) {
            for i in 0 ... self.people.count - 1 {
                if (self.people[i].id == id.displayName.components(separatedBy: "|")[0]) {
                    self.people.remove(at: i)
                    break
                }
            }
        }
        self.reloadData()
    }
    
    func connectedSuccessfully(with id: MCPeerID) {
        OperationQueue.main.addOperation {
            if (self.isGame) {
                self.show(UIStoryboard(name: "Interactions", bundle: nil).instantiateViewController(withIdentifier: "GameViewController"), sender: self)
            } else {
                self.show(UIStoryboard(name: "Interactions", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController"), sender: self)
            }
        }
    }
    
    func connectionLost() {
        OperationQueue.main.addOperation {
            self.view.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.2) {
                self.isBusy = false
            }
            
            if (self.isInviting) {
                self.isInviting = false
                let alert = AlertView.createAlert(title: "Busy", message: "Invited peer appears to be busy", action: {
                    for view in self.view.subviews {
                        if let alert = view as? AlertView {
                            UIView.animate(withDuration: 0.35, animations: {
                                self.transparencyView.alpha = 0
                                alert.alpha = 0
                            }, completion: { finished in
                                if (finished) {
                                    alert.removeFromSuperview()
                                }
                            })
                            
                            break
                        }
                    }
                })
                
                alert.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
                alert.alpha = 0
                self.view.addSubview(alert)
                UIView.animate(withDuration: 0.35, animations: {
                    self.transparencyView.alpha = 0.7
                    alert.alpha = 1
                })
            }
        }
    }
    
    func updateFoundPeers() {
        self.people.removeAll()
        let peers = ServiceManager.instance.chatService.peers
        let infos = ServiceManager.instance.chatService.peersDiscoveryInfos
        if peers.count > 0 {
            for i in 0 ... peers.count - 1 {
                self.people.append(UserProfile(id: peers[i].displayName.components(separatedBy: "|")[0],
                                               username: infos[i][DecodedUserDataKeys.username.enumToString]!,
                                               avatar: [AvatarParts.hair: infos[i][DecodedUserDataKeys.avatarHair.enumToString]!,
                                                        AvatarParts.face: infos[i][DecodedUserDataKeys.avatarFace.enumToString]!,
                                                        AvatarParts.skin: infos[i][DecodedUserDataKeys.avatarSkinTone.enumToString]!],
                                               moods: [Mood(rawValue: infos[i][DecodedUserDataKeys.moodOne.enumToString]!)!,
                                                       Mood(rawValue: infos[i][DecodedUserDataKeys.moodTwo.enumToString]!)!,
                                                       Mood(rawValue:infos[i][DecodedUserDataKeys.moodThree.enumToString]!)!],
                                               status: Status(rawValue: infos[i][DecodedUserDataKeys.status.enumToString]!)!))
            }
        }
    }
    
    func reloadData() {}
    
    func dismissInvitationPrompt() {}
    
    static func createUserData(for interaction: String) -> Data {
        let userProfile = ServiceManager.instance.userProfile
        let data = "\(userProfile.username)|" +
            "\(userProfile.avatar[AvatarParts.hair]!)|" +
            "\(userProfile.avatar[AvatarParts.face]!)|" +
            "\(userProfile.avatar[AvatarParts.skin]!)|" + // skinColour|index
            "\(userProfile.moods[0].rawValue)|" +
            "\(userProfile.moods[1].rawValue)|" +
            "\(userProfile.moods[2].rawValue)|" +
        "\(userProfile.status.rawValue)|"
        return (interaction == "chat" ? data + "chat|\(GameViewController.randomEmoji)" : data + "game|\(GameViewController.randomEmoji)").data(using: String.Encoding.utf8)!  // has 10 components separeted by |
    }
    
    static func decodeUserData(from data: String) -> [DecodedUserDataKeys : String] {
        let userData = data.components(separatedBy: "|")
        return [.username: userData[0],
                .avatarHair: userData[1],
                .avatarFace: userData[2],
                .avatarSkinTone: userData[3],
                .avatarSkinToneIndex: userData[4],
                .moodOne: userData[5],
                .moodTwo: userData[6],
                .moodThree: userData[7],
                .status: userData[8],
                .interactionType: userData[9],
                .emoji: userData[10]]
    }
}
