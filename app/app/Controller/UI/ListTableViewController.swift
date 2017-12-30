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
    
    @IBOutlet var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIViewController.setTableViewBackground(for: self)
        
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
        self.people.removeAll()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func peerFound(withId id: MCPeerID) {
        super.peerFound(withId: id)
        self.tableView.reloadData()
    }
    
    override func peerLost(withId id: MCPeerID) {
        super.peerLost(withId: id)
        self.tableView.reloadData()
    }
    
    override func invitePeer(withId id: MCPeerID, profile: ProfileRequirements) {
        super.invitePeer(withId: id, profile: profile)
        if let userBeingInvited = profile as? UserProfile {
            if let items = self.tabBarController?.tabBar.items {
                for item in items {
                    item.isEnabled = false
                }
                
                let alert = SCLAlertView(appearance: self.alertAppearence)
                let serviceBrowser = ServiceManager.instance.chatService.serviceBrowser
                alert.addButton(NSLocalizedString("game", comment: "")) {
                    for item in items {
                        item.isEnabled = true
                    }
                    
                    self.isGame = true
                    ServiceManager.instance.selectedPeer = (key: id,
                                                            name: userBeingInvited.username,
                                                            hair: userBeingInvited.avatar[AvatarParts.hair]!,
                                                            face: userBeingInvited.avatar[AvatarParts.face]!,
                                                            skinTone: (userBeingInvited.avatar[AvatarParts.skin]!).components(separatedBy: "|")[0],
                                                            skinToneIndex: (userBeingInvited.avatar[AvatarParts.skin]!).components(separatedBy: "|")[1])
                    GameViewController.randomEmoji = GameViewController.randomizeEmoji()
                    GameViewController.isPlayerOne = true
                    serviceBrowser.invitePeer(id,
                                              to: ServiceManager.instance.chatService.session,
                                              withContext: ConnectivityViewController.createUserData(for: "game"),
                                              timeout: 20)
                }
                
                alert.addButton(NSLocalizedString("chat", comment: "")) {
                    for item in items {
                        item.isEnabled = true
                    }
                    
                    self.isGame = false
                    ServiceManager.instance.selectedPeer = (key: id,
                                                            name: userBeingInvited.username,
                                                            hair: userBeingInvited.avatar[AvatarParts.hair]!,
                                                            face: userBeingInvited.avatar[AvatarParts.face]!,
                                                            skinTone: (userBeingInvited.avatar[AvatarParts.skin]!).components(separatedBy: "|")[0],
                                                            skinToneIndex: (userBeingInvited.avatar[AvatarParts.skin]!).components(separatedBy: "|")[1])
                    serviceBrowser.invitePeer(id,
                                              to: ServiceManager.instance.chatService.session,
                                              withContext: ConnectivityViewController.createUserData(for: "chat"),
                                              timeout: 20)
                }
                
                alert.addButton(NSLocalizedString("cancel", comment: ""), backgroundColor: UIColor.red) {
                    UIImpactFeedbackGenerator(style: UIImpactFeedbackStyle.light).impactOccurred()
                    for item in items {
                        item.isEnabled = true
                    }
                }
                
                OperationQueue.main.addOperation {
                    alert.showInfo(userBeingInvited.username,
                                   subTitle: NSLocalizedString("send_invitation", comment: ""),
                                   colorStyle: userBeingInvited.avatarSkin.toHexUInt(),
                                   circleIconImage: UIImage.imageByCombiningImage(firstImage: userBeingInvited.avatarFace!, withImage: userBeingInvited.avatarHair!))
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
