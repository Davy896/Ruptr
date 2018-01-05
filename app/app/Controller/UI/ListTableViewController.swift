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

class ListTableViewController: ConnectivityViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var selectedAvatar: AvatarPlanetButton!
    var selectedAvatarPosition: CGPoint?
    
    let invisibleTransform = CGAffineTransform(scaleX: 0.00000000000001, y: 0.00000000000001)
    
    override var isPromptVisible: Bool {
        didSet {
            if let items = self.tabBarController?.tabBar.items {
                for button in items {
                    button.isEnabled = !self.isPromptVisible
                }
            }
            
            self.tableView.isScrollEnabled = !self.isPromptVisible
            if let avatarPosition = self.selectedAvatarPosition {
                UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    if (!self.isPromptVisible) {
                        self.invitationView.transform = self.invisibleTransform
                        self.invitationView.center = avatarPosition
                        
                        self.avatarFrameView.transform = self.invisibleTransform
                        self.avatarFrameView.center = avatarPosition
                    } else {
                        self.invitationView.transform = CGAffineTransform.identity
                        self.invitationView.center = CGPoint(x: self.view.center.x,
                                                             y: self.view.center.y - (self.tabBarController?.tabBar.frame.height ?? 0))
                        
                        self.avatarFrameView.transform = CGAffineTransform.identity
                        self.avatarFrameView.center = CGPoint(x: self.view.frame.width / 2, y: self.invitationView.frame.origin.y)
                    }
                }, completion: nil)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIViewController.setTableViewBackground(for: self)
        self.setUpPromptViews()
        
        self.selectedAvatar = AvatarPlanetButton()
        self.selectedAvatar.frame.size = self.avatarFrameView.frame.size - 5
        self.selectedAvatar.center = CGPoint(x: self.avatarFrameView.bounds.midX, y: self.avatarFrameView.bounds.midY)
        self.selectedAvatar.isUserInteractionEnabled = false
        self.selectedAvatar.alpha = 1
        self.avatarFrameView.addSubview(self.selectedAvatar)
        
        self.invitationView.transform = self.invisibleTransform
        self.avatarFrameView.transform = self.invisibleTransform
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.updateFoundPeers()
        
        self.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func invitePeer(withId id: MCPeerID, profile: ProfileRequirements) {
        super.invitePeer(withId: id, profile: profile)
        if profile is UserProfile {
            OperationQueue.main.addOperation {
                self.isPromptVisible = true
            }
        }
    }
    
    override func dismissInvitationPrompt() {
        super.dismissInvitationPrompt()
        self.isPromptVisible = false
    }
    
    override func reloadData() {
        super.reloadData()
        UIView.transition(with: self.tableView,
                          duration: 0.35,
                          options: UIViewAnimationOptions.transitionCrossDissolve,
                          animations: { self.tableView.reloadData() },
                          completion:  nil)
    }
}

extension ListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? ListTableViewCell {
            if let profile = cell.userProfile {
                self.selectedAvatarPosition = CGPoint(x: cell.faceImageView.frame.midX,
                                                      y: cell.faceImageView.frame.midY + cell.frame.height * CGFloat(indexPath.item))
                self.selectedAvatar.cloneAttributesFrom(listTableViewCell: cell)
                self.avatarFrameView.center = self.selectedAvatarPosition!
                self.invitationView.center = self.selectedAvatarPosition!
                
                self.usernameLabel.text = profile.username
                self.gameButton.bgColor = profile.avatarSkin
                self.chatButton.bgColor = profile.avatarSkin
                
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

extension ListTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 0
        } else {
            return self.people.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! ListTableViewCell
        cell.userProfile = self.people[indexPath.row]
        return cell
    }
}
