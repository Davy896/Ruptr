//
//  GameViewControl.swift
//  FirstMini
//
//  Created by Alessio Tortello on 13/12/2017.
//  Copyright © 2017 Alessio Tortello. All rights reserved.
//

import UIKit
import ISEmojiView
import MultipeerConnectivity

class GameViewControlller: UIViewController, ISEmojiViewDelegate {
    
    @IBOutlet var emojiTextFields: [UITextField]!
    @IBOutlet weak var firstEmojiField: UITextField!
    var isPlayerOneTurn: Bool = true
    
    static var arrayEmoji: [String] = ["😀" , "😃" , "😄" , "😁" , "😆" , "😅" , "😂" , "🤣" , "☺️" , "😊" , "😇" , "🙂" , "🙃" , "😉" , "😌" , "😍" , "😘" , "😗" , "😙" , "😚" , "😋" , "😜" , "😝" , "😛" , "🤑" , "🤗" , "🤓" , "😎" , "🤡" , "🤠" , "😏" , "😒" , "😞" , "😔" , "😟" , "😕" , "🙁" , "☹️" , "😣" , "😖" , "😫" , "😩" , "😤" , "😠" , "😡" , "😶" , "😐" , "😑" , "😯" , "😦" , "😧" , "😮" , "😲" , "😵" , "😳" , "😱" , "😨" , "😰" , "😢" , "😥" , "🤤" , "😭" , "😓" , "😪" , "😴" , "🙄" , "🤔" , "🤥" , "😬" , "🤐" , "🤢" , "🤧" , "😷" , "🤒" , "🤕" , "😈" , "👿" , "👹" , "👺" , "💩" , "👻" , "💀" , "☠️" , "👽" , "👾" , "🤖" , "🎃" , "😺" , "😸" , "😹" , "😻" , "😼" , "😽" , "🙀" , "😿" , "😾" , "👐" , "🙌" , "👏" , "🙏" , "🤝" , "👍" , "👎" , "👊" , "✊" , "🤛" , "🤜" , "🤞" , "✌️" , "🤘" , "👌" , "👈" , "👉" , "👆" , "👇" , "☝️" , "✋" , "🤚" , "🖐" , "🖖" , "👋" , "🤙" , "💪" , "🖕" , "✍️" , "🤳" , "💅" , "🖖" , "💄" , "💋" , "👄" , "👅" , "👂" , "👃" , "👣" , "👁" , "👀" , "🗣" , "👤" , "👥" , "👶" , "👦" , "👧" , "👨" , "👩" , "👱‍♀️" , "👱" , "👴" , "👵" , "👲" , "👳‍♀️" , "👳" , "👮‍♀️" , "👮" , "👷‍♀️" , "👷" , "💂‍♀️" , "💂" , "🕵️‍♀️" , "🕵️" , "👩‍⚕️" , "👨‍⚕️" , "👩‍🌾" , "👨‍🌾" , "👩‍🍳" , "👨‍🍳" , "👩‍🎓" , "👨‍🎓" , "👩‍🎤" , "👨‍🎤" , "👩‍🏫" , "👨‍🏫" , "👩‍🏭" , "👨‍🏭" , "👩‍💻" , "👨‍💻" , "👩‍💼" , "👨‍💼" , "👩‍🔧" , "👨‍🔧" , "👩‍🔬" , "👨‍🔬" , "👩‍🎨" , "👨‍🎨" , "👩‍🚒" , "👨‍🚒" , "👩‍✈️" , "👨‍✈️" , "👩‍🚀" , "👨‍🚀" , "👩‍⚖️" , "👨‍⚖️" , "🤶" , "🎅" , "👸" , "🤴" , "👰" , "🤵" , "👼" , "🤰" , "🙇‍♀️" , "🙇" , "💁" , "💁‍♂️" , "🙅" , "🙅‍♂️" , "🙆" , "🙆‍♂️" , "🙋" , "🙋‍♂️" , "🤦‍♀️" , "🤦‍♂️" , "🤷‍♀️" , "🤷‍♂️" , "🙎" , "🙎‍♂️" , "🙍" , "🙍‍♂️" , "💇" , "💇‍♂️" , "💆" , "💆‍♂️" , "🕴" , "💃" , "🕺" , "👯" , "👯‍♂️" , "🚶‍♀️" , "🚶" , "🏃‍♀️" , "🏃" , "👫" , "👭" , "👬" , "💑" , "👩‍❤️‍👩" , "👨‍❤️‍👨" , "💏" , "👩‍❤️‍💋‍👩" , "👨‍❤️‍💋‍👨" , "👪" , "👨‍👩‍👧" , "👨‍👩‍👧‍👦" , "👨‍👩‍👦‍👦" , "👨‍👩‍👧‍👧" , "👩‍👩‍👦" , "👩‍👩‍👧" , "👩‍👩‍👧‍👦" , "👩‍👩‍👦‍👦" , "👩‍👩‍👧‍👧" , "👨‍👨‍👦" , "👨‍👨‍👧" , "👨‍👨‍👧‍👦" , "👨‍👨‍👦‍👦" , "👨‍👨‍👧‍👧" , "👩‍👦" , "👩‍👧" , "👩‍👧‍👦" , "👩‍👦‍👦" , "👩‍👧‍👧" , "👨‍👦" , "👨‍👧" , "👨‍👧‍👦" , "👨‍👦‍👦" , "👨‍👧‍👧" , "👚" , "👕" , "👖" , "👔" , "👗" , "👙" , "👘" , "👠" , "👡" , "👢" , "👞" , "👟" , "👒" , "🎩" , "🎓" , "👑" , "⛑" , "🎒" , "👝" , "👛" , "👜" , "💼" , "👓" , "🕶" , "🌂" , "☂️" ]
    
