//
//  AppDelegate.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 10/12/2017.
//  Copyright © 2017 Apple Dev Academy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let defaultFont = UIFont(name: "Futura-Medium", size: 17) {
            let navBarProxy = UINavigationBar.appearance()
            navBarProxy.titleTextAttributes = [NSAttributedStringKey.font: defaultFont, NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
            navBarProxy.barTintColor = Colours.backgroundSecondary
            navBarProxy.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            navBarProxy.setBackgroundImage(UIImage.setUpGradient(withColours: [Colours.backgroundSecondary.cgColor,
                                                                               Colours.background.cgColor],
                                                                 framedIn: CGRect(x: 0,
                                                                                  y: 0,
                                                                                  width: UIScreen.main.bounds.size.height * 2,
                                                                                  height: 64)), for: .default)
            
            let tabBarProxy = UITabBar.appearance()
            tabBarProxy.barTintColor  = Colours.backgroundSecondary
            tabBarProxy.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            tabBarProxy.backgroundImage = UIImage.setUpGradient(withColours: [Colours.background.cgColor,
                                                                              Colours.backgroundSecondary.cgColor],
                                                                framedIn: CGRect(x: 0,
                                                                                 y: 0,
                                                                                 width: UIScreen.main.bounds.size.height * 2,
                                                                                 height: 49))
            
            let barButtonItemProy = UIBarButtonItem.appearance()
            barButtonItemProy.setTitleTextAttributes([NSAttributedStringKey.font: defaultFont], for: UIControlState.normal)
            barButtonItemProy.setTitleTextAttributes([NSAttributedStringKey.font: defaultFont,], for: UIControlState.selected)
            barButtonItemProy.setTitleTextAttributes([NSAttributedStringKey.font: defaultFont], for: UIControlState.highlighted)
            
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        }
        
        let defaults = UserDefaults.standard
        ServiceManager.instance.userProfile = UserProfile(id: String.randomAlphaNumericString(length: UserProfile.idLength),
                                                          username: defaults.string(forKey: "username") ?? "",
                                                          avatar: [AvatarParts.hair: defaults.string(forKey: "avatarHair") ?? "hairstyle_0_black",
                                                                   AvatarParts.face: defaults.string(forKey: "avatarFace") ?? "expression_0",
                                                            AvatarParts.skin: defaults.string(forKey: "avatarSkin") ?? "skinTones|0"],
                                                          moods: [Mood(rawValue: defaults.string(forKey: "moodOne") ?? "Sports") ?? Mood.sports,
                                                                  Mood(rawValue: defaults.string(forKey: "moodTwo") ?? "Games") ?? Mood.games,
                                                                  Mood(rawValue: defaults.string(forKey: "moodThree") ?? "Music") ?? Mood.music],
                                                          status: Status(rawValue: defaults.string(forKey: "status") ?? "Playful") ?? Status.playful)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}



