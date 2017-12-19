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
    
    var messages: [Messages] = []
    var tap: UITapGestureRecognizer!
    
    lazy var inputTextField: UITextField = {                        //this is the declaration of the input textField and the textField we need to write and having a reference to use function handleSend
        let textField = UITextField()                               //
        textField.placeholder = "Enter message..."                  //
        textField.translatesAutoresizingMaskIntoConstraints = false //
        textField.delegate = self                                   //we need this to use enter to send messages
        return textField                                            //
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        UIViewController.setViewBackground(for: self)
        self.title = NSLocalizedString("chat", comment: "")
        self.view.backgroundColor = Colours.background
        setupInputComponents()                              //container view for chat writing
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(SingleChatCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        setupKeyboard()
        self.tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(self.tap)
    }
    
    
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {             //funzione di sicurezza ceh serve per non aprire diverse tastiere
        super.viewDidDisappear(animated)                            //
        NotificationCenter.default.removeObserver(self)             //
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
    
    
    
    func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SingleChatCell
        cell.message = messages[indexPath.item]
        let messageText = messages[indexPath.item].text
        cell.messageLabel.isEditable = false
       
        
        if messages[indexPath.item].isSend == true {
            
            cell.profileImageHair.image = UIImage(named: messages[indexPath.item].avatarHair)
            cell.profileImageEyes.image = UIImage(named: messages[indexPath.item].avatarEyes)
            cell.profileImageSkinColor.image = UIImage(named: messages[indexPath.item].avatarSkinColor)
           
            cell.cloud.backgroundColor = UIColor.blue
            cell.messageLabel.backgroundColor = UIColor.clear
            
            cell.cloud.frame = CGRect(x: UIScreen.main.bounds.width - estimateFrameForText(messageText).width - 27 - 50 - 18, y: 0, width: estimateFrameForText(messageText).width + 28, height: estimateFrameForText(messageText).height + 20)
            cell.messageLabel.frame = CGRect(x: UIScreen.main.bounds.width - estimateFrameForText(messageText).width - 18 - 50 - 18, y: 0, width: estimateFrameForText(messageText).width + 16, height: estimateFrameForText(messageText).height + 20)
            cell.profileImageHair.frame = CGRect(x: UIScreen.main.bounds.width - 45, y: estimateFrameForText(messageText).height - 12, width: 30, height: 30)
            cell.profileImageEyes.frame = CGRect(x: UIScreen.main.bounds.width - 45, y: estimateFrameForText(messageText).height - 12, width: 30, height: 30)
            cell.profileImageSkinColor.frame = CGRect(x: UIScreen.main.bounds.width - 45, y: estimateFrameForText(messageText).height - 12, width: 30, height: 30)
            cell.profileImageEyes.backgroundColor = Colours.getColour(named: messages[indexPath.item].avatarSkinColor.components(separatedBy: "|")[0],
                                                                      index: Int(messages[indexPath.item].avatarSkinColor.components(separatedBy: "|")[1]))
            cell.bringSubview(toFront: cell.profileImageHair)
           cell.tail.image = #imageLiteral(resourceName: "tailRight")
            
            cell.tail.frame = CGRect(x: UIScreen.main.bounds.width - 50 - 18, y: cell.cloud.frame.height - 33, width: 20, height: 25)
//
//            cell.tail.translatesAutoresizingMaskIntoConstraints = false
//
//            cell.tail.leftAnchor.constraint(equalTo: cell.cloud.leftAnchor,constant: cell.cloud.widthAnchor ).isActive = true
//            cell.tail.bottomAnchor.constraint(equalTo: cell.cloud.bottomAnchor,constant: -10).isActive = true
//            cell.tail.widthAnchor.constraint(equalToConstant: 20).isActive = true
//            cell.tail.heightAnchor.constraint(equalToConstant: 25).isActive = true
//
//
            }else {

            cell.profileImageHair.image = UIImage(named: messages[indexPath.item].avatarHair)
            cell.profileImageEyes.image = UIImage(named: messages[indexPath.item].avatarEyes)
            cell.profileImageSkinColor.image = UIImage(named: messages[indexPath.item].avatarSkinColor)
            
            cell.profileImageHair.frame = CGRect(x: 10, y: estimateFrameForText(messageText).height - 12, width: 30, height: 30)
            cell.profileImageEyes.frame = CGRect(x: 10, y: estimateFrameForText(messageText).height - 12, width: 30, height: 30)
            cell.profileImageSkinColor.frame = CGRect(x: 10, y: estimateFrameForText(messageText).height - 12, width: 30, height: 30)
            cell.profileImageEyes.backgroundColor = Colours.getColour(named: messages[indexPath.item].avatarSkinColor.components(separatedBy: "|")[0],
                                                                      index: Int(messages[indexPath.item].avatarSkinColor.components(separatedBy: "|")[1]))
            cell.bringSubview(toFront: cell.profileImageHair)
            
            cell.messageLabel.frame = CGRect(x: 50 + 9 + 12, y: 0, width: estimateFrameForText(messageText).width + 16, height: estimateFrameForText(messageText).height + 20)
            cell.cloud.frame = CGRect(x: 50 + 12, y: 0, width: estimateFrameForText(messageText).width + 28, height: estimateFrameForText(messageText).height + 20)
           
            
            cell.cloud.backgroundColor = UIColor.lightGray
            cell.messageLabel.backgroundColor = UIColor.clear
            
//             cell.tail.translatesAutoresizingMaskIntoConstraints = false
            cell.tail.image = #imageLiteral(resourceName: "tailLeft")
            
//
//            cell.tail.rightAnchor.constraint(equalTo: cell.cloud.leftAnchor,constant: 2).isActive = true
//            cell.tail.bottomAnchor.constraint(equalTo: cell.cloud.bottomAnchor,constant: -10).isActive = true
//            cell.tail.widthAnchor.constraint(equalToConstant: 20).isActive = true
//            cell.tail.heightAnchor.constraint(equalToConstant: 25).isActive = true
//
            
            cell.tail.frame = CGRect(x:  50 + 12 - 19, y: cell.cloud.frame.height - 33, width: 20, height: 25)
            
        }
        
        let item = messages.count - 1
        let inserctionIndexPath = NSIndexPath(item: item, section: 0)
        
        collectionView.scrollToItem(at: inserctionIndexPath as IndexPath, at: .bottom, animated: true)
        
        
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let messageText = messages[indexPath.item].text
        height = estimateFrameForText(messageText).height + 30
        let width = UIScreen.main.bounds.width
        return CGSize(width: width , height: height)
 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 80)
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func setupInputComponents() {
        
        
        
        let myColor = UIColor.lightGray
        
        let containerView = UIView()                                    //creation of the writing container view
        containerView.translatesAutoresizingMaskIntoConstraints = false //(cercare a cosa serve)
        containerView.backgroundColor = UIColor.white                                                             //
        self.view.addSubview(containerView)                             //
  
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true       //setting constarain
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true     //
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true          //
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        
        
        let borderInput = UIView()
        containerView.addSubview(borderInput)
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle(NSLocalizedString("send", comment: ""), for: .normal)                       //
        sendButton.translatesAutoresizingMaskIntoConstraints = false    //
        containerView.addSubview(sendButton)                            //
        
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)      //setting send button function (handleSend isn't created yet go down)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: -5).isActive = true       //constrain  Button Send
        sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -5).isActive = true   //
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true                      //
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor,constant: -10).isActive = true     //
        sendButton.layer.cornerRadius = 20
        sendButton.layer.borderColor = myColor.cgColor
        sendButton.layer.borderWidth = 0.5
        
        var highlighted: Bool = false {
            didSet {
                if highlighted {
                    sendButton.backgroundColor = UIColor.lightGray
                } else {
                    sendButton.backgroundColor = UIColor.white
                }
            }
        }
        
        
        containerView.addSubview(inputTextField)            //add the textField to the containerView
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 15).isActive = true        //contraint textField  (constant: 8 --> serve per spostare di 8 pixel la scritta "enter text..." dal margine della UIView )
        inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -5).isActive = true     //
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor,constant: -10).isActive = true          //we are using this constaraint to extend the textField right anchor untill left anchor send button
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor,constant: -10).isActive = true    //

        borderInput.translatesAutoresizingMaskIntoConstraints = false
        
        borderInput.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        borderInput.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: -5).isActive = true
        borderInput.rightAnchor.constraint(equalTo: sendButton.leftAnchor,constant: -5).isActive = true
        borderInput.heightAnchor.constraint(equalTo: containerView.heightAnchor,constant: -10).isActive = true
        
        borderInput.layer.cornerRadius = 20
        borderInput.backgroundColor = UIColor.white
        borderInput.layer.borderColor = myColor.cgColor
        borderInput.layer.borderWidth = 0.5
        borderInput.backgroundColor = UIColor.clear
        
        let separatorLineView = UIView()                                        //adding separator line between text field and messages
        separatorLineView.backgroundColor = UIColor.gray                        //
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false     //
        containerView.addSubview(separatorLineView)                             //
        
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true         //contraint line separator
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true           //
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true       //
        separatorLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true                    //
        
        
        let titleNameChat = UIView()                                     //adding space where putting nameChat
        titleNameChat.translatesAutoresizingMaskIntoConstraints = false  //(cercare a cosa serve)
        
        self.view.addSubview(titleNameChat)                              //adding titleNameChat to view
        
        titleNameChat.backgroundColor = UIColor.white
        
        titleNameChat.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true       //setting titleNameChat constraints
        titleNameChat.topAnchor.constraint(equalTo: view.topAnchor).isActive = true         //
        titleNameChat.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true     //
        titleNameChat.heightAnchor.constraint(equalToConstant: 100).isActive = true         //
      
        
        let nameChat = UILabel()                                    //nameChat declaration
        nameChat.translatesAutoresizingMaskIntoConstraints = false  //
        nameChat.text = ServiceManager.instance.userProfile.username                                //
        
        titleNameChat.addSubview(nameChat)              //adding nameChat to titleNameChat
        
        nameChat.leftAnchor.constraint(equalTo: titleNameChat.leftAnchor).isActive = true    //constraints for nameChat
        nameChat.bottomAnchor.constraint(equalTo: titleNameChat.bottomAnchor).isActive = true      //  //
        nameChat.widthAnchor.constraint(equalToConstant: 200).isActive = true  //
        nameChat.heightAnchor.constraint(equalToConstant: 100).isActive = true               //
        
        
        let simulateButton = UIButton()
        simulateButton.translatesAutoresizingMaskIntoConstraints = false
        simulateButton.setTitle(NSLocalizedString("send", comment: ""), for: .normal)
        titleNameChat.addSubview(simulateButton)
        
        simulateButton.addTarget(self, action: #selector(simulate), for: .touchUpInside)      //setting send button function (handleSend isn't created yet go down)
        simulateButton.setTitleColor(UIColor.blue, for: .normal)
        
        simulateButton.leftAnchor.constraint(equalTo: nameChat.rightAnchor, constant: 100).isActive = true    //constraints for nameChat
        simulateButton.bottomAnchor.constraint(equalTo: titleNameChat.bottomAnchor).isActive = true      //
        simulateButton.widthAnchor.constraint(equalToConstant: 100).isActive = true  //
        simulateButton.heightAnchor.constraint(equalToConstant: 100).isActive = true               //
        
        
        
        let separatorLineView2 = UIView()                                        //adding separator line2  between titleNameChat and messages
        separatorLineView2.backgroundColor = UIColor.gray                        //
        separatorLineView2.translatesAutoresizingMaskIntoConstraints = false     //
        titleNameChat.addSubview(separatorLineView2)                             //
        //titleNameChat.addSubview(collectionView.heade)
        
        separatorLineView2.leftAnchor.constraint(equalTo: titleNameChat.leftAnchor).isActive = true         //contraint line separator 2
        separatorLineView2.bottomAnchor.constraint(equalTo: titleNameChat.bottomAnchor).isActive = true     //
        separatorLineView2.widthAnchor.constraint(equalTo: titleNameChat.widthAnchor).isActive = true       //
        separatorLineView2.heightAnchor.constraint(equalToConstant: 0.5).isActive = true                    //
        
        
    }
    
    @objc func send() {            //function to send messages
        print(inputTextField.text ?? "")
        if inputTextField.text != "" {
            createMessages(input: inputTextField)
            inputTextField.text = ""
            self.collectionView?.reloadData()
        }
       
        
    }
    
    @objc func simulate() {            //function to send messages
        
        let fakeMessage = UITextField()
        fakeMessage.text = "this is a fake recived messagge gggggggggggggggggggggggg"
        let profile = ServiceManager.instance.userProfile
        let newMessage = Messages(text: fakeMessage.text! , username: profile.username, avatarHair: profile.avatar[AvatarParts.hair]!,avatarEyes: profile.avatar[AvatarParts.face]!, avatarSkinColor: profile.avatar[AvatarParts.skin]!, isSend: false)
//        let newMessage = Messages(text: fakeMessage.text! , username: profile.username, avatar: "hairstyle_0_black", isSend: false)
        
        messages.append(newMessage)
        self.collectionView?.reloadData()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {          // this function allow you to send messages using enter
        send()
        return true
    }
    
    func createMessages( input: UITextField) {
        let profile = ServiceManager.instance.userProfile
        let newMessage = Messages(text: inputTextField.text! , username: profile.username, avatarHair: profile.avatar[AvatarParts.hair]!,avatarEyes: profile.avatar[AvatarParts.face]!, avatarSkinColor: profile.avatar[AvatarParts.skin]! , isSend: true)
        
        messages.append(newMessage)

        
        
    }
    
}





