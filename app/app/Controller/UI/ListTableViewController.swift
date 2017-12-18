//
//  ListTableViewController.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 13/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit
import ConnectivityServices
import MultipeerConnectivity
import SCLAlertView

class ListTableViewController: ConnectivityViewController, UITableViewDelegate, UITableViewDataSource {
    
    var people: [UserProfile] = []
    let alertAppearence = SCLAlertView.SCLAppearance(kCircleIconHeight: -56,
                                                     kTitleFont: UIFont(name: "Futura-Bold", size: 17)!,
                                                     kTextFont: UIFont(name: "Futura-Medium", size: 14)!,
                                                     kButtonFont: UIFont(name: "Futura-Medium", size: 17)!,
                                                     showCloseButton: false,
                                                     showCircularIcon: true)
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIViewController.setTableViewBackground(for: self)
        self.title = NSLocalizedString("list", comment: "")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.updateFoundPeers()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateFoundPeers()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        people.removeAll()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func peerFound(withId id: MCPeerID) {
        self.updateFoundPeers()
        self.tableView.reloadData()
    }
    
    override func peerLost(withId id: MCPeerID) {
        if (self.people.count > 0) {
            for i in 0 ... self.people.count - 1 {
                if self.people[0].id == id.displayName.components(separatedBy: "|")[0] {
                    self.people.remove(at: i)
                    break
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    override func invitePeer(withId id: MCPeerID, profile: ProfileRequirements) {
        if let userBeingInvited = profile as? UserProfile {
            
            let alert = SCLAlertView(appearance: self.alertAppearence)
            let serviceBrowser = ServiceManager.instance.chatService.serviceBrowser
            alert.addButton("Game") {
                self.isGame = true
                serviceBrowser.invitePeer(id,
                                          to: ServiceManager.instance.chatService.session,
                                          withContext: ListTableViewController.createUserData(for: "game"),
                                          timeout: 20)
            }
            
            alert.addButton("Chat") {
                self.isGame = false
                serviceBrowser.invitePeer(id,
                                          to: ServiceManager.instance.chatService.session,
                                          withContext: ListTableViewController.createUserData(for: "chat"),
                                          timeout: 20)
            }
            
            alert.addButton("Cancel", backgroundColor: UIColor.red) {
                UIImpactFeedbackGenerator(style: UIImpactFeedbackStyle.light).impactOccurred()
            }
            
            OperationQueue.main.addOperation {
                alert.showInfo(userBeingInvited.username,
                               subTitle: "Send invitation for",
                               colorStyle: userBeingInvited.avatarSkin.toHexUInt(),
                               circleIconImage: UIImage.imageByCombiningImage(firstImage: userBeingInvited.avatarFace!, withImage: userBeingInvited.avatarHair!))
            }
        }
    }
    
    override func handleInvitation(from: MCPeerID, withContext context: Data?) {
        if let context = context {
            if let data = String(data: context, encoding: String.Encoding.utf8) {
                
                let chatService = ServiceManager.instance.chatService
                let userData = ListTableViewController.decodeUserData(from: data)
                let invitationText = userData[DecodedUserDataKeys.interactionType] == "chat" ? "chat." : "to play a game."
                let alert = SCLAlertView(appearance: self.alertAppearence)
                
                alert.addButton("Accept") {
                    self.isGame = userData[DecodedUserDataKeys.interactionType]! == "game"
                    chatService.invitationHandler(true, chatService.session)
                }
                
                alert.addButton("Refuse", backgroundColor: UIColor.red) {
                    UIImpactFeedbackGenerator(style: UIImpactFeedbackStyle.heavy).impactOccurred()
                }
                
                OperationQueue.main.addOperation {
                    alert.showInfo(userData[DecodedUserDataKeys.username]!,
                                   subTitle: "Is inviting you to \(invitationText)",
                        colorStyle: Colours.getColour(named: userData[DecodedUserDataKeys.avatarSkinTone]!,
                                                      index: Int(userData[DecodedUserDataKeys.avatarSkinToneIndex]!)).toHexUInt(),
                        circleIconImage: UIImage.imageByCombiningImage(firstImage: UIImage(named: userData[DecodedUserDataKeys.avatarHair]!)!,
                                                                       withImage: UIImage(named: userData[DecodedUserDataKeys.avatarFace]!)!))
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 0
        } else {
            return people.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! ListTableViewCell
        cell.userProfile = people[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? ListTableViewCell {
            if let profile = cell.userProfile {
                cell.faceImageView.backgroundColor = cell.faceImageView.backgroundColor
                var id: MCPeerID? = nil
                for peer in ServiceManager.instance.chatService.peers {
                    if (peer.displayName.components(separatedBy: "|")[0] == profile.id) {
                        id = peer
                        break 
                    }
                }
                
                if (id != nil) {
                    self.invitePeer(withId: id!, profile: profile)
                }
                
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    private func updateFoundPeers() {
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
                                               moods: [Mood.stringToEnum(from: infos[i][DecodedUserDataKeys.moodOne.enumToString]!),
                                                       Mood.stringToEnum(from: infos[i][DecodedUserDataKeys.moodTwo.enumToString]!),
                                                       Mood.stringToEnum(from:infos[i][DecodedUserDataKeys.moodThree.enumToString]!)],
                                               status: Status.stringToEnum(from: infos[i][DecodedUserDataKeys.status.enumToString]!)))
            }
        }
    }
    
    private static func createUserData(for interaction: String) -> Data {
        let userProfile = ServiceManager.instance.userProfile
        let data = "\(userProfile.username)|" +
            "\(userProfile.avatar[AvatarParts.hair]!)|" +
            "\(userProfile.avatar[AvatarParts.face]!)|" +
            "\(userProfile.avatar[AvatarParts.skin]!)|" + // skinColour|index
            "\(userProfile.moods[0].enumToString)|" +
            "\(userProfile.moods[1].enumToString)|" +
            "\(userProfile.moods[2].enumToString)|" +
        "\(userProfile.status.enumToString)|"
        return (interaction == "chat" ? data + "chat " : data + "game").data(using: String.Encoding.utf8)!  // has 10 components separeted by |
    }
    
    private static func decodeUserData(from data: String) -> [DecodedUserDataKeys : String] {
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
                .interactionType: userData[9]]
    }
}

extension UIImage {
    
    class func imageByCombiningImage(firstImage: UIImage, withImage secondImage: UIImage) -> UIImage {
        
        let newImageWidth  = max(firstImage.size.width,  secondImage.size.width )
        let newImageHeight = max(firstImage.size.height, secondImage.size.height)
        let newImageSize = CGSize(width : newImageWidth, height: newImageHeight)
        
        UIGraphicsBeginImageContextWithOptions(newImageSize, false, UIScreen.main.scale)
        
        let firstImageDrawX  = round((newImageSize.width  - firstImage.size.width  ) / 2)
        let firstImageDrawY  = round((newImageSize.height - firstImage.size.height ) / 2)
        
        let secondImageDrawX = round((newImageSize.width  - secondImage.size.width ) / 2)
        let secondImageDrawY = round((newImageSize.height - secondImage.size.height) / 2)
        
        firstImage.draw(at: CGPoint(x: firstImageDrawX, y: firstImageDrawY))
        secondImage.draw(at: CGPoint(x: secondImageDrawX, y: secondImageDrawY))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
}

private enum DecodedUserDataKeys {
    case username
    case avatarHair
    case avatarFace
    case avatarSkinTone
    case avatarSkinToneIndex
    case moodOne
    case moodTwo
    case moodThree
    case status
    case interactionType
    
    var enumToString: String {
        get {
            switch self {
            case DecodedUserDataKeys.username:
                return "username"
            case DecodedUserDataKeys.avatarHair:
                return "avatarHair"
            case DecodedUserDataKeys.avatarFace:
                return "avatarFace"
            case DecodedUserDataKeys.avatarSkinTone:
                return "avatarSkinTone"
            case DecodedUserDataKeys.avatarSkinToneIndex:
                return "avatarSkinToneIndex"
            case DecodedUserDataKeys.moodOne:
                return "moodOne"
            case DecodedUserDataKeys.moodTwo:
                return "moodTwo"
            case DecodedUserDataKeys.moodThree:
                return "moodThree"
            case DecodedUserDataKeys.status:
                return "status"
            case DecodedUserDataKeys.interactionType:
                return "interactionType"
            }
        }
    }
}


