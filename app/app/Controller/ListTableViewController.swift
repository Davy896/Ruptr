//
//  ListTableViewController.swift
//  FirstMini
//
//  Created by Alessio Tortello on 12/12/2017.
//  Copyright © 2017 Alessio Tortello. All rights reserved.
//

import UIKit

class Person {
    var image : UIImage
    var title : String
    var mood1 : UIImage
    var mood2 : UIImage
    var mood3 : UIImage
    init(image: UIImage, title: String, mood1: UIImage, mood2: UIImage, mood3: UIImage) {
        self.image = image
        self.title = title
        self.mood1 = mood1
        self.mood2 = mood2
        self.mood3 = mood3
    }
}

class ListTableViewController: UITableViewController {
    
    // var person = where i have to link the data from multipeer connectivity. I used "person" like a class with title and image as attributes.
    
    let people: [Person] = [Person(image: #imageLiteral(resourceName: "roguemonkeyblog"), title: "Persona1", mood1: #imageLiteral(resourceName: "roguemonkeyblog"), mood2:#imageLiteral(resourceName: "roguemonkeyblog"), mood3: #imageLiteral(resourceName: "roguemonkeyblog")), Person(image: #imageLiteral(resourceName: "roguemonkeyblog"), title: "Persona2", mood1: #imageLiteral(resourceName: "roguemonkeyblog"), mood2:#imageLiteral(resourceName: "roguemonkeyblog"), mood3: #imageLiteral(resourceName: "roguemonkeyblog"))]
    
    
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
