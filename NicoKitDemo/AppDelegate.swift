//
//  AppDelegate.swift
//  NicoKitDemo
//
//  Created by 林達也 on 2015/06/05.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import UIKit


let NicoAPI = API()

protocol Storyboardable {
    
    static var storyboardIdentifier: String { get }
    static var storyboardName: String { get }
}

func from_storyboard<T: AnyObject where T: Storyboardable>(clazz: T.Type) -> T! {
    
    let identifier = T.storyboardIdentifier
    let name = T.storyboardName
    
    let storyboard = UIStoryboard(name: name, bundle: nil)
    return storyboard.instantiateViewControllerWithIdentifier(identifier) as? T
}

protocol Xibable {
    
    static var xibName: String { get }
}

func from_xib<T: AnyObject where T: Xibable>(clazz: T.Type, owner: AnyObject? = nil, options: [NSObject: AnyObject]? = nil, atIndex index: Int = 0) -> T! {
    
    let name = T.xibName
    
    let xib = UINib(nibName: name, bundle: nil)
    return xib.instantiateWithOwner(owner, options: options)[index] as? T
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        LOGGING_VERBOSE()
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

