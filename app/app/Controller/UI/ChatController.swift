//
//  ChatController.swift
//  App
//
//  Created by Davide Contaldo on 14/12/17.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit

//class for the chat
class ChatController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout{
    
    private let cellId = "cellID"
    
    var profile1 = Profile()
    
    
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
        self.view.backgroundColor = Colours.background
        profile1.name = "1"
        profile1.profileImageName = "roguemonkeyblog"
        setupInputComponents()   //container view for chat writing
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(SingleChatCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        //        setupData()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SingleChatCell
        cell.message = messages[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func setupInputComponents() {
        
        let containerView = UIView()                                    //creation of the writing container view
        //containerView.backgroundColor = UIColor.red                   // need only for test
        //containerView.tintColorDidChange(UIColor.red)                 //
        containerView.translatesAutoresizingMaskIntoConstraints = false //(cercare a cosa serve)
        containerView.backgroundColor = UIColor.white                                                                //
        self.view.addSubview(containerView)                             //
        
        //containerView.frame = CGRect(x: 100, y: 100, width: view.frame.width, height: 80)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true       //setting constarain
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true   //
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true     //
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true          //
        
        
        
        
        let sendButton = UIButton(type: .system)                        //create Button Send (type: .system -->serve per far diventare il bottone bianco quando lo premi)
        sendButton.setTitle("Send", for: .normal)                       //
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
        
        
        var titleNameChat = UIView()                                     //adding space where putting nameChat
        titleNameChat.translatesAutoresizingMaskIntoConstraints = false  //(cercare a cosa serve)
        
        self.view.addSubview(titleNameChat)                              //adding titleNameChat to view
        
        titleNameChat.backgroundColor = UIColor.white
        
        titleNameChat.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true       //setting titleNameChat constraints
        titleNameChat.topAnchor.constraint(equalTo: view.topAnchor).isActive = true         //
        titleNameChat.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true     //
        titleNameChat.heightAnchor.constraint(equalToConstant: 100).isActive = true         //
        
        
        
        var nameChat = UILabel()                                    //nameChat declaration
        nameChat.translatesAutoresizingMaskIntoConstraints = false  //
        nameChat.text = "nameChatID"                                //
        
        titleNameChat.addSubview(nameChat)              //adding nameChat to titleNameChat
        
        nameChat.centerXAnchor.constraint(equalTo: titleNameChat.centerXAnchor, constant: 150).isActive = true    //constraints for nameChat
        nameChat.centerYAnchor.constraint(equalTo: titleNameChat.centerYAnchor).isActive = true      //
        nameChat.widthAnchor.constraint(equalTo: titleNameChat.widthAnchor).isActive = true  //
        nameChat.heightAnchor.constraint(equalToConstant: 100).isActive = true               //
        
        
        
        
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
        createMessages(input: inputTextField, name: profile1)
        
        self.collectionView?.reloadData()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {          // this function allow you to send messages using enter
        send()
        return true
    }
    
    func createMessages( input: UITextField, name: Profile) {
        let newMessage = Messages()
        newMessage.text = input.text
        newMessage.profile = name
        messages.append(newMessage)
        
    }
    
}





