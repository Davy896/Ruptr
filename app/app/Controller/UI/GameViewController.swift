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

class GameViewController: UIViewController, ISEmojiViewDelegate {
    
    @IBOutlet var emojiTextFields: [UITextField]!
    @IBOutlet weak var firstEmojiField: UITextField!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var waitingLabel: UILabel!
    
    
    var isPlayerOneTurn: Bool = true
    
    static var arrayEmoji: [String] = ["😀" , "😃" , "😄" , "😁" , "😆" , "😅" , "😂" , "🤣" , "☺️" , "😊" , "😇" , "🙂" , "🙃" , "😉" , "😌" , "😍" , "😘" , "😗" , "😙" , "😚" , "😋" , "😜" , "😝" , "😛" , "🤑" , "🤗" , "🤓" , "😎" , "🤡" , "🤠" , "😏" , "😒" , "😞" , "😔" , "😟" , "😕" , "🙁" , "☹️" , "😣" , "😖" , "😫" , "😩" , "😤" , "😠" , "😡" , "😶" , "😐" , "😑" , "😯" , "😦" , "😧" , "😮" , "😲" , "😵" , "😳" , "😱" , "😨" , "😰" , "😢" , "😥" , "🤤" , "😭" , "😓" , "😪" , "😴" , "🙄" , "🤔" , "🤥" , "😬" , "🤐" , "🤢" , "🤧" , "😷" , "🤒" , "🤕" , "😈" , "👿" , "👹" , "👺" , "💩" , "👻" , "💀" , "☠️" , "👽" , "👾" , "🤖" , "🎃" , "😺" , "😸" , "😹" , "😻" , "😼" , "😽" , "🙀" , "😿" , "😾" , "👐" , "🙌" , "👏" , "🙏" , "🤝" , "👍" , "👎" , "👊" , "✊" , "🤛" , "🤜" , "🤞" , "✌️" , "🤘" , "👌" , "👈" , "👉" , "👆" , "👇" , "☝️" , "✋" , "🤚" , "🖐" , "🖖" , "👋" , "🤙" , "💪" , "🖕" , "✍️" , "🤳" , "💅" , "🖖" , "💄" , "💋" , "👄" , "👅" , "👂" , "👃" , "👣" , "👁" , "👀" , "🗣" , "👤" , "👥" , "👶" , "👦" , "👧" , "👨" , "👩" , "👱‍♀️" , "👱" , "👴" , "👵" , "👲" , "👳‍♀️" , "👳" , "👮‍♀️" , "👮" , "👷‍♀️" , "👷" , "💂‍♀️" , "💂" , "🕵️‍♀️" , "🕵️" , "👩‍⚕️" , "👨‍⚕️" , "👩‍🌾" , "👨‍🌾" , "👩‍🍳" , "👨‍🍳" , "👩‍🎓" , "👨‍🎓" , "👩‍🎤" , "👨‍🎤" , "👩‍🏫" , "👨‍🏫" , "👩‍🏭" , "👨‍🏭" , "👩‍💻" , "👨‍💻" , "👩‍💼" , "👨‍💼" , "👩‍🔧" , "👨‍🔧" , "👩‍🔬" , "👨‍🔬" , "👩‍🎨" , "👨‍🎨" , "👩‍🚒" , "👨‍🚒" , "👩‍✈️" , "👨‍✈️" , "👩‍🚀" , "👨‍🚀" , "👩‍⚖️" , "👨‍⚖️" , "🤶" , "🎅" , "👸" , "🤴" , "👰" , "🤵" , "👼" , "🤰" , "🙇‍♀️" , "🙇" , "💁" , "💁‍♂️" , "🙅" , "🙅‍♂️" , "🙆" , "🙆‍♂️" , "🙋" , "🙋‍♂️" , "🤦‍♀️" , "🤦‍♂️" , "🤷‍♀️" , "🤷‍♂️" , "🙎" , "🙎‍♂️" , "🙍" , "🙍‍♂️" , "💇" , "💇‍♂️" , "💆" , "💆‍♂️" , "🕴" , "💃" , "🕺" , "👯" , "👯‍♂️" , "🚶‍♀️" , "🚶" , "🏃‍♀️" , "🏃" , "👫" , "👭" , "👬" , "💑" , "👩‍❤️‍👩" , "👨‍❤️‍👨" , "💏" , "👩‍❤️‍💋‍👩" , "👨‍❤️‍💋‍👨" , "👪" , "👨‍👩‍👧" , "👨‍👩‍👧‍👦" , "👨‍👩‍👦‍👦" , "👨‍👩‍👧‍👧" , "👩‍👩‍👦" , "👩‍👩‍👧" , "👩‍👩‍👧‍👦" , "👩‍👩‍👦‍👦" , "👩‍👩‍👧‍👧" , "👨‍👨‍👦" , "👨‍👨‍👧" , "👨‍👨‍👧‍👦" , "👨‍👨‍👦‍👦" , "👨‍👨‍👧‍👧" , "👩‍👦" , "👩‍👧" , "👩‍👧‍👦" , "👩‍👦‍👦" , "👩‍👧‍👧" , "👨‍👦" , "👨‍👧" , "👨‍👧‍👦" , "👨‍👦‍👦" , "👨‍👧‍👧" , "👚" , "👕" , "👖" , "👔" , "👗" , "👙" , "👘" , "👠" , "👡" , "👢" , "👞" , "👟" , "👒" , "🎩" , "🎓" , "👑" , "⛑" , "🎒" , "👝" , "👛" , "👜" , "💼" , "👓" , "🕶" , "🌂" , "☂️" ]
    
