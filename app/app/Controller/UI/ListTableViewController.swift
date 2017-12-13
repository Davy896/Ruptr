//
//  ListTableViewController.swift
//  FirstMini
//
//  Created by Alessio Tortello on 12/12/2017.
//  Copyright © 2017 Alessio Tortello. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    // var person = where i have to link the data from multipeer connectivity. I used "person" like a class with title and image as attributes.
    
    let people: [UserProfile] = [UserProfile(id: String.randomAlphaNumericString(length: 20), userName: "Persona1")]
    public init(id: String, userName: String, avatar: String, moods: [Mood],status: Status) {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "People Around You"
        
        self.tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // I USED THE CLASS PEOPLE THAT DOESN'T EXIST YET
        return people.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! ListTableViewCell
        
        // HERE I CREATED THE SUBLCASS PERSON
        
        
        cell.person = people[indexPath.row]
        
        return cell
    }
    
    
    
}
