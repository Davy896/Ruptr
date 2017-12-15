//
//  ProfileCreationViewController.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 13/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit

class ProfileCreationViewController: UIViewController, UITextFieldDelegate {
    
    private var avatarImageName: String = ""
    private var moodOne: Mood = Mood.sports
    private var moodTwo: Mood = Mood.games
    private var moodThree: Mood = Mood.music
    private var editableControls: [UIControl] = []
    
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var avatarValidationLabel: UILabel!
    
    @IBOutlet weak var userNameTextField: UITextField! {
        didSet {
            self.userNameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var userNameValidationLabel: UILabel!
    
    @IBOutlet weak var moodOneButton: UIButton!
    @IBOutlet weak var moodOneValidationLabel: UILabel!
    
    @IBOutlet weak var moodTwoButton: UIButton!
    @IBOutlet weak var moodTwoValidationLabel: UILabel!
    
    @IBOutlet weak var moodThreeButton: UIButton!
    @IBOutlet weak var moodThreeValidationLabel: UILabel!
    
    
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colours.background
        self.editableControls.append(contentsOf: [avatarButton, userNameTextField, moodOneButton, moodTwoButton, moodThreeButton])
        NotificationCenter.default.addObserver(self, selector: #selector(profileWasEdited(_:)), name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func selectAvatar(_ sender: UIButton) {
        sender.setBackgroundImage(UIImage(named: "roguemonkeyblog"), for: UIControlState.normal)
        self.avatarImageName = "roguemonkeyblog"
    }
    
    @IBAction func selectMood(_ sender: UIButton) {
        
        switch sender {
        case moodOneButton:
            sender.setBackgroundImage(UIImage(named: "roguemonkeyblog"), for: UIControlState.normal)
            self.moodOne = Mood.sports
            break
        case moodTwoButton:
            
            sender.setBackgroundImage(UIImage(named: "roguemonkeyblog"), for: UIControlState.normal)
            self.moodTwo = Mood.sports
            break
        case moodThreeButton:
            sender.setBackgroundImage(UIImage(named: "roguemonkeyblog"), for: UIControlState.normal)
            self.moodThree = Mood.sports
            break
        default:
            break
        }
    }
    
    @IBAction func saveProfile(_ sender: UIButton) {
        ServiceManager.instance.userProfile = UserProfile(id: String.randomAlphaNumericString(length: 20), username: self.userNameTextField.text!, avatar: self.avatarImageName, moods: [self.moodOne, self.moodTwo, self.moodThree], status: Status.playful)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let validated = self.validate(textField)
        self.userNameValidationLabel.text = validated.message
        UIView.animate(withDuration: 0.25, animations: {
            self.userNameValidationLabel.isHidden = validated.isValid
        })
        view.endEditing(true)
        return true
    }
    
    private func validate(_ control: UIControl) -> (isValid: Bool,message: String?) {

        if let textField = control as? UITextField{
            guard let text = textField.text else {
                return (false, nil)
            }
            
            if (text.count >= 20) {
                return (false, "Your Username is too long")
            }
            
            if (!text.isAlphanumeric) {
                return (false, "Only numbers and letters allowed")
            }
            
            return  (text.count > 0, "This field cannot be empty.")
        } else if let button = control as? UIButton{
            if button.backgroundImage(for: UIControlState.normal) == nil {
                return (false, "This field cannot be empty.")
            }
            return  (true, nil)
        }
        
        return (false, "Invalid operation")
    }
    
    
    @objc private func profileWasEdited(_ notification: Notification) {
        var formIsValid = true
        for control in editableControls {
            let (valid, _) = validate(control)
            
            guard valid else {
                formIsValid = false
                break
            }
        }
        finishButton.isEnabled = formIsValid
    }
}
