//
//  Messages.swift
//  App
//
//  Created by Davide Contaldo on 14/12/17.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit


class SingleChatCell: UICollectionViewCell {
    
    
    var message: Messages? {
        didSet {
            nameLabel.text = message?.username
            profileImageHair.image = UIImage(named: (message?.avatarHair)!)
            profileImageEyes.image = UIImage(named: (message?.avatarEyes)!)
            profileImageSkinColor.image = UIImage(named: (message?.avatarSkinColor)!)
            messageLabel.text = message?.text
//            cloud.image = #imageLiteral(resourceName: "right")
            
        }
    }
    
  
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    
    var cloud: UIView = {
        var image = UIView()
//        image = #imageLiteral(resourceName: "right")
        image.backgroundColor = UIColor.blue
        image.layer.cornerRadius = 15
        
        
        return image
    }()
    
    let messageLabel: UITextView = {
        let label = UITextView()
        label.text = ""
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.blue
        label.font = UIFont.systemFont(ofSize: 18)
        label.layer.cornerRadius = 15
        return label
    }()
    
    let profileImageHair: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let profileImageEyes: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let profileImageSkinColor: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
    
    
    override init(frame: CGRect) {
       
        super.init(frame: frame)
         setupView()
        
    }
    
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        backgroundColor = UIColor.white
        
        addSubview(cloud)
        addSubview(messageLabel)
        addSubview(profileImageHair)
        addSubview(profileImageEyes)
        addSubview(profileImageSkinColor)

    }

}