    static var randomEmoji = "😀"
    static var isPlayerOne = false
    
    
    
    var currentTag = 0
    
    var emojiKeyboard: ISEmojiView! {
        didSet {
            self.emojiKeyboard.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.setViewBackground(for: self)
        NotificationCenter.default.addObserver(self, selector: #selector(receivedEmoji), name: NSNotification.Name(rawValue: "received_emoji"), object: nil)
        
        // first emoji
        self.firstEmojiField.text = GameViewControlller.randomEmoji
        self.firstEmojiField.inputView = self.emojiKeyboard
        self.firstEmojiField.isEnabled = false
        
        self.title = NSLocalizedString("game", comment: "")
        self.emojiKeyboard = ISEmojiView()
        self.emojiKeyboard.delegate = self
        self.emojiKeyboard.collectionView.backgroundColor = Colours.backgroundSecondary
        
        
        for field in emojiTextFields {
            field.inputView = emojiKeyboard
            if (field.tag == 0 && GameViewControlller.isPlayerOne) {
                field.isEnabled = true
            } else {
                field.isEnabled = false
            }
        }
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: NSLocalizedString("back", comment: ""), style: UIBarButtonItemStyle.plain, target: self, action: #selector(GameViewControlller.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (GameViewControlller.isPlayerOne) {
            self.emojiTextFields[0].becomeFirstResponder()
        }
    }
    
    func emojiViewDidSelectEmoji(emojiView: ISEmojiView, emoji: String) {
        if let peer = ServiceManager.instance.selectedPeer {
            ServiceManager.instance.chatService.send(message: "\(MPCMessageTypes.emoji)|\(emoji)", toPeer: peer.key)
        }
    }
    
    
    func emojiViewDidPressDeleteButton(emojiView: ISEmojiView) {
        for textField in emojiTextFields {
            if (textField.tag == currentTag) {
                textField.deleteBackward()
                break
            }
        }
    }
    
    @objc func receivedEmoji(_ notification: NSNotification){
        if let emoji = notification.userInfo?["emoji"] as? String {
            OperationQueue.main.addOperation {
                for textField in self.emojiTextFields {
                    if (textField.tag == self.currentTag) {
                        textField.insertText(emoji)
                        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                            self.currentTag = nextField.tag
                            self.isPlayerOneTurn = !self.isPlayerOneTurn
                            textField.isEnabled = false
                            nextField.isEnabled = (GameViewControlller.isPlayerOne && self.isPlayerOneTurn && self.currentTag % 2 == 0) ||
                                (!GameViewControlller.isPlayerOne && !self.isPlayerOneTurn && self.currentTag % 2 == 1)
                            nextField.becomeFirstResponder()
                        } else {
                            textField.resignFirstResponder()
                        }
                        
                        break
                    }
                }
            }
        }
    }
    
    
    @objc func back(sender: UIBarButtonItem) {
        if let peer = ServiceManager.instance.selectedPeer {
            let service = ServiceManager.instance.chatService
            service.send(message: "\(MPCMessageTypes.closeConnection)|nil", toPeer: peer.key)
        }
    }
    
    static func randomizeEmoji() -> String {
        return arrayEmoji[Int(arc4random_uniform(UInt32(arrayEmoji.count)))]
    }
}

