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
    
    var person: Person? {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        ListTitleView?.text = person?.title
        ListImageView?.image = person?.image
        mood1?.image = person?.mood1
        mood2?.image = person?.mood2
        mood3?.image = person?.mood3
    }
}
