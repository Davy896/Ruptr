//
//  ProfileCreationViewController.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 13/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit

class ProfileCreationViewController: UIViewController, UITextFieldDelegate {
    
    private var avatarHairName: String = "hairstyle_0_black"
    private var moodOne: Mood = Mood.sports
    private var moodTwo: Mood = Mood.games
    private var moodThree: Mood = Mood.music
    private var currentHairStyle = 0
    private var currentHairColour = 0
    private var currentFace = 0
    private var currentSkin = 0
    private var moodSelection = 1
    
    private let displayedPositionX: CGFloat = 16
    private let firstPartHiddenPositionX: CGFloat = -400
    private let seccondPartHiddenPositionX: CGFloat = 400
    
    @IBOutlet weak var firstPartView: UIView!
    @IBOutlet weak var seccondPartView: UIView!
    @IBOutlet weak var pageMarker: UIPageControl!
    @IBOutlet weak var avatarHairImageView: RoundImgView!
    @IBOutlet weak var avatarFaceImageView: RoundImgView!
    
    @IBOutlet weak var userNameTextField: UITextField! {
        didSet {
            self.userNameTextField.delegate = self
            self.userNameTextField.borderStyle = UITextBorderStyle.roundedRect
        }
    }
    
    @IBOutlet weak var userNameValidationLabel: RoundLabel!
    @IBOutlet weak var moodOneButton: RoundButton!
    @IBOutlet weak var moodTwoButton: RoundButton!
    @IBOutlet weak var moodThreeButton: RoundButton!
    
    @IBOutlet var finishButton: RoundButton!
   
    var moodSelectionAlert: MoodSelectionView!
    var transparencyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIViewController.setViewBackground(for: self)
        let user = ServiceManager.instance.userProfile
        self.userNameTextField.text = user.username
        self.finishButton.isEnabled = (user.username != "")
        self.moodOne = user.moods[0]
        self.moodTwo = user.moods[1]
        self.moodThree = user.moods[2]
        self.avatarHairName = (user.avatar[AvatarParts.hair] ?? "hairstyle_0_black")
        let hairTokens = self.avatarHairName.components(separatedBy: "_")
        self.currentHairStyle = Int(hairTokens[1]) ?? 0
        switch hairTokens[2] {
        case "black" :
            self.currentHairColour = 0
            break
        case "blonde":
            self.currentHairColour = 1
            break
        case "brown":
            self.currentHairColour = 2
            break
        case "special":
            self.currentHairColour = 3
            break
        default:
            self.currentHairColour = 0
            break
        }
        
        self.currentFace = Int(user.avatar[AvatarParts.face]?.components(separatedBy: "_").last ?? "0") ?? 0
        self.currentSkin = Colours.skinTones.index(of: user.avatarSkin) ?? 0

        self.avatarHairImageView.image = user.avatarHair
        self.avatarFaceImageView.backgroundColor = Colours.skinTones[self.currentSkin]
        self.avatarFaceImageView.image = UIImage(named: "expression_\(self.currentFace)")
        
        self.moodOneButton.setBackgroundImage(user.moods[0].image, for: UIControlState.normal)
        self.moodTwoButton.setBackgroundImage(user.moods[1].image, for: UIControlState.normal)
        self.moodThreeButton.setBackgroundImage(user.moods[2].image, for: UIControlState.normal)
        
        self.moodOneButton.tag = 11
        self.moodTwoButton.tag = 12
        self.moodThreeButton.tag = 13

        self.transparencyView = UIView(frame: self.view.frame)
        self.transparencyView.backgroundColor = UIColor.black
        self.transparencyView.alpha = 0
        self.view.addSubview(self.transparencyView)
        
        self.moodSelectionAlert = MoodSelectionView.createMoodSelectionView(buttonSize: self.moodOneButton.bounds.size * 0.8)
        self.moodSelectionAlert.center = self.view.center
        self.moodSelectionAlert.alpha = 0
        self.moodSelectionAlert.moodAlertButtonsAction = self.chooseMoodForProfile
        self.moodSelectionAlert.finishButtonAction = self.finishSelectingMood
        self.view.addSubview(self.moodSelectionAlert)
        
