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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("map", comment: "")
        self.updateCircles(numberOfPeers: 20)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateCircles(numberOfPeers: Int) {
        var peersMissing: Int = numberOfPeers
        var circlePopulation: Int = 1
        var circleIndex: Int = 1
        let circle: CircleView
        circle = CircleView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 44))
        while peersMissing > 0 {
            peersMissing -= circlePopulation
            circlePopulation += circleIndex
            circleIndex += 1
        }
        
        circle.drawCircles(numberOf: circleIndex, onRectangle: circle.frame, withRadius: 80)
        self.view.addSubview(circle)
    }
}


