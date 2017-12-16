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
    private var currentHairStyle = 0
    private var currentHairColour = 0
    private var currentFace = 0
    private var currentSkin = 1
    
    @IBOutlet weak var avatarHairImageView: RoundImgView!
    @IBOutlet weak var avatarFaceImageView: RoundImgView!
    
    @IBOutlet weak var userNameTextField: UITextField! {
        didSet {
            self.userNameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var userNameValidationLabel: RoundLabel!
    @IBOutlet weak var moodOneButton: UIButton!
    @IBOutlet weak var moodTwoButton: UIButton!
    @IBOutlet weak var moodThreeButton: UIButton!
    
    
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colours.background
        self.avatarHairImageView.image = UIImage(named: "hairstyle_\(currentHairStyle)_black")
        self.avatarFaceImageView.backgroundColor = Colours.skinTones[1]
        self.avatarFaceImageView.image = UIImage(named: "expression_\(currentFace)")
        
        NotificationCenter.default.addObserver(self, selector: #selector(profileWasEdited(_:)), name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func updateAvatar(_ sender: UIButton) {
        switch sender.tag {
        case 0: // Hair Right
            switch self.currentHairColour {
            case 0:
                self.avatarHairImageView.image = UIImage(named: "hairstyle_\(self.currentHairStyle)_black")
                break
            case 1:
                self.avatarHairImageView.image = UIImage(named: "hairstyle_\(self.currentHairStyle)_blonde")
                break
            case 2:
                self.avatarHairImageView.image = UIImage(named: "hairstyle_\(self.currentHairStyle)_brown")
                break
            case 3:
                self.avatarHairImageView.image = UIImage(named: "hairstyle_\(self.currentHairStyle)_special")
                break
            default:
                print("Error")
                break
            }
            
            self.currentHairColour += 1
            if (self.currentHairColour == 4) {
                self.currentHairColour = 0
                self.currentHairStyle += 1
                if (self.currentHairStyle == 3) {
                    self.currentHairStyle = 0
                }
            }
            
            break
        case 1: // Hair Left
            switch self.currentHairColour {
            case 0:
                self.avatarHairImageView.image = UIImage(named: "hairstyle_\(self.currentHairStyle)_black")
                break
            case 1:
                self.avatarHairImageView.image = UIImage(named: "hairstyle_\(self.currentHairStyle)_blonde")
                break
            case 2:
                self.avatarHairImageView.image = UIImage(named: "hairstyle_\(self.currentHairStyle)_brown")
                break
            case 3:
                self.avatarHairImageView.image = UIImage(named: "hairstyle_\(self.currentHairStyle)_special")
                break
            default:
                print("Error")
                break
            }
            
            self.currentHairColour += 1
            if (self.currentHairColour == 4) {
                self.currentHairColour = 0
                self.currentHairStyle += 1
                if (self.currentHairStyle == 3) {
                    self.currentHairStyle = 0
                }
            }
            
            break
        case 2: // Face Right
            self.currentFace = self.currentFace == 2 ? 0 : self.currentFace + 1
            self.avatarFaceImageView.image = UIImage(named: "expression_\(currentFace)")
            break
        case 3: // Face Left
            self.currentFace = self.currentFace == 0 ? 2 : self.currentFace - 1
            self.avatarFaceImageView.image = UIImage(named: "expression_\(currentFace)")
            break
        case 4: // Skin Right
            self.currentSkin = self.currentSkin == Colours.skinTones.count - 1 ? 0 : self.currentSkin + 1
            self.avatarFaceImageView.backgroundColor = Colours.skinTones[currentSkin]
            break
        case 5: // Skin Left
            self.currentSkin = self.currentSkin == 0 ? Colours.skinTones.count - 1 : self.currentSkin - 1
            self.avatarFaceImageView.backgroundColor = Colours.skinTones[currentSkin]
            break
        default:
            break
        }
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
            self.userNameValidationLabel.backgroundColor = Colours.errorBackground
        })
        view.endEditing(true)
        return true
    }
    
    private func validate(_ control: UIControl) -> (isValid: Bool,message: String?) {
        
        if let textField = control as? UITextField {
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
        }
        
        return (false, "Invalid operation")
    }
    
    
    @objc private func profileWasEdited(_ notification: Notification) {
        finishButton.isEnabled = validate(userNameTextField).isValid
        finishButton.backgroundColor = UIColor.white
    }
}