        for (key, button) in self.moodSelectionAlert.moodAlertButtons {
            if (key == self.moodOne || key == self.moodTwo || key == self.moodThree) {
                button.isEnabled = false
            }
        }
    
        NotificationCenter.default.addObserver(self, selector: #selector(profileWasEdited(_:)), name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func updateAvatar(_ sender: UIButton) {
        switch sender.tag {
        case 0: // Hair Right
            self.currentHairColour += 1
            if (self.currentHairColour == 4) {
                self.currentHairColour = 0
                self.currentHairStyle += 1
                if (self.currentHairStyle == 3) {
                    self.currentHairStyle = 0
                }
            }
            
            self.selectHair()
            break
        case 1: // Hair Left
            self.currentHairColour -= 1
            if (self.currentHairColour == -1) {
                self.currentHairColour = 3
                self.currentHairStyle -= 1
                if (self.currentHairStyle == -1) {
                    self.currentHairStyle = 2
                }
            }
            
            self.selectHair()
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
        self.moodSelection = sender.tag
        UIView.animate(withDuration: 0.2, animations: {
            self.moodSelectionAlert.alpha = 1
            self.transparencyView.alpha = 0.7
        })
        
        for gesture in self.view.gestureRecognizers ?? [] {
            gesture.isEnabled = false
        }
    }
    
    func chooseMoodForProfile() {
        if let sender = self.moodSelectionAlert.lastClickedButton {
            switch self.moodSelection {
            case 11:
                self.moodOne = self.moodSelectionAlert.moodAlertButtons.filter( { (key,value) -> Bool in value == sender } )[0].mood
                break
            case 12:
                self.moodTwo = self.moodSelectionAlert.moodAlertButtons.filter( { (key,value) -> Bool in value == sender } )[0].mood
                break
            case 13:
                self.moodThree = self.moodSelectionAlert.moodAlertButtons.filter( { (key,value) -> Bool in value == sender } )[0].mood
                break
            default:
                break
            }
            
            for (key, button) in self.moodSelectionAlert.moodAlertButtons {
                if (key == self.moodOne || key == self.moodTwo || key == self.moodThree) {
                    button.isEnabled = false
                } else {
                    button.isEnabled = true
                }
            }
        }
    }
    
    func finishSelectingMood() {
        if let sender = self.moodSelectionAlert.lastClickedButton {
            if let button = self.view.viewWithTag(self.moodSelection) as? RoundButton {
                UIView.animate(withDuration: 0.2, animations: {
                    self.moodSelectionAlert.alpha = 0
                    self.transparencyView.alpha = 0
                }) {
                    finished in
                    if (finished) {
                        UIView.transition(with:button, duration: 0.15,
                                          options: UIViewAnimationOptions.transitionCrossDissolve,
                                          animations: { button.setBackgroundImage(sender.backgroundImage(for: UIControlState.normal),
                                                                                  for: UIControlState.normal)
                        })
                        
                        for gesture in self.view.gestureRecognizers ?? [] {
                            gesture.isEnabled = true
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func saveProfile(_ sender: UIButton) {
        ServiceManager.instance.userProfile.username = self.userNameTextField.text!
        ServiceManager.instance.userProfile.avatar = [AvatarParts.hair: self.avatarHairName,
                                                      AvatarParts.face: "expression_\(currentFace)",
                                                      AvatarParts.skin: "skinTones|\(self.currentSkin)"]
        ServiceManager.instance.userProfile.moods = [self.moodOne, self.moodTwo, self.moodThree]
        ServiceManager.instance.userProfile.status = Status.playful
        UserDefaults.standard.set(ServiceManager.instance.userProfile.username, forKey: "username")
        UserDefaults.standard.set(ServiceManager.instance.userProfile.avatar[AvatarParts.hair]!, forKey: "avatarHair")
        UserDefaults.standard.set(ServiceManager.instance.userProfile.avatar[AvatarParts.face]!, forKey: "avatarFace")
        UserDefaults.standard.set(ServiceManager.instance.userProfile.avatar[AvatarParts.skin]!, forKey: "avatarSkin")
        UserDefaults.standard.set(ServiceManager.instance.userProfile.moods[0].rawValue, forKey: "moodOne")
        UserDefaults.standard.set(ServiceManager.instance.userProfile.moods[1].rawValue, forKey: "moodTwo")
        UserDefaults.standard.set(ServiceManager.instance.userProfile.moods[2].rawValue, forKey: "moodThree")
        UserDefaults.standard.set(ServiceManager.instance.userProfile.status.rawValue, forKey: "status")
    }
    
    @IBAction func switchParts(_ sender: Any) {
        if let swipe = sender as? UISwipeGestureRecognizer {
            switch swipe.direction {
            case UISwipeGestureRecognizerDirection.left:
                self.pageMarker.currentPage = 1
                UIView.animate(withDuration: 0.35, animations: {
                    self.firstPartView.frame.origin.x = self.firstPartHiddenPositionX
                    self.seccondPartView.frame.origin.x = self.displayedPositionX
                })
                break
            case UISwipeGestureRecognizerDirection.right:
                self.pageMarker.currentPage = 0
                UIView.animate(withDuration: 0.35, animations: {
                    self.firstPartView.frame.origin.x = self.displayedPositionX
                    self.seccondPartView.frame.origin.x = self.seccondPartHiddenPositionX
                })
                break
            default:
                break
            }
        } else if let pageControl = sender as? UIPageControl  {
            if pageControl.currentPage == 1 {
                UIView.animate(withDuration: 0.35, animations: {
                    self.firstPartView.frame.origin.x = self.firstPartHiddenPositionX
                    self.seccondPartView.frame.origin.x = self.displayedPositionX
                })
            } else {
                UIView.animate(withDuration: 0.35, animations: {
                    self.firstPartView.frame.origin.x = self.displayedPositionX
                    self.seccondPartView.frame.origin.x = self.seccondPartHiddenPositionX
                })
            }
        }
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
                return (false, NSLocalizedString("long_username_alert", comment: ""))
            }
            
            if (!text.isAlphanumeric) {
                return (false, NSLocalizedString("alphanumeric_username_alert", comment: ""))
            }
            
            return  (text.count > 0, NSLocalizedString("empty_username_alert", comment: ""))
        }
        
        return (false, "Invalid operation")
    }
    
    private func selectHair() {
        switch self.currentHairColour {
        case 0:
            self.avatarHairImageView.image = UIImage(named: "hairstyle_\(self.currentHairStyle)_black")
            self.avatarHairName = "hairstyle_\(self.currentHairStyle)_black"
            break
        case 1:
            self.avatarHairImageView.image = UIImage(named: "hairstyle_\(self.currentHairStyle)_blonde")
            self.avatarHairName = "hairstyle_\(self.currentHairStyle)_blonde"
            break
        case 2:
            self.avatarHairImageView.image = UIImage(named: "hairstyle_\(self.currentHairStyle)_brown")
            self.avatarHairName = "hairstyle_\(self.currentHairStyle)_brown"
            break
        case 3:
            self.avatarHairImageView.image = UIImage(named: "hairstyle_\(self.currentHairStyle)_special")
            self.avatarHairName = "hairstyle_\(self.currentHairStyle)_special"
            break
        default:
            print("Error")
            break
        }
    }
    
    @objc private func profileWasEdited(_ notification: Notification) {
        let validated = self.validate(self.userNameTextField)
        self.userNameValidationLabel.text = validated.message
        UIView.animate(withDuration: 0.25, animations: {
            self.userNameValidationLabel.isHidden = validated.isValid
            self.userNameValidationLabel.backgroundColor = Colours.errorBackground
        })
        
        self.finishButton.isEnabled = validated.isValid
        self.finishButton.bgColor = validated.isValid ? UIColor.white : Colours.saveProfileButtonInvalidBackground
    }
}
