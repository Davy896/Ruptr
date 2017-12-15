//
//  Messages.swift
//  App
//
//  Created by Davide Contaldo on 14/12/17.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit


class Profile: NSObject {
    var name: String?
    var profileImageName: String?
    
    /*override init() {
     self.name = name
     self.profileImage = profileImage*/
}




class Messages: NSObject {
    var text: String?
    var date: NSDate?
    
    var profile: Profile?
}


class SingleChatCell: UICollectionViewCell {
    
    
    var message: Messages? {
        didSet {
            nameLabel.text = message?.profile?.name
            profileImageView.image = UIImage(named: (message?.profile?.profileImageName)!)
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
        label.text = "Mark Zuckerberg"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Your friend's message and something else..."
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:05 pm"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
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
    //----------------
    
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
        
        //        profileImageView.image = UIImage(named: "a")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
       
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        
        messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        messageLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        messageLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        messageLabel.textColor = UIColor.black
    }
    
   
    
    
}

//extension ChatController{
//    
//    func setupData() {
//        
//        let testProfile = Profile()
//        testProfile.name = "testProfileName"
//        //        testProfile.profileImageName = "a"
//        
//        var message = Messages()
//        message.profile = testProfile
//        message.text = "ciao questo è un test"
//        
//        //message.date = NSDate()
//        message.profile?.profileImageName = "a"
//        
//        let testProfile2 = Profile()
//        testProfile2.name = "testProfileName2"
//        //        testProfile2.profileImageName = "b"
//        
//        
//        var message2 = Messages()
//        message2.profile = testProfile2
//        message2.text = "ciao questo è il secondo test"
//        //message.date = NSDate()
//        message2.profile?.profileImageName = "b"
//        
//        messages = [message,message2]
//        
//        
//        
//        
//}
//
//
//}


