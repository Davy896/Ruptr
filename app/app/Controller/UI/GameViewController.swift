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
    
    
    var currentTag = 10
    
    var emojiKeyboard: ISEmojiView! {
        didSet {
            self.emojiKeyboard.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.setViewBackground(for: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedEmoji(_:)), name: NSNotification.Name(rawValue: "received_emoji"), object: nil)
        
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
            if (field.tag == 10 && GameViewController.isPlayerOne) {
                field.isEnabled = true
            } else {
                field.isEnabled = false
            }
        }
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: NSLocalizedString("back", comment: ""),
                                            style: UIBarButtonItemStyle.plain,
                                            target: self,
                                            action: #selector(self.back(_:)))
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
            self.stringEmoji.append(GameViewController.randomEmoji)
            for element in self.emojiTextFields {
                self.stringEmoji.append(element.text ?? "🛑")
            }
            
            vc.stringEmoji = self.stringEmoji
        }
    }
    
    func emojiViewDidSelectEmoji(emojiView: ISEmojiView, emoji: String) {
        if let peer = ServiceManager.instance.selectedPeer {
            ServiceManager.instance.chatService.send(message: "\(MPCMessageTypes.emoji)|\(emoji)", toPeer: peer.key)
        }
    }
    
    func emojiViewDidPressDeleteButton(emojiView: ISEmojiView) {}
    
    @objc func receivedEmoji(_ notification: NSNotification){
        if let emoji = notification.userInfo?["emoji"] as? String {
            OperationQueue.main.addOperation {
                self.waitingLabel.isHidden = false
                if let textField = self.view.viewWithTag(self.currentTag) as? RoundTextField {
                    textField.insertText(emoji)
                    if let nextField = self.view.viewWithTag(textField.tag + 1) as? RoundTextField {
                        self.currentTag = nextField.tag
                        self.isPlayerOneTurn = !self.isPlayerOneTurn
                        textField.isEnabled = false
                        nextField.isEnabled = (GameViewController.isPlayerOne && self.isPlayerOneTurn && self.currentTag % 2 == 0) ||
                            (!GameViewController.isPlayerOne && !self.isPlayerOneTurn && self.currentTag % 2 == 1)
                        nextField.becomeFirstResponder()
                    } else {
                        textField.resignFirstResponder()
                    }
                }
                
                if (self.currentTag == 15 &&
                    (self.view.viewWithTag(15) as! RoundTextField).text != "" &&
                    (self.view.viewWithTag(15) as! RoundTextField).text != nil) {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.waitingLabel.alpha = 0
                    }, completion:{ finished in
                        if (finished) {
                            UIView.animate(withDuration: 0.25, animations: { self.chatButton.alpha = 1 } )
                        }
                    })
                }
            }
        }
    }


    @objc func back(_ sender: UIBarButtonItem) {
        if let peer = ServiceManager.instance.selectedPeer {
            let service = ServiceManager.instance.chatService
            service.send(message: "\(MPCMessageTypes.closeConnection)|nil", toPeer: peer.key)
        }
    }
    
    static func randomizeEmoji() -> String {
        return arrayEmoji[Int(arc4random_uniform(UInt32(arrayEmoji.count)))]
    }
    
    
    
}

