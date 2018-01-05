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
    var stringEmoji: String = ""
    @IBOutlet weak var chatCollectionView : UICollectionView!
    
    lazy var inputTextField: UITextField = {                        //this is the declaration of the input textField and the textField we need to write and having a reference to use function handleSend
        let textField = UITextField()                               //
        textField.placeholder = NSLocalizedString("chat_placeholder", comment: "")                  //
        textField.translatesAutoresizingMaskIntoConstraints = false //
        textField.delegate = self                                   //we need this to use enter to send messages
        return textField                                            //
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        chatCollectionView.alwaysBounceVertical = true
        setupKeyboard()
        self.tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(self.tap)
        startTimer()
        self.inputTextField.text = self.stringEmoji
        self.send()
        self.inputTextField.text = ""
    }
    
    var timeLabel = UILabel()
    var timer = Timer()
    var timeCount: TimeInterval = 300
    let timeInterval: TimeInterval = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = tabBarController {
            tabBarController.tabBar.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let background = self.view.viewWithTag(0451) {
            UIView.animate(withDuration: 0.35, animations: {
                background.alpha = 0.6
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    @objc func updateTime() {
        timeLabel.text = "\(timeString(time: timeCount))"
        if timeCount != 0 {
            timeCount -= 1
            
        }else {
            endTimer()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    
    func endTimer() {
        timer.invalidate()
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
        
        
        
        if messages[indexPath.item].id == ServiceManager.instance.userProfile.id {
            
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
            cell.tail.image = UIImage(named: "tailRight")
            
            cell.tail.frame = CGRect(x: UIScreen.main.bounds.width - 50 - 18, y: cell.cloud.frame.height - 33, width: 20, height: 25)
            
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
            
            
            cell.cloud.backgroundColor = Colours.receivedSpeechBubble
            cell.messageLabel.backgroundColor = UIColor.clear
            
            
            cell.tail.image = UIImage(named: "tailLeft")
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
        sendButton.layer.borderColor = UIColor.gray.cgColor
        sendButton.layer.borderWidth = 0.5
        sendButton.backgroundColor = UIColor.white
        
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
        timeLabel.text = "time: \(timeString(time: timeCount))"
    }
    
    @objc func send() {
        //function to send messages
        if inputTextField.text != "" {
            createMessages(input: inputTextField)
            inputTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {          // this function allow you to send messages using enter
        self.send()
        return true
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
}







