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
    
    var person: UserProfile? {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        guard let profile = person else{
            return
        }
        ListTitleView?.text = profile.userName
        ListImageView?.image = UIImage(named: profile.avatar)
        mood1?.image = UIImage(named: profile.moods[0])
        mood2?.image = UIImage(named: profile.moods[1])
        mood3?.image = UIImage(named: profile.moods[2])
}
