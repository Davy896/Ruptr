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
//        profile1.name = "1"
//        profile1.profileImageName = "roguemonkeyblog"
        self.view.backgroundColor = Colours.background
        setupInputComponents()   //container view for chat writing
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(SingleChatCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        setupKeyboard()
//        collectionView?.keyboardDismissMode = .interactive
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.view.endEditing(true)
    }
    
    
    
//    override var inputAccessoryView: UIView? {
//        get {
//            let containerView = UIView()
//            containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
//            containerView.backgroundColor = UIColor.lightGray
//            return containerView
//        }
//    }
//
//
//    override func becomeFirstResponder() -> Bool {
//        return true
//    }
    
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
        //        let size = CGSize(width: UIScreen.main.bounds.width, height: 1000)
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SingleChatCell
        cell.message = messages[indexPath.item]

        let messageText = messages[indexPath.item].text
        let avatar = messages[indexPath.item].avatar
        cell.messageLabel.isEditable = false
        if messages[indexPath.item].isSend == true {
            cell.profileImageView.image = #imageLiteral(resourceName: "avatar0")
            cell.messageLabel.frame = CGRect(x: UIScreen.main.bounds.width - estimateFrameForText(messageText).width - 18 - 50, y: 0, width: estimateFrameForText(messageText).width + 16, height: estimateFrameForText(messageText).height + 20)
            cell.messageLabel.backgroundColor = UIColor.blue
            
            cell.profileImageView.frame = CGRect(x: UIScreen.main.bounds.width - 45, y: estimateFrameForText(messageText).height - 12, width: 30, height: 30)
//            cell.profileImageView.leftAnchor.constraint(equalTo: cell.messageLabel.rightAnchor, constant: 10)
//            cell.profileImageView.bottomAnchor.constraint(equalTo: cell.messageLabel.bottomAnchor)
//            cell.profileImageView.widthAnchor.constraint(equalToConstant: 30)
//            cell.profileImageView.widthAnchor.constraint(equalToConstant: 30)
//
            
           
            
        } else {
            cell.profileImageView.image = #imageLiteral(resourceName: "avatar0")
            cell.profileImageView.frame = CGRect(x: 10, y: estimateFrameForText(messageText).height - 12, width: 30, height: 30)
            cell.messageLabel.frame = CGRect(x: 50 , y: 0, width: estimateFrameForText(messageText).width + 16, height: estimateFrameForText(messageText).height + 20)
            cell.messageLabel.backgroundColor = UIColor.lightGray
        }
        
        let item = messages.count - 1
        let inserctionIndexPath = NSIndexPath(item: item, section: 0)
        
        collectionView.scrollToItem(at: inserctionIndexPath as IndexPath, at: .bottom, animated: true)
        
        
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SingleChatCell
        var height: CGFloat = 80
        let messageText = messages[indexPath.item].text
        height = estimateFrameForText(messageText).height + 30
        
//        cell.messageLabel.frame = estimateFrameForText(messageText).width
       
//        let width = estimateFrameForText(messageText).width
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
        
        
        
        
        
        let containerView = UIView()                                    //creation of the writing container view
        //containerView.backgroundColor = UIColor.red                   // need only for test
        //containerView.tintColorDidChange(UIColor.red)                 //
        containerView.translatesAutoresizingMaskIntoConstraints = false //(cercare a cosa serve)
        containerView.backgroundColor = UIColor.white                                                                //
        self.view.addSubview(containerView)                             //
        
        //containerView.frame = CGRect(x: 100, y: 100, width: view.frame.width, height: 80)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true       //setting constarain
//        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true   //
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true     //
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true          //
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        
        
        let sendButton = UIButton(type: .system)                        //create Button Send (type: .system -->serve per far diventare il bottone bianco quando lo premi)
        sendButton.setTitle(NSLocalizedString("send", comment: ""), for: .normal)                       //
        sendButton.translatesAutoresizingMaskIntoConstraints = false    //
        containerView.addSubview(sendButton)                            //
        
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)      //setting send button function (handleSend isn't created yet go down)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true       //constrain  Button Send
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true   //
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true                      //
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true     //
        
        
        /*let inputTextField = UITextField()                                          //adding textField
         inputTextField.placeholder = "Enter message..."                               //(to create a reference between the textField and the function handleSend we have to declare the textField in the top part of the code so we don't need this part anymore)
         inputTextField.translatesAutoresizingMaskIntoConstraints = false*/            //
        
        
        containerView.addSubview(inputTextField)            //add the textField to the containerView
        
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true        //contraint textField  (constant: 8 --> serve per spostare di 8 pixel la scritta "enter text..." dal margine della UIView )
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true               //
        //inputTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true                               //
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true                       //we are using this constaraint to extend the textField right anchor untill left anchor send button
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true                 //
        
        
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
      
        
        var nameChat = UILabel()                                    //nameChat declaration
        nameChat.translatesAutoresizingMaskIntoConstraints = false  //
        nameChat.text = ServiceManager.instance.userProfile.username                                //
        
        titleNameChat.addSubview(nameChat)              //adding nameChat to titleNameChat
        
        nameChat.leftAnchor.constraint(equalTo: titleNameChat.leftAnchor).isActive = true    //constraints for nameChat
        nameChat.bottomAnchor.constraint(equalTo: titleNameChat.bottomAnchor).isActive = true      //  //
        nameChat.widthAnchor.constraint(equalToConstant: 200).isActive = true  //
        nameChat.heightAnchor.constraint(equalToConstant: 100).isActive = true               //
        
        
        var simulateButton = UIButton()
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
        print(inputTextField.text)
        if inputTextField.text != "" {
            createMessages(input: inputTextField)
            
            self.collectionView?.reloadData()
        }
       
        
    }
    
    @objc func simulate() {            //function to send messages
        
        let fakeMessage = UITextField()
        fakeMessage.text = "this is a fake recived messagge"
        let profile = ServiceManager.instance.userProfile
        let newMessage = Messages(text: fakeMessage.text! , username: profile.username, avatar: profile.avatar[AvatarParts.hair]!, isSend: false)
        
        messages.append(newMessage)
        self.collectionView?.reloadData()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {          // this function allow you to send messages using enter
        send()
        return true
    }
    
    func createMessages( input: UITextField) {
        let profile = ServiceManager.instance.userProfile
        let newMessage = Messages(text: input.text! , username: profile.username, avatar: profile.avatar[AvatarParts.hair]!, isSend: true)

//        newMessage.text = input.text
        
        
    }
    
}





