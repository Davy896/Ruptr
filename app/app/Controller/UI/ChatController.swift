//
//  ChatController.swift
//  App
//
//  Created by Davide Contaldo on 14/12/17.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit

//class for the chat
class ChatController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellID"
    private let cellEmoji = "cellEMOJI"
    var messages: [Messages] = []
    var tap: UITapGestureRecognizer!
    var stringEmoji: String = ""
    @IBOutlet weak var chatCollectionView: UICollectionView!
    let sendButton = UIButton(type: .system)
    var containerViewBottomAnchor: NSLayoutConstraint?

    
    lazy var inputTextField: UITextField = {                        //this is the declaration of the input textField and the textField we need to write and having a reference to use function handleSend
        let textField = UITextField()                               //
        textField.placeholder = NSLocalizedString("chat_placeholder", comment: "")                  //
        textField.translatesAutoresizingMaskIntoConstraints = false //
        textField.delegate = self                                   //we need this to use enter to send messages
        return textField                                            //
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        collectionView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 50 )
        notificationView.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(receivedMessage), name: NSNotification.Name(rawValue: "received_message"), object: nil)
        
        chatCollectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        chatCollectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        UIViewController.setCollectionViewViewBackground(for: self)
        self.view.backgroundColor = Colours.background
        setupInputComponents()
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: NSLocalizedString("back", comment: ""),
                                            style: UIBarButtonItemStyle.plain,
                                            target: self,
                                            action: #selector(ChatController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        //container view for chat writing
        chatCollectionView.delegate = self
        chatCollectionView.dataSource = self
        chatCollectionView.register(SingleChatCell.self, forCellWithReuseIdentifier: cellId)
        
        chatCollectionView.register(SingleEmojiCell.self, forCellWithReuseIdentifier: cellEmoji)
        chatCollectionView.alwaysBounceVertical = true
        setupKeyboard()
        self.tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        self.view.addGestureRecognizer(self.tap)
        //        startTimer()
        //        showAndHideNotification()
        UIView.animate(withDuration: 0.2,
                       delay: 0.3,
                       animations: {
                        self.notificationText.alpha = 1 }) {
                            finished in
                            UIView.animate(withDuration: 0.2,
                                           delay: 2,
                                           animations: { self.notificationText.alpha = 0 }) {
                                            finished in
                                            self.notificationText.text =
                                            """
                                            The chat is closing in 1 minute.
                                            Take that time to agree on a meeting place.
                                            """
                            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            UIView.animate(withDuration: 0.2,
                           animations: { self.notificationText.alpha = 1 }) {
                            finished in
                            UIView.animate(withDuration: 0.2,
                                           delay: 2,
                                           animations: { self.notificationText.alpha = 0 }) {
                                            finished in
                                            self.notificationText.text = "Time's up"
                            }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
            UIView.animate(withDuration: 0.2,
                           animations: { self.notificationText.alpha = 1 }) {
                            finished in
                            self.inputTextField.isEnabled = false
                            self.sendButton.isEnabled = false
                            UIView.animate(withDuration: 0.2,
                                           delay: 2,
                                           animations: { self.notificationText.alpha = 0 })
            }
        }
    }
    
    
    
    
    let notificationView = UIView()
    var notificationText = UITextView()
    var emojiCustomView = UIView()
    
    
    
    func show() {

        notificationView.alpha = 1
        notificationText.alpha = 1
    }

    func hide() {
        notificationView.alpha = 0
        notificationText.alpha = 0
    }
//
//    func showAndHideNotification() {
//
//        UIView.animate(withDuration: 2, delay: 1.0, animations: show, completion: {(complete : Bool) -> Void in
//            UIView.animate(withDuration: 2, delay: 2.0, options: UIViewAnimationOptions.curveLinear, animations: self.hide, completion: {(complete : Bool) -> Void in
//
//                self.notificationText.text = "You have only 1 minute left ,hurry up to send the last messagges to say goodbye or to talk face to face!!!"
//                UIView.animate(withDuration: 2, delay: 2.0, options: UIViewAnimationOptions.curveLinear, animations: self.show, completion: {(complete : Bool) -> Void in
//                    UIView.animate(withDuration: 0.2, delay: 2.0, options: UIViewAnimationOptions.curveLinear, animations: self.hide, completion: {(complete : Bool) -> Void in
//
//                        self.notificationText.text = "Your time is over ,the chat will be closed!"
//                        UIView.animate(withDuration: 2, delay: 2.0, options: UIViewAnimationOptions.curveLinear, animations: self.show, completion: {(complete : Bool) -> Void in
//                            UIView.animate(withDuration: 2, delay: 2.0, options: UIViewAnimationOptions.curveLinear, animations: self.hide)})
//                    })
//                })
//            })
//
//        })
//    }
//
    
    
    
    
    //    var timeLabel = UILabel()
    //    var timer = Timer()
    //    var timeCount: TimeInterval = 300
    //    let timeInterval: TimeInterval = 1
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = tabBarController {
            tabBarController.tabBar.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let background = self.view.viewWithTag(0451) {
            UIView.animate(withDuration: 0.2, animations: {
                background.alpha = 0.6
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
   
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect)
        let keyboardDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]
        
        
        containerViewBottomAnchor?.constant = -keyboardFrame.height
        UIView.animate(withDuration: keyboardDuration as! TimeInterval) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        
        
        UIView.animate(withDuration: 0.35, animations: {
            self.emojiCustomView.frame.origin.y = 667
            
            self.emojiCustomView.frame.size.height = 0
            self.containerViewBottomAnchor?.constant = 0
        })
        
        self.view.endEditing(true)
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let keyboardDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]
        
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration as! TimeInterval) {
            self.view.layoutIfNeeded()
        }
    }
   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    var cellDimentionBool: Bool = false
    //    var a: CGFloat = 30
    
    func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
    }
    
   
    var mouthName = UITextField()
   
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //        checkingForSpecialChar(input: messages[indexPath.item].text)
        
        for char in messages[indexPath.item].text.enumerated() {
            if (char.element == "^") {
                mouthName.text = messages[indexPath.item].text
                
            }
        }
        
        
        if messages[indexPath.item].text == mouthName.text{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellEmoji, for: indexPath) as! SingleEmojiCell
            cell.message = messages[indexPath.item]
            let messageText = messages[indexPath.item].text
            var mounth = UIImageView()
            
            
            cell.tail.alpha = 0
            cell.messageLabel.alpha = 0
            cell.cloud.alpha = 0
            cell.mounth.image = UIImage(named: mouthName.text!)
            
            
            
            if messages[indexPath.item].id == ServiceManager.instance.userProfile.id {
                cell.profileImageHair.frame = CGRect(x: 265, y: 0, width: 100, height: 100)
                cell.profileImageEyes.frame = CGRect(x: 265, y: 0, width: 100, height: 100)
                cell.profileImageSkinColor.frame = CGRect(x: 265, y: 0, width: 100, height: 100)
                cell.mounth.frame = CGRect(x: 265, y: 0, width: 100, height: 100)
            } else {
                
                cell.profileImageHair.frame = CGRect(x: 10, y: 0, width: 100, height: 100)
                cell.profileImageEyes.frame = CGRect(x: 10, y: 0, width: 100, height: 100)
                cell.profileImageSkinColor.frame = CGRect(x: 10, y: 0, width: 100, height: 100)
                cell.mounth.frame = CGRect(x: 10, y: 0, width: 100, height: 100)
                
            }
            cell.profileImageEyes.layer.cornerRadius = 50
            
            cell.profileImageEyes.backgroundColor = Colours.getColour(named: messages[indexPath.item].avatarSkinColor.components(separatedBy: "|")[0],
                                                                      index: Int(messages[indexPath.item].avatarSkinColor.components(separatedBy: "|")[1]))
            cell.bringSubview(toFront: cell.profileImageHair)
            cell.bringSubview(toFront: cell.mounth)
            
            
            
            
            UIView.animate(withDuration: 0.2, animations: {
                
                cell.profileImageHair.alpha = 1
                cell.profileImageSkinColor.alpha = 1
                cell.profileImageEyes.alpha = 1
                cell.mounth.alpha = 1
            })
            let item = messages.count - 1
            let inserctionIndexPath = NSIndexPath(item: item, section: 0)
            
            if collectionView.contentSize.height - (containerViewBottomAnchor?.constant)! + 50 > collectionView.frame.size.height
            {
                let offset = CGPoint(x: 0, y: collectionView.contentSize.height - collectionView.frame.size.height - (containerViewBottomAnchor?.constant)! )
                
                collectionView.setContentOffset(offset , animated: true)
                
                
            }
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SingleChatCell
            cell.message = messages[indexPath.item]
            let messageText = messages[indexPath.item].text
            var mounth = UIImageView()
            
            if messages[indexPath.item].id == ServiceManager.instance.userProfile.id {
                
                cell.profileImageHair.image = UIImage(named: messages[indexPath.item].avatarHair)
                cell.profileImageEyes.image = UIImage(named: messages[indexPath.item].avatarEyes)
                
                
                cell.mounth.alpha = 0
                
                cell.cloud.backgroundColor = Colours.backgroundSecondary
                cell.messageLabel.backgroundColor = UIColor.clear
                
                cell.cloud.frame = CGRect(x: UIScreen.main.bounds.width - estimateFrameForText(messageText).width - 27 - 50 - 18, y: 0, width: estimateFrameForText(messageText).width + 28, height: estimateFrameForText(messageText).height + 20)
                cell.messageLabel.frame = CGRect(x: UIScreen.main.bounds.width - estimateFrameForText(messageText).width - 18 - 50 - 18, y: 0, width: estimateFrameForText(messageText).width + 16, height: estimateFrameForText(messageText).height + 20)
                
                
                
                cell.profileImageHair.frame = CGRect(x: UIScreen.main.bounds.width - 45, y: estimateFrameForText(messageText).height - 12, width: 30, height: 30)
                cell.profileImageEyes.frame = CGRect(x: UIScreen.main.bounds.width - 45, y: estimateFrameForText(messageText).height - 12, width: 30, height: 30)
                cell.profileImageSkinColor.frame = CGRect(x: UIScreen.main.bounds.width - 45, y: estimateFrameForText(messageText).height - 12, width: 30, height: 30)
                cell.profileImageEyes.backgroundColor = Colours.getColour(named: messages[indexPath.item].avatarSkinColor.components(separatedBy: "|")[0],
                                                                          index: Int(messages[indexPath.item].avatarSkinColor.components(separatedBy: "|")[1]))
                cell.bringSubview(toFront: cell.profileImageHair)
                cell.tail.image = UIImage(named: "tailRight")
                
                cell.tail.frame = CGRect(x: UIScreen.main.bounds.width - 50 - 18  , y: cell.cloud.frame.height - 33 + 10 , width: 15, height: 15)
                
                UIView.animate(withDuration: 0.2, animations: {
                    cell.cloud.alpha = 1
                    cell.messageLabel.alpha = 1
                    cell.profileImageHair.alpha = 1
                    cell.profileImageSkinColor.alpha = 1
                    cell.profileImageEyes.alpha = 1
                    cell.tail.alpha = 1
                    
                })
                
                
            }else {
                
                cell.profileImageHair.image = UIImage(named: messages[indexPath.item].avatarHair)
                cell.profileImageEyes.image = UIImage(named: messages[indexPath.item].avatarEyes)
                
                cell.profileImageHair.frame = CGRect(x: 10, y: estimateFrameForText(messageText).height - 12, width: 30, height: 30)
                cell.profileImageEyes.frame = CGRect(x: 10, y: estimateFrameForText(messageText).height - 12, width: 30, height: 30)
                cell.profileImageSkinColor.frame = CGRect(x: 10, y: estimateFrameForText(messageText).height - 12, width: 30, height: 30)
                cell.profileImageEyes.backgroundColor = Colours.getColour(named: messages[indexPath.item].avatarSkinColor.components(separatedBy: "|")[0],
                                                                          index: Int(messages[indexPath.item].avatarSkinColor.components(separatedBy: "|")[1]))
                cell.bringSubview(toFront: cell.profileImageHair)
                
                cell.messageLabel.frame = CGRect(x: 50 + 9 + 12, y: 0, width: estimateFrameForText(messageText).width + 16, height: estimateFrameForText(messageText).height + 20)
                cell.cloud.frame = CGRect(x: 50 + 12, y: 0, width: estimateFrameForText(messageText).width + 28, height: estimateFrameForText(messageText).height + 20)
                
                
                cell.cloud.backgroundColor = Colours.receivedSpeechBubble
                cell.messageLabel.backgroundColor = UIColor.clear
                
                
                cell.tail.image = UIImage(named: "tailLeft")
                cell.tail.frame = CGRect(x:  50 + 17 - 19, y: cell.cloud.frame.height - 33 + 10, width: 15, height: 15)
                
                
                
                UIView.animate(withDuration: 0.2, animations: {
                    cell.cloud.alpha = 1
                    cell.messageLabel.alpha = 1
                    cell.profileImageHair.alpha = 1
                    cell.profileImageSkinColor.alpha = 1
                    cell.profileImageEyes.alpha = 1
                    cell.tail.alpha = 1
                })
                
                
                //        collectionView.scrollToItem(at: inserctionIndexPath as IndexPath, at: .bottom, animated: false)
                if collectionView.contentSize.height - (containerViewBottomAnchor?.constant)! + 50 > collectionView.frame.size.height {
                    let offset = CGPoint(x: 0, y: collectionView.contentSize.height - collectionView.frame.size.height - (containerViewBottomAnchor?.constant)! )
                    
                    collectionView.setContentOffset(offset , animated: true)
                    
                    
                }
                
                
                
            }
            return cell
        }
        
    }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            var height: CGFloat = 80
            let messageText = messages[indexPath.item].text
            height = estimateFrameForText(messageText).height + 30
            
            //      if cellDimentionBool == true {
            //            height = 100
            //        }
            
            let width = UIScreen.main.bounds.width
            
            return CGSize(width: width , height: height)
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize(width: view.frame.width, height: 50)
        }
        
        
    func setupInputComponents() {
        
        let emoji = ServiceManager.instance.userProfile
        let newEmoji = Messages(text: inputTextField.text!, username: emoji.username, avatarHair: emoji.avatar[AvatarParts.hair]!,avatarEyes: emoji.avatar[AvatarParts.face]!, avatarSkinColor: emoji.avatar[AvatarParts.skin]!, id: emoji.id)
        
        emojiCustomView.layer.cornerRadius = 20
        
        
        let happyEmoji = UIButton()
        
        emojiCustomView.addSubview(happyEmoji)
        happyEmoji.translatesAutoresizingMaskIntoConstraints = false
        happyEmoji.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 20).isActive = true       //constrain  Button Send
        happyEmoji.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 20).isActive = true   //
        happyEmoji.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        happyEmoji.heightAnchor.constraint(equalToConstant: 100).isActive = true     //
        
        
        
        
        let happyHair = UIImageView()
        happyEmoji.addSubview(happyHair)
        happyHair.image = UIImage(named: newEmoji.avatarHair)
        happyHair.translatesAutoresizingMaskIntoConstraints = false
        happyHair.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 20).isActive = true       //constrain  Button Send
        happyHair.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 20).isActive = true   //
        happyHair.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        happyHair.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        let happyEyes = UIImageView()
        happyEmoji.addSubview(happyEyes)
        happyEyes.image = UIImage(named: newEmoji.avatarEyes)
        happyEyes.translatesAutoresizingMaskIntoConstraints = false
        happyEyes.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 20).isActive = true       //constrain  Button Send
        happyEyes.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 20).isActive = true   //
        happyEyes.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        happyEyes.heightAnchor.constraint(equalToConstant: 100).isActive = true
        happyEyes.backgroundColor = Colours.getColour(named: newEmoji.avatarSkinColor.components(separatedBy: "|")[0],
                                                      index: Int(newEmoji.avatarSkinColor.components(separatedBy: "|")[1]))
        
        let happyMount = UIImageView()
        happyEmoji.addSubview(happyMount)
        happyMount.image = UIImage(named: "Happy emoji month in the UIImageView in the customEmojiView ^EMOJI")
        happyMount.translatesAutoresizingMaskIntoConstraints = false
        happyMount.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 20).isActive = true       //constrain  Button Send
        happyMount.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 20).isActive = true   //
        happyMount.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        happyMount.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        
        
        
        
        happyEyes.layer.cornerRadius = 50
        
        
        
        happyEmoji.bringSubview(toFront: happyHair)
        
        
        
        let sadEmoji = UIButton()
        
        emojiCustomView.addSubview(sadEmoji)
        sadEmoji.translatesAutoresizingMaskIntoConstraints = false
        sadEmoji.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 20).isActive = true       //constrain  Button Send
        sadEmoji.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 140).isActive = true   //
        sadEmoji.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        sadEmoji.heightAnchor.constraint(equalToConstant: 100).isActive = true     //
        
        
        
        
        let sadHair = UIImageView()
        sadEmoji.addSubview(sadHair)
        sadHair.image = UIImage(named: newEmoji.avatarHair)
        sadHair.translatesAutoresizingMaskIntoConstraints = false
        sadHair.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 20).isActive = true       //constrain  Button Send
        sadHair.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 140).isActive = true   //
        sadHair.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        sadHair.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        let sadEyes = UIImageView()
        sadEmoji.addSubview(sadEyes)
        sadEyes.image = UIImage(named: newEmoji.avatarEyes)
        sadEyes.translatesAutoresizingMaskIntoConstraints = false
        sadEyes.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 20).isActive = true       //constrain  Button Send
        sadEyes.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 140).isActive = true   //
        sadEyes.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        sadEyes.heightAnchor.constraint(equalToConstant: 100).isActive = true
        sadEyes.backgroundColor = Colours.getColour(named: newEmoji.avatarSkinColor.components(separatedBy: "|")[0],
                                                    index: Int(newEmoji.avatarSkinColor.components(separatedBy: "|")[1]))
        
        let sadMount = UIImageView()
        sadEmoji.addSubview(sadMount)
        sadMount.image = UIImage(named: "Sad emoji month in the UIImageView in the customEmojiView ^EMOJI")
        sadMount.translatesAutoresizingMaskIntoConstraints = false
        sadMount.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 20).isActive = true       //constrain  Button Send
        sadMount.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 140).isActive = true   //
        sadMount.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        sadMount.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        sadEyes.layer.cornerRadius = 50
        
        sadEmoji.bringSubview(toFront: sadHair)
        
        
        
        
        
        
        
        
        
        let smilingEmoji = UIButton()
        
        emojiCustomView.addSubview(smilingEmoji)
        smilingEmoji.translatesAutoresizingMaskIntoConstraints = false
        smilingEmoji.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 135).isActive = true       //constrain  Button Send
        smilingEmoji.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 20).isActive = true   //
        smilingEmoji.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        smilingEmoji.heightAnchor.constraint(equalToConstant: 100).isActive = true     //
        
        
        
        
        let smilingHair = UIImageView()
        smilingEmoji.addSubview(smilingHair)
        smilingHair.image = UIImage(named: newEmoji.avatarHair)
        smilingHair.translatesAutoresizingMaskIntoConstraints = false
        smilingHair.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 135).isActive = true       //constrain  Button Send
        smilingHair.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 20).isActive = true   //
        smilingHair.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        smilingHair.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        let smilingEyes = UIImageView()
        smilingEmoji.addSubview(smilingEyes)
        smilingEyes.image = UIImage(named: newEmoji.avatarEyes)
        smilingEyes.translatesAutoresizingMaskIntoConstraints = false
        smilingEyes.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 135).isActive = true       //constrain  Button Send
        smilingEyes.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 20).isActive = true   //
        smilingEyes.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        smilingEyes.heightAnchor.constraint(equalToConstant: 100).isActive = true
        smilingEyes.backgroundColor = Colours.getColour(named: newEmoji.avatarSkinColor.components(separatedBy: "|")[0],
                                                        index: Int(newEmoji.avatarSkinColor.components(separatedBy: "|")[1]))
        
        let smilingMount = UIImageView()
        smilingEmoji.addSubview(smilingMount)
        smilingMount.image = UIImage(named: "Smiling emoji month in the UIImageView in the customEmojiView ^EMOJI")
        smilingMount.translatesAutoresizingMaskIntoConstraints = false
        smilingMount.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 135).isActive = true       //constrain  Button Send
        smilingMount.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 20).isActive = true   //
        smilingMount.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        smilingMount.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        smilingEyes.layer.cornerRadius = 50
        
        smilingEmoji.bringSubview(toFront: smilingHair)
        
        
        
        
        let cryingEmoji = UIButton()
        
        emojiCustomView.addSubview(cryingEmoji)
        cryingEmoji.translatesAutoresizingMaskIntoConstraints = false
        cryingEmoji.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 135).isActive = true       //constrain  Button Send
        cryingEmoji.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 140).isActive = true   //
        cryingEmoji.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        cryingEmoji.heightAnchor.constraint(equalToConstant: 100).isActive = true     //
        
        
        let cryingHair = UIImageView()
        cryingEmoji.addSubview(cryingHair)
        cryingHair.image = UIImage(named: newEmoji.avatarHair)
        cryingHair.translatesAutoresizingMaskIntoConstraints = false
        cryingHair.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 135).isActive = true       //constrain  Button Send
        cryingHair.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 140).isActive = true   //
        cryingHair.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        cryingHair.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        let cryingEyes = UIImageView()
        cryingEmoji.addSubview(cryingEyes)
        cryingEyes.image = UIImage(named: newEmoji.avatarEyes)
        cryingEyes.translatesAutoresizingMaskIntoConstraints = false
        cryingEyes.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 135).isActive = true       //constrain  Button Send
        cryingEyes.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 140).isActive = true   //
        cryingEyes.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        cryingEyes.heightAnchor.constraint(equalToConstant: 100).isActive = true
        cryingEyes.backgroundColor = Colours.getColour(named: newEmoji.avatarSkinColor.components(separatedBy: "|")[0],
                                                       index: Int(newEmoji.avatarSkinColor.components(separatedBy: "|")[1]))
        
        let cryingMount = UIImageView()
        cryingEmoji.addSubview(cryingMount)
        cryingMount.image = UIImage(named: "Crying emoji month in the UIImageView in the customEmojiView ^EMOJI")
        cryingMount.translatesAutoresizingMaskIntoConstraints = false
        cryingMount.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 135).isActive = true       //constrain  Button Send
        cryingMount.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 140).isActive = true   //
        cryingMount.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        cryingMount.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        cryingEyes.layer.cornerRadius = 50
        
        cryingEmoji.bringSubview(toFront: cryingHair)
        
        
        
        
        
        
        let funnyEmoji = UIButton()
        
        emojiCustomView.addSubview(funnyEmoji)
        funnyEmoji.translatesAutoresizingMaskIntoConstraints = false
        funnyEmoji.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 135 + 115).isActive = true       //constrain  Button Send
        funnyEmoji.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 20).isActive = true   //
        funnyEmoji.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        funnyEmoji.heightAnchor.constraint(equalToConstant: 100).isActive = true     //
        
        
        let funnyHair = UIImageView()
        funnyEmoji.addSubview(funnyHair)
        funnyHair.image = UIImage(named: newEmoji.avatarHair)
        funnyHair.translatesAutoresizingMaskIntoConstraints = false
        funnyHair.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 135 + 115).isActive = true       //constrain  Button Send
        funnyHair.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 20).isActive = true   //
        funnyHair.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        funnyHair.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        let funnyEyes = UIImageView()
        funnyEmoji.addSubview(funnyEyes)
        funnyEyes.image = UIImage(named: newEmoji.avatarEyes)
        funnyEyes.translatesAutoresizingMaskIntoConstraints = false
        funnyEyes.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 135 + 115).isActive = true       //constrain  Button Send
        funnyEyes.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 20).isActive = true   //
        funnyEyes.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        funnyEyes.heightAnchor.constraint(equalToConstant: 100).isActive = true
        funnyEyes.backgroundColor = Colours.getColour(named: newEmoji.avatarSkinColor.components(separatedBy: "|")[0],
                                                      index: Int(newEmoji.avatarSkinColor.components(separatedBy: "|")[1]))
        
        let funnyMount = UIImageView()
        funnyEmoji.addSubview(funnyMount)
        funnyMount.image = UIImage(named: "Funny emoji month in the UIImageView in the customEmojiView ^EMOJI")
        funnyMount.translatesAutoresizingMaskIntoConstraints = false
        funnyMount.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 135 + 115).isActive = true       //constrain  Button Send
        funnyMount.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 20).isActive = true   //
        funnyMount.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        funnyMount.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        funnyEyes.layer.cornerRadius = 50
        
        funnyEmoji.bringSubview(toFront: funnyHair)
        
        
        
        let surprisedEmoji = UIButton()
        
        emojiCustomView.addSubview(surprisedEmoji)
        surprisedEmoji.translatesAutoresizingMaskIntoConstraints = false
        surprisedEmoji.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 135 + 115).isActive = true       //constrain  Button Send
        surprisedEmoji.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 140).isActive = true   //
        surprisedEmoji.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        surprisedEmoji.heightAnchor.constraint(equalToConstant: 100).isActive = true     //
        
        
        let surprisedHair = UIImageView()
        surprisedEmoji.addSubview(surprisedHair)
        surprisedHair.image = UIImage(named: newEmoji.avatarHair)
        surprisedHair.translatesAutoresizingMaskIntoConstraints = false
        surprisedHair.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 135 + 115).isActive = true       //constrain  Button Send
        surprisedHair.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 140).isActive = true   //
        surprisedHair.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        surprisedHair.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        let surprisedEyes = UIImageView()
        surprisedEmoji.addSubview(surprisedEyes)
        surprisedEyes.image = UIImage(named: newEmoji.avatarEyes)
        surprisedEyes.translatesAutoresizingMaskIntoConstraints = false
        surprisedEyes.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 135 + 115).isActive = true       //constrain  Button Send
        surprisedEyes.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 140).isActive = true   //
        surprisedEyes.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        surprisedEyes.heightAnchor.constraint(equalToConstant: 100).isActive = true
        surprisedEyes.backgroundColor = Colours.getColour(named: newEmoji.avatarSkinColor.components(separatedBy: "|")[0],
                                                          index: Int(newEmoji.avatarSkinColor.components(separatedBy: "|")[1]))
        
        let surprisedMount = UIImageView()
        surprisedEmoji.addSubview(surprisedMount)
        surprisedMount.image = UIImage(named: "Surprised emoji month in the UIImageView in the customEmojiView ^EMOJI")
        surprisedMount.translatesAutoresizingMaskIntoConstraints = false
        surprisedMount.leftAnchor.constraint(equalTo: emojiCustomView.leftAnchor,constant: 135 + 115).isActive = true       //constrain  Button Send
        surprisedMount.topAnchor.constraint(equalTo: emojiCustomView.topAnchor,constant: 140).isActive = true   //
        surprisedMount.widthAnchor.constraint(equalToConstant: 100).isActive = true                      //
        surprisedMount.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        surprisedEyes.layer.cornerRadius = 50
        
        surprisedEmoji.bringSubview(toFront: surprisedHair)
        
        
        
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        notificationView.backgroundColor = UIColor.white
        notificationView.layer.cornerRadius = 20
        self.view.addSubview(notificationView)
        notificationView.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 8).isActive = true       //constrain  Button Send
        notificationView.topAnchor.constraint(equalTo: view.topAnchor,constant: 75).isActive = true   //
        notificationView.widthAnchor.constraint(equalToConstant: 359).isActive = true                      //
        notificationView.heightAnchor.constraint(equalToConstant: 112).isActive = true     //
        
        
        
        //        notificationView.translatesAutoresizingMaskIntoConstraints = false
        //        notificationView.backgroundColor = UIColor.white
        //        notificationView.layer.cornerRadius = 5
        //        self.view.addSubview(notificationView)
        //        notificationView.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 8).isActive = true       //constrain  Button Send
        //        notificationView.topAnchor.constraint(equalTo: view.topAnchor,constant: 75).isActive = true   //
        //        notificationView.widthAnchor.constraint(equalToConstant: 359).isActive = true                      //
        //        notificationView.heightAnchor.constraint(equalToConstant: 112).isActive = true     //
        
        self.view.addSubview(notificationText)
        self.notificationText.alpha = 0
        self.notificationText.translatesAutoresizingMaskIntoConstraints = false
        self.notificationText.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 8).isActive = true       //constrain  Button Send
        self.notificationText.topAnchor.constraint(equalTo: view.topAnchor,constant: 75).isActive = true   //
        self.notificationText.widthAnchor.constraint(equalToConstant: 359).isActive = true                      //
        self.notificationText.heightAnchor.constraint(equalToConstant: 112).isActive = true     ///
        self.notificationText.font = UIFont(name: "Futura-Medium", size: 20)
        self.notificationText.text = "Remember you can chat only for 5 minutes."
        self.notificationText.layer.cornerRadius = 5
        
        
        
        self.view.addSubview(emojiCustomView)
        //        emojiCustomView.translatesAutoresizingMaskIntoConstraints = false
        
        emojiCustomView.frame = CGRect(x: 0, y: 667, width: view.frame.size.width, height: 0)
        
        emojiCustomView.backgroundColor = UIColor.white
        
        
        happyEmoji.addTarget(self, action: #selector(happyEmojiButton), for: .touchUpInside)
        sadEmoji.addTarget(self, action: #selector(sadEmojiButton), for: .touchUpInside)
        smilingEmoji.addTarget(self, action: #selector(smilingEmojiButton), for: .touchUpInside)
        cryingEmoji.addTarget(self, action: #selector(cryingEmojiButton), for: .touchUpInside)
        funnyEmoji.addTarget(self, action: #selector(funnyEmojiButton), for: .touchUpInside)
        surprisedEmoji.addTarget(self, action: #selector(surprisedEmojiButton), for: .touchUpInside)
        
        let containerView = UIView()                                    //creation of the writing container view
        containerView.translatesAutoresizingMaskIntoConstraints = false //(cercare a cosa serve)
        containerView.backgroundColor = Colours.backgroundSecondary     //
        self.view.addSubview(containerView)                             //
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true       //setting constarain
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true     //
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true          //
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        
        
        let borderInput = UIView()
        containerView.addSubview(borderInput)
        
      
        sendButton.setTitle(NSLocalizedString("send", comment: ""), for: .normal)                       //
        sendButton.translatesAutoresizingMaskIntoConstraints = false    //
        containerView.addSubview(sendButton)                            //
        
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)      //setting send button function (handleSend isn't created yet go down)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: -5).isActive = true       //constrain  Button Send
        sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -5).isActive = true   //
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true                      //
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor,constant: -10).isActive = true     //
        sendButton.layer.cornerRadius = 20
        sendButton.layer.borderColor = UIColor.gray.cgColor
        sendButton.layer.borderWidth = 0.5
        sendButton.backgroundColor = UIColor.white
        
        containerView.addSubview(inputTextField)            //add the textField to the containerView
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor , constant: 15 + 50).isActive = true        //contraint textField  (constant: 8 --> serve per spostare di 8 pixel la scritta "enter text..." dal margine della UIView )
        inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -5).isActive = true     //
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor,constant: -10).isActive = true          //we are using this constaraint to extend the textField right anchor untill left anchor send button
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor,constant: -10).isActive = true    //
        
        
        let plusButton = UIButton(type: .system)
        containerView.addSubview(plusButton)
        plusButton.setTitle("+", for: .normal)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        plusButton.layer.cornerRadius = 20
        plusButton.layer.borderColor = UIColor.gray.cgColor
        plusButton.layer.borderWidth = 0.5
        plusButton.backgroundColor = UIColor.white
        
        
        plusButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        plusButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -5).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        plusButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        
        //        plusButton.addTarget(self, action: #selector(plus), for: .touchUpInside)
        
        plusButton.addTarget(self, action: #selector(plus), for: .touchUpInside)
        
        
        borderInput.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        
        borderInput.leftAnchor.constraint(equalTo: plusButton.rightAnchor, constant: 5).isActive = true
        borderInput.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -5).isActive = true
        borderInput.rightAnchor.constraint(equalTo: sendButton.leftAnchor,constant: -5).isActive = true
        borderInput.heightAnchor.constraint(equalTo: containerView.heightAnchor,constant: -10).isActive = true
        
        borderInput.layer.cornerRadius = 20
        borderInput.backgroundColor = UIColor.white
        borderInput.layer.borderColor = UIColor.gray.cgColor
        borderInput.layer.borderWidth = 0.5
        
        let separatorLineView = UIView()                                        //adding separator line between text field and messages
        separatorLineView.backgroundColor = UIColor.gray                        //
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false     //
        containerView.addSubview(separatorLineView)                             //
        
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true         //contraint line separator
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true           //
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true       //
        separatorLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true                    //
        //        timeLabel.text = "time: \(timeString(time: timeCount))"
    }
    
    
    
    @objc func send() {
        //function to send messages
        
        
        
        
        if inputTextField.text != "" {
            
            for char in inputTextField.text!.enumerated() {
                if (char.element == "^") {
                    
                    notificationText.text = "You can't send this '^' character!"
                    notificationText.textColor = UIColor.black
                    inputTextField.text = ""
                    UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: self.show, completion: {(complete : Bool) -> Void in
                        UIView.animate(withDuration: 1.0, delay: 2.0, options: UIViewAnimationOptions.curveLinear, animations: self.hide)})
                    
                    return
                }
            }
            
            createMessages(input: inputTextField)
            inputTextField.text = ""
        }
        //        cellDimentionBool = false
        //        a = 30
    }
    
    
    
    
    
    
    @objc func plus() {
        UIView.animate(withDuration: 0.35, animations: {
            self.emojiCustomView.frame.origin.y = 359
            self.emojiCustomView.frame.size.height = 280
            self.view.endEditing(true)
        })
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {          // this function allow you to send messages using enter
        self.send()
        return true
    }
    
    
    @objc func happyEmojiButton() {
        
        mouthName.text = "Happy emoji month in the UIImageView in the customEmojiView ^EMOJI"
        createEmoji(input: mouthName)
        UIView.animate(withDuration: 0.35, animations: {
            self.emojiCustomView.frame.origin.y = 667
            
            self.emojiCustomView.frame.size.height = 0
            self.containerViewBottomAnchor?.constant = 0
        })
    }
    
    @objc func sadEmojiButton() {
        
        mouthName.text = "Sad emoji month in the UIImageView in the customEmojiView ^EMOJI"
        createEmoji(input: mouthName)
        UIView.animate(withDuration: 0.35, animations: {
            self.emojiCustomView.frame.origin.y = 667
            
            self.emojiCustomView.frame.size.height = 0
            self.containerViewBottomAnchor?.constant = 0
        })
    }
    
    @objc func smilingEmojiButton() {
        
        mouthName.text = "Smiling emoji month in the UIImageView in the customEmojiView ^EMOJI"
        createEmoji(input: mouthName)
        UIView.animate(withDuration: 0.35, animations: {
            self.emojiCustomView.frame.origin.y = 667
            
            self.emojiCustomView.frame.size.height = 0
            self.containerViewBottomAnchor?.constant = 0
        })
    }
    
    @objc func cryingEmojiButton() {
        
        mouthName.text = "Crying emoji month in the UIImageView in the customEmojiView ^EMOJI"
        createEmoji(input: mouthName)
        UIView.animate(withDuration: 0.35, animations: {
            self.emojiCustomView.frame.origin.y = 667
            
            self.emojiCustomView.frame.size.height = 0
            self.containerViewBottomAnchor?.constant = 0
        })
    }
    
    @objc func funnyEmojiButton() {
        
        mouthName.text = "Funny emoji month in the UIImageView in the customEmojiView ^EMOJI"
        createEmoji(input: mouthName)
        UIView.animate(withDuration: 0.35, animations: {
            self.emojiCustomView.frame.origin.y = 667
            
            self.emojiCustomView.frame.size.height = 0
            self.containerViewBottomAnchor?.constant = 0
        })
    }
    
    @objc func surprisedEmojiButton() {
        
        mouthName.text = "Surprised emoji month in the UIImageView in the customEmojiView ^EMOJI"
        createEmoji(input: mouthName)
        UIView.animate(withDuration: 0.35, animations: {
            self.emojiCustomView.frame.origin.y = 667
            
            self.emojiCustomView.frame.size.height = 0
            self.containerViewBottomAnchor?.constant = 0
        })
    }
    
    @objc func createEmoji(input: UITextField) {
        let emoji = ServiceManager.instance.userProfile
        let newEmoji = Messages(text: input.text!, username: emoji.username, avatarHair: emoji.avatar[AvatarParts.hair]!,avatarEyes: emoji.avatar[AvatarParts.face]!, avatarSkinColor: emoji.avatar[AvatarParts.skin]!, id: emoji.id)
        if let peer = ServiceManager.instance.selectedPeer {
            ServiceManager.instance.chatService.send(message: "\(MPCMessageTypes.message)|\(newEmoji.toString())", toPeer: peer.key)
        }
        //        cellDimentionBool = true
        //        a = 100
    }
    
    
    func createMessages( input: UITextField) {
        let profile = ServiceManager.instance.userProfile
        let newMessage = Messages(text: inputTextField.text! , username: profile.username, avatarHair: profile.avatar[AvatarParts.hair]!,avatarEyes: profile.avatar[AvatarParts.face]!, avatarSkinColor: profile.avatar[AvatarParts.skin]!, id: profile.id)
        if let peer = ServiceManager.instance.selectedPeer {
            ServiceManager.instance.chatService.send(message: "\(MPCMessageTypes.message)|\(newMessage.toString())", toPeer: peer.key)
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        if let peer = ServiceManager.instance.selectedPeer {
            ServiceManager.instance.chatService.send(message: "\(MPCMessageTypes.closeConnection)|null", toPeer: peer.key)
        }
    }
    
    @objc func receivedMessage(_ notification: NSNotification){
        if let message = notification.userInfo?["message"] as? [String] {
            OperationQueue.main.addOperation {
                self.messages.append(Messages.setMessage(from: message))
                self.chatCollectionView.reloadData()
            }
        }
    }
   
        
        
    
        
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            switch kind {
            case UICollectionElementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
                if let label = headerView.viewWithTag(0451) as? UILabel {
                    label.text =
                    """
                    Wordfy your emojis
                    \(self.stringEmoji)
                    """
                    label.sizeToFit()
                    label.center = headerView.center
                }
                
                return headerView
            case UICollectionElementKindSectionFooter:
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
                return footerView
            default:
                assert(false, "Unexpected element kind")
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            if (self.stringEmoji.isEmpty) {
                return CGSize.zero
            } else {
                return CGSize(width: self.chatCollectionView.bounds.width, height: 96)
            }
        }
    
    
}

