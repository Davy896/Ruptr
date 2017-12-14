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
        self.tableView.reloadData()
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        print("click", ServiceManager.instance.chatService.peerId)
        guard let cell = self.tableView.cellForRow(at: indexPath) as? ListTableViewCell else {
            return
        }
        
        guard let profile = cell.userProfile else {
            return
        }
        
        var id: MCPeerID? = nil
        for peer in ServiceManager.instance.chatService.peers {
            if (peer.displayName.components(separatedBy: "|")[0] == profile.id) {
                print(peer)
                id = peer
            }
        }
        
        if (id != nil) {
            invitePeer(withId: id!)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func peerFound(withId id: MCPeerID) {
        let peers = ServiceManager.instance.chatService.peers
        let infos = ServiceManager.instance.chatService.peersDiscoveryInfos
        if peers.count > 0 {
            print(peers.count)
            
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
        for i in 0 ... people.count - 1 {
            if people[0].id == id.displayName.components(separatedBy: "|")[0] {
                people.remove(at: i)
                break
            }
        }
        
        self.tableView.reloadData()
    }
    
    override func invitePeer(withId id: MCPeerID) {
        ServiceManager.instance.chatService.serviceBrowser.invitePeer(id, to: ServiceManager.instance.chatService.session, withContext: nil, timeout: 20)
    }
    
    override func handleInvitation(from: String) {
        let alert = UIAlertController(title: "Invitation", message: "received an invitation", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        OperationQueue.main.addOperation {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
