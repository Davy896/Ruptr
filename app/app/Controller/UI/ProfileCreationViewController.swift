//
//  ProfileCreationViewController.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 13/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit
import SCLAlertView

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
    private let alertAppearence = SCLAlertView.SCLAppearance(kWindowWidth: 343,
                                                             kWindowHeight: 400,
                                                             kTitleFont: UIFont(name: "Futura-Bold", size: 17)!,
                                                             kTextFont: UIFont(name: "Futura-Medium", size: 14)!,
                                                             kButtonFont: UIFont(name: "Futura-Medium", size: 17)!,
                                                             showCircularIcon: false)
    private let moodAlertButtons = [Mood.food: RoundButton(),
                                    Mood.games: RoundButton(),
                                    Mood.music: RoundButton(),
                                    Mood.outdoor: RoundButton(),
                                    Mood.shopping: RoundButton(),
                                    Mood.sports: RoundButton()]
    
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
   
    override func viewDidLoad() {
        super.viewDidLoad()

        UIViewController.setViewBackground(for: self)
        let user = ServiceManager.instance.userProfile
        self.userNameTextField.text = user.username
        self.finishButton.isEnabled = (user.username != "")
        self.moodOne = user.moods[0]
        self.moodTwo = user.moods[1]
        self.moodThree = user.moods[2]
        let hairTokens = (user.avatar[AvatarParts.hair] ?? "hairstyle_0_black").components(separatedBy: "_")
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

        for (key, button) in moodAlertButtons {
            
            button.frame.size = CGSize(width: self.moodOneButton.frame.size.width * 0.8,
                                       height: self.moodOneButton.frame.size.height * 0.8)
            button.cornerRadius = 5
            button.bottomLeftCorner = true
            button.bottomRightCorner = true
            button.topLeftCorner = true
            button.topRightCorner = true
            button.maskToBounds = true
            button.backgroundColor = UIColor.lightGray
            button.addTarget(self, action: #selector(self.chooseMoodForProfile), for: .touchUpInside)

            if (key == self.moodOne || key == self.moodTwo || key == self.moodThree) {
                button.isEnabled = false
            }
            
            switch key {
            case Mood.food:
                button.setBackgroundImage(UIImage(named: "food"), for: UIControlState.normal)
                break
            case Mood.games:
                button.setBackgroundImage(UIImage(named: "games"), for: UIControlState.normal)
                break
            case Mood.music:
                button.setBackgroundImage(UIImage(named: "music"), for: UIControlState.normal)
                break
            case Mood.outdoor:
                button.setBackgroundImage(UIImage(named: "outdoors"), for: UIControlState.normal)
                break
            case Mood.shopping:
                button.setBackgroundImage(UIImage(named: "shopping"), for: UIControlState.normal)
                break
            case Mood.sports:
                button.setBackgroundImage(UIImage(named: "sports"), for: UIControlState.normal)
                break
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
        let alert = SCLAlertView(appearance: self.alertAppearence)
        let subview = UIView(frame: CGRect(x: 20, y: 15, width: 343, height: 200))
        let y = self.moodOneButton.frame.size.height + 15
        var x = self.moodOneButton.frame.origin.x
        var iterationIndex = 0
        
        for (_, button) in self.moodAlertButtons {
            if (iterationIndex == 3) {
                x = self.moodOneButton.frame.origin.x
            }
            
            if (iterationIndex > 2) {
                button.frame.origin.y = y
            }
            
            button.frame.origin.x = x
            subview.addSubview(button)
            x += button.frame.width + 10
            iterationIndex += 1
        }
        
        alert.customSubview = subview
        switch sender {
        case self.moodOneButton:
            self.moodSelection = 1
            alert.showInfo(NSLocalizedString("select_mood_alert", comment: ""), subTitle: "")
            break
        case self.moodTwoButton:
            self.moodSelection = 2
            alert.showInfo(NSLocalizedString("select_mood_alert", comment: ""), subTitle: "")
            break
        case self.moodThreeButton:
            self.moodSelection = 3
            alert.showInfo(NSLocalizedString("select_mood_alert", comment: ""), subTitle: "")
            break
        default:
            break
        }
    }
    
    @IBAction func chooseMoodForProfile(_ sender: UIButton) {
        switch  moodSelection {
        case 1:
            moodOneButton.setBackgroundImage(sender.backgroundImage(for: UIControlState.normal), for: UIControlState.normal)
            moodOne = Array(moodAlertButtons.filter( { (key,value) -> Bool in value == sender } ).keys)[0]
            break
        case 2:
            moodTwoButton.setBackgroundImage(sender.backgroundImage(for: UIControlState.normal), for: UIControlState.normal)
            moodTwo = Array(moodAlertButtons.filter( { (key,value) -> Bool in value == sender } ).keys)[0]
            break
        case 3:
            moodThreeButton.setBackgroundImage(sender.backgroundImage(for: UIControlState.normal), for: UIControlState.normal)
            moodThree = Array(moodAlertButtons.filter( { (key,value) -> Bool in value == sender } ).keys)[0]
            break
        default:
            break
        }
        
        for (key, button) in moodAlertButtons {
            if (key == self.moodOne || key == self.moodTwo || key == self.moodThree) {
                button.isEnabled = false
            } else {
                button.isEnabled = true
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
