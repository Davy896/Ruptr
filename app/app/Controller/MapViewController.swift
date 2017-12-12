//
//  FirstViewController.swift
//  FirstMini
//
//  Created by Alessio Tortello on 11/12/2017.
//  Copyright © 2017 Alessio Tortello. All rights reserved.
//

import UIKit

class MapViewController: ConnectivityViewController {
    let a = CircleView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(a)
        a.draw(CGRect(x: 0, y: 0, width: 300, height: 300))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func button1(_ sender: Any) {
    }
    
}


