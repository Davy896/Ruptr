//
//  FirstViewController.swift
//  FirstMini
//
//  Created by Alessio Tortello on 11/12/2017.
//  Copyright © 2017 Alessio Tortello. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MapViewController: ConnectivityViewController {
    
    @IBOutlet var panCircleView: UIPanGestureRecognizer!
    var circleView: CircleView!
    var avatarButtons: [String: AvatarPlanetButton] = [:]
    
    private func checkButtonColision(_ button: AvatarPlanetButton) -> Bool {
        let margins: CGFloat = 16
        for (_, existingButton) in self.avatarButtons {
            if (CGRect(origin: button.frame.origin, size: CGSize(width: button.frame.width + margins, height: button.frame.height + margins)).intersects(existingButton.frame)) {
                return true
            }
        }
        
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.circleView = CircleView(frame: self.view.frame)
        self.circleView.isUserInteractionEnabled = true
        self.circleView.radius = 60
        self.circleView.delegate = self
        self.view.addSubview(self.circleView)
        self.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func peerFound(withId id: MCPeerID) {
        super.peerFound(withId: id)
        self.reloadData()
    }
    
    override func peerLost(withId id: MCPeerID) {
        super.peerLost(withId: id)
        self.avatarButtons.removeValue(forKey: id.displayName.components(separatedBy: "|")[0])
        self.reloadData()
    }
    
    @IBAction func showInvitationPrompt(_ sender: AvatarPlanetButton) {
        if (sender.center != self.view.center) {
            self.centerCircles(sender)
        }
    }
    
    @IBAction func moveCircles(_ sender: UIPanGestureRecognizer) {
        if self.people.count != 0 {
            switch sender.state {
            case UIGestureRecognizerState.began:
                break
            case UIGestureRecognizerState.changed:
                let translation = sender.translation(in: self.view)
                self.circleView.center = CGPoint(x: self.circleView.center.x + translation.x, y: self.circleView.center.y + translation.y)
                for (_, button) in self.avatarButtons {
                    button.center = CGPoint(x: button.center.x + translation.x, y: button.center.y + translation.y)
                }
                
                self.circleView.translation.x += translation.x
                self.circleView.translation.y += translation.y
                sender.setTranslation(CGPoint.zero, in: self.view)
                break
            case UIGestureRecognizerState.ended:
                let velocity = sender.velocity(in: self.view)
                let x = (velocity.x * 0.1)
                let y = (velocity.y * 0.1)
                
                UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.circleView.center = CGPoint(x: self.circleView.center.x + x, y: self.circleView.center.y + y)
                    for (_, button) in self.avatarButtons {
                        button.center = CGPoint(x: button.center.x + x, y: button.center.y + y)
                    }
                }, completion: nil)
                
                self.circleView.translation.x += x
                self.circleView.translation.y += y
                break
            default:
                break
            }
        }
    }
    
    @IBAction func tapCenterCircles(_ sender: UITapGestureRecognizer) {
        self.centerCircles()
    }
    
    func centerCircles(_ sender: AvatarPlanetButton? = nil) {
        self.panCircleView.isEnabled = false
        UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.circleView.center.x -= self.circleView.translation.x
            self.circleView.center.y -= self.circleView.translation.y
            for (_, button) in self.avatarButtons {
                button.center.x -= self.circleView.translation.x
                button.center.y -= self.circleView.translation.y
            }
            
        }, completion: { finished in
            self.circleView.translation = (0,0)
            self.panCircleView.isEnabled = true
            if let sender = sender {
                self.panCircleView.isEnabled = false
                self.circleView.translation.x -=  sender.center.x - self.circleView.center.x
                self.circleView.translation.y -=  sender.center.y - self.circleView.center.y
                UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.circleView.center.x += self.circleView.translation.x
                    self.circleView.center.y += self.circleView.translation.y
                    for (_, button) in self.avatarButtons {
                        button.center.x += self.circleView.translation.x
                        button.center.y += self.circleView.translation.y
                    }
                    
                }, completion: { finished in
                    self.panCircleView.isEnabled = true
                })
            }
        })
    }
    
    func reloadData() {
        self.centerCircles()
        if (self.people.count > 0) {
            for view in self.view.subviews {
                if let button = view as? AvatarPlanetButton {
                    button.removeFromSuperview()
                }
            }
            
            var peersMissing = self.people.count
            var circlePopulation = 1
            var circleIndex = 0
            
            while (peersMissing > 0) {
                peersMissing -= circlePopulation
                circlePopulation += (circleIndex + 1)
                circleIndex += 1
            }
            
            self.circleView.numberOfCircles = circleIndex
            
            circleIndex = 0
            circlePopulation = 1
            for i in 0 ... self.people.count - 1 {
                let button = AvatarPlanetButton.createAvatarButton(from: self.people[i], size: CGSize(width: 65, height: 65))
                repeat {
                    let center = self.circleView.points[Int(arc4random_uniform(UInt32(361))) + 361 * self.circleView.circleFirstIndex[circleIndex] ]
                    button.center = CGPoint(x: center.x, y: center.y)
                } while (self.checkButtonColision(button))
                
                button.addTarget(self, action: #selector(showInvitationPrompt(_:)), for: UIControlEvents.touchUpInside)
                self.avatarButtons[self.people[i].id] = button
                self.view.addSubview(button)
                if (i == 0 || circlePopulation == i) {
                    circleIndex += 1
                    circlePopulation += i + 1
                }
            }
        }
    }
}

extension MapViewController: CircleViewDelegate  {
    func handleDrawingCompletion() {
        for (_, button) in self.avatarButtons {
            UIView.animate(withDuration: 0.35,
                           delay: 0,
                           options: UIViewAnimationOptions.curveEaseIn,
                           animations: { button.alpha = 1 },
                           completion: nil)
        }
    }
}

