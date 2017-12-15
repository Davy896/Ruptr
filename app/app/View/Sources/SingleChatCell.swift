//
//  Messages.swift
//  App
//
//  Created by Davide Contaldo on 14/12/17.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit


//class Profile: NSObject {
//    var name: String?
//    var profileImageName: String?
//
//    /*override init() {
//     self.name = name
//     self.profileImage = profileImage*/
//}







class SingleChatCell: UICollectionViewCell {
    
    
    var message: Messages? {
        didSet {
            nameLabel.text = message?.username
            profileImageView.image = UIImage(named: (message?.avatar)!)
            messageLabel.text = message?.text
        }
    }
    
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let messageLabel: UITextView = {
        let label = UITextView()
        label.text = " "
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.blue
        label.font = UIFont.systemFont(ofSize: 18)
        label.layer.cornerRadius = 15
        return label
    }()
    
//    let timeLabel: UILabel = {
//        let label = UILabel()
//        label.text = " "
//        label.font = UIFont.systemFont(ofSize: 16)
//        label.textAlignment = .right
//        return label
//    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    let hasReadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
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
        
        
        addSubview(messageLabel)
        addSubview(profileImageView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        messageLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        messageLabel.textColor = UIColor.
        
       
        
    }
    
   
    
    
}




