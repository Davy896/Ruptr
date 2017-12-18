//
//  ListTableViewCell.swift
//  FirstMini
//
//  Created by Alessio Tortello on 12/12/2017.
//  Copyright © 2017 Alessio Tortello. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hairImageView: RoundImgView!
    @IBOutlet weak var faceImageView: RoundImgView!
    @IBOutlet weak var listTitleView: UILabel!
    @IBOutlet weak var mood1: RoundImgView!
    @IBOutlet weak var mood2: RoundImgView!
    @IBOutlet weak var mood3: RoundImgView!

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
        
        self.backgroundColor = UIColor.clear
        self.listTitleView.text = person.username
        self.hairImageView.image = person.avatarHair
        self.hairImageView.backgroundColor = UIColor.clear
        self.faceImageView.image = person.avatarFace
        self.faceImageView.backgroundColor = person.avatarSkin
        self.mood1.image = person.moods[0].image
        self.mood2.image = person.moods[0].image
        self.mood3.image = person.moods[0].image
    }
}
