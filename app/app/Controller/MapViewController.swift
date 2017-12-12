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
        // Do any additional setup after loading the view, typically from a nib.
        let a  = CircleView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        a.backgroundColor = UIColor.white
        a.drawCircle(onRectangle: a.frame, withRadius: 40)
        self.view.addSubview(a)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func button1(_ sender: Any) {
    }

}


