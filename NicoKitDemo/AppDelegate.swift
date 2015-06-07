//
//  AppDelegate.swift
//  NicoKitDemo
//
//  Created by 林達也 on 2015/06/05.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import UIKit


let NicoAPI = API()


func App() -> MainViewController! {
    let d = UIApplication.sharedApplication().delegate as? AppDelegate
    return d?.mainController
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    weak var mainController: MainViewController?
    var playerViewController: PlayerViewController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        LOGGING_VERBOSE()
        
        self.mainController = self.window?.rootViewController as? MainViewController
        
        return true
    }

}

