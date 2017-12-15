//
//  GameViewControl.swift
//  FirstMini
//
//  Created by Alessio Tortello on 13/12/2017.
//  Copyright © 2017 Alessio Tortello. All rights reserved.
//

import UIKit
import ISEmojiView

class GameViewControlller: UIViewController, ISEmojiViewDelegate {
    
    @IBOutlet var emojiTextFields: [UITextField]!
    @IBOutlet weak var text1: UITextField!
    
    var currentTag = 0
    
    var emojiKeyboard: ISEmojiView! {
        didSet {
            self.emojiKeyboard.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colours.background
        self.emojiKeyboard = ISEmojiView()
        self.emojiKeyboard.delegate = self
        
        for field in emojiTextFields {
            field.inputView = emojiKeyboard
            if (field.tag != 0) {
                field.isEnabled = false
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emojiTextFields[0].becomeFirstResponder()
    }
    
    func emojiViewDidSelectEmoji(emojiView: ISEmojiView, emoji: String) {
        for textField in emojiTextFields {
            if (textField.tag == currentTag) {
                textField.insertText(emoji)
                if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                    textField.isEnabled = false
                    nextField.isEnabled = true
                    nextField.becomeFirstResponder()
                    self.currentTag = nextField.tag
                } else {
                    textField.resignFirstResponder()
                }
                
                break
            }
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
}

