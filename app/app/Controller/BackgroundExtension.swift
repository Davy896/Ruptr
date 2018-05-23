//
//  ViewControllerExtensions.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 18/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func setViewBackground(for controller: UIViewController) {
        let background = UIImageView(frame: controller.view.frame)
        background.tag = 0451
        background.image = UIImage(named: "space_background")
        controller.view.backgroundColor = Colours.background
        controller.view.addSubview(background)
        controller.view.sendSubview(toBack: background)
    }
    
    static func setTableViewBackground(for controller: ListTableViewController) {
        let background = UIImageView(frame: controller.view.frame)
        background.tag = 0451
        background.image = UIImage(named: "space_background")
        controller.tableView.backgroundView = UIView(frame: controller.view.frame)
        controller.tableView.backgroundView?.backgroundColor = Colours.background
        controller.tableView.backgroundView?.addSubview(background)
        controller.tableView.backgroundView?.sendSubview(toBack: background)
    }
    
    static func setCollectionViewViewBackground(for controller: ChatController) {
        let background = UIImageView(frame: controller.view.frame)
        background.tag = 0451
        background.image = UIImage(named: "space_background")
        controller.chatCollectionView.backgroundView =  UIView(frame: controller.view.frame)
        controller.chatCollectionView.backgroundView?.backgroundColor = UIColor.white
        controller.chatCollectionView.backgroundView?.addSubview(background)
        controller.chatCollectionView.backgroundView?.sendSubview(toBack: background)
    }
}
