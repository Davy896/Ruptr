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

class ListTableViewController: ConnectivityViewController, UITableViewDelegate, UITableViewDataSource {
    
    var people: [UserProfile] = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "People Around You"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let peers = ServiceManager.instance.chatService.peers
        let infos = ServiceManager.instance.chatService.peersDiscoveryInfos
        if peers.count > 0 {
            
            for i in 0 ... peers.count - 1 {
                people.append(UserProfile(id: peers[i].displayName.components(separatedBy: "|")[0],
                                          username: infos[i]["username"]!,
                                          avatar: infos[i]["avatar"]!,
                                          moods: [ Mood.stringToEnum(from: infos[i]["moodOne"]!),
                                                   Mood.stringToEnum(from: infos[i]["moodTwo"]!),
                                                   Mood.stringToEnum(from:infos[i]["moodThree"]!)],
                                          status: Status.stringToEnum(from: infos[i]["status"]!)))
            }
        }
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let peers = ServiceManager.instance.chatService.peers
        let infos = ServiceManager.instance.chatService.peersDiscoveryInfos
        people.removeAll()
        if peers.count > 0 {
            
            for i in 0 ... peers.count - 1 {
                people.append(UserProfile(id: peers[i].displayName.components(separatedBy: "|")[0],
                                          username: infos[i]["username"]!,
                                          avatar: infos[i]["avatar"]!,
                                          moods: [ Mood.stringToEnum(from: infos[i]["moodOne"]!),
                                                   Mood.stringToEnum(from: infos[i]["moodTwo"]!),
                                                   Mood.stringToEnum(from:infos[i]["moodThree"]!)],
                                          status: Status.stringToEnum(from: infos[i]["status"]!)))
            }
        }
        
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
        let peers = ServiceManager.instance.chatService.peers
        let infos = ServiceManager.instance.chatService.peersDiscoveryInfos
        if peers.count > 0 {            
            for i in 0 ... peers.count - 1 {
                people.append(UserProfile(id: peers[i].displayName.components(separatedBy: "|")[0],
                                          username: infos[i]["username"]!,
                                          avatar: infos[i]["avatar"]!,
                                          moods: [ Mood.stringToEnum(from: infos[i]["moodOne"]!),
                                                   Mood.stringToEnum(from: infos[i]["moodTwo"]!),
                                                   Mood.stringToEnum(from:infos[i]["moodThree"]!)],
                                          status: Status.stringToEnum(from: infos[i]["status"]!)))
            }
        }
        
        self.tableView.reloadData()
    }
    
    override func peerLost(withId id: MCPeerID) {
        if (people.count > 0) {
            for i in 0 ... people.count - 1 {
                if people[0].id == id.displayName.components(separatedBy: "|")[0] {
                    people.remove(at: i)
                    break
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    override func invitePeer(withId id: MCPeerID, profile: ProfileRequirements) {
        guard let userProfile = profile as? UserProfile else {
            return
        }
        
        let alert = UIAlertController(title: userProfile.username, message: "Send invitation for", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Game", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
            
            let context = "\(userProfile.username)|\(userProfile.avatar)|\(userProfile.moods[0].enumToString)|\(userProfile.moods[1].enumToString)|\(userProfile.moods[2].enumToString)|game"
            ServiceManager.instance.chatService.serviceBrowser.invitePeer(id, to: ServiceManager.instance.chatService.session, withContext: context.data(using: String.Encoding.utf8), timeout: 20)
        }))
        
        alert.addAction(UIAlertAction(title: "Chat", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
            let context = "\(userProfile.username)|\(userProfile.avatar)|\(userProfile.moods[0].enumToString)|\(userProfile.moods[1].enumToString)|\(userProfile.moods[2].enumToString)|chat"
            ServiceManager.instance.chatService.serviceBrowser.invitePeer(id, to: ServiceManager.instance.chatService.session, withContext: context.data(using: String.Encoding.utf8), timeout: 20)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
        OperationQueue.main.addOperation {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func handleInvitation(from: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        guard let context = context else {
            return
        }
        
        guard let data = String(data: context, encoding: String.Encoding.utf8) else {
            return
        }
        
        let userData = data.components(separatedBy: "|")
        var invitationType = ""
        if (userData[5] == "chat") {
            invitationType = "chat."
        } else {
            invitationType = "to play a game."
        }
        
        let alert = UIAlertController(title: userData[0], message: "Is inviting you to \(invitationType)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
            let nextViewController = userData[5] == "chat" ? UIStoryboard(name: "Interactions", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") : UIStoryboard(name: "Interactions", bundle: nil).instantiateViewController(withIdentifier: "GameViewController")
            
            invitationHandler(true, ServiceManager.instance.chatService.session)
            print("==================================")
            print(ServiceManager.instance.chatService.session.connectedPeers.count)
            for peer in ServiceManager.instance.chatService.session.connectedPeers {
                print(peer.displayName)
            }
            print("==================================")
            
            if (ServiceManager.instance.chatService.session.connectedPeers.contains(from)) {
                do {
                    try ServiceManager.instance.chatService.session.send(userData[5].data(using: String.Encoding.utf8)!, toPeers: [from], with: MCSessionSendDataMode.reliable)
                    
                } catch let error {
                    NSLog("%@", "Error for sending: \(error)")
                }
            }
            self.show(nextViewController, sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Refuse", style: UIAlertActionStyle.destructive, handler:  { (action:UIAlertAction) in
            invitationHandler(false, ServiceManager.instance.chatService.session)
        }))
        
        OperationQueue.main.addOperation {
            self.present(alert, animated: true, completion: nil)
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
        guard let cell = self.tableView.cellForRow(at: indexPath) as? ListTableViewCell else {
            return
        }
        
        guard let profile = cell.userProfile else {
            return
        }
        
        var id: MCPeerID? = nil
        for peer in ServiceManager.instance.chatService.peers {
            if (peer.displayName.components(separatedBy: "|")[0] == profile.id) {
                id = peer
            }
        }
        
        if (id != nil) {
            invitePeer(withId: id!, profile: profile)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