    static var randomEmoji = "😀"
    static var isPlayerOne = false
    var stringEmoji : String = ""
    
    
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
        self.firstEmojiField.text = GameViewController.randomEmoji
        self.firstEmojiField.inputView = self.emojiKeyboard
        self.firstEmojiField.isEnabled = false
        
        self.emojiKeyboard = ISEmojiView()
        self.emojiKeyboard.delegate = self
        self.emojiKeyboard.collectionView.backgroundColor = Colours.backgroundSecondary
        
        self.waitingLabel.isHidden = GameViewController.isPlayerOne
        
        
        for field in self.emojiTextFields {
            field.inputView = self.emojiKeyboard
            if (field.tag == 0 && GameViewController.isPlayerOne) {
                field.isEnabled = true
            } else {
                field.isEnabled = false
            }
        }
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: NSLocalizedString("back", comment: ""), style: UIBarButtonItemStyle.plain, target: self, action: #selector(GameViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (GameViewController.isPlayerOne) {
            self.emojiTextFields[0].becomeFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ChatController {
            for element in self.emojiTextFields {
                self.stringEmoji.append("\(element.text!) ")
            }
            
            vc.stringEmoji = self.stringEmoji
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
                self.waitingLabel.isHidden = false
                for textField in self.emojiTextFields {
                    if (textField.tag == self.currentTag) {
                        textField.insertText(emoji)
                        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                            self.currentTag = nextField.tag
                            self.isPlayerOneTurn = !self.isPlayerOneTurn
                            textField.isEnabled = false
                            nextField.isEnabled = (GameViewController.isPlayerOne && self.isPlayerOneTurn && self.currentTag % 2 == 0) ||
                                (!GameViewController.isPlayerOne && !self.isPlayerOneTurn && self.currentTag % 2 == 1)
                            nextField.becomeFirstResponder()
                        } else {
                            textField.resignFirstResponder()
                        }
                        
                        break
                    }
                }
                
                if (self.currentTag == 5) {
                    self.waitingLabel.isHidden = true
                    UIView.animate(withDuration: 2, animations: {
                        self.chatButton.alpha = 1
                    })
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

