//
//  ListTableViewCell.swift
//  FirstMini
//
//  Created by Alessio Tortello on 12/12/2017.
//  Copyright © 2017 Alessio Tortello. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ListImageView: UIImageView!
    @IBOutlet weak var ListTitleView: UILabel!
    @IBOutlet weak var mood1: UIImageView!
    @IBOutlet weak var mood2: UIImageView!
    @IBOutlet weak var mood3: UIImageView!
    
    
    // variable data model
    

    var userProfile: UserProfile? {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        guard let person = userProfile else {
            return
        }
        
        ListTitleView?.text = person.username
        ListImageView?.image = UIImage(named: person.avatar)
        mood1?.image = person.moods[0].image
        mood2?.image = person.moods[0].image
        mood3?.image = person.moods[0].image
    }
}
