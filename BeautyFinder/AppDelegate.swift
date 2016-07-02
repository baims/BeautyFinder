//
 //
//  AppDelegate.swift
//  BeautyFinder
//
//  Created by Yousef Alhusaini on 8/25/15.
//  Copyright (c) 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON

let k_website = "http://beautyfinders.com/"

var categoriesJson : JSON?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        /*** Local Notifications Setup ***/
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        /*** Local Nofitications Handling ***/
        if launchOptions != nil
        {
            if let notification = launchOptions![UIApplicationLaunchOptionsLocalNotificationKey]
            {
                print(notification)
                //self.application(application, didReceiveLocalNotification: notification as! UILocalNotification)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    NSNotificationCenter.defaultCenter().postNotificationName("UserOpenedLocalNotification", object: (notification as! UILocalNotification).userInfo!)
                })
            }
        }
        
        
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        
        /*** Sliding up textFields when the keyboard pops-up ***/
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 30
        //IQKeyboardManager.sharedManager().disableToolbarInViewControllerClass(SearchViewController)
        
        
        /*** UINavigationController Customizations ***/
        UINavigationBar.appearance().barTintColor = UIColor(red: 211.0/255.0, green: 68.0/255.0, blue:
            124.0/255.0, alpha: 0.3)
        
        //navigation bar customization & nav bar image bg
         UINavigationBar.appearance().setBackgroundImage(UIImage(named: "header_2")!.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .Stretch), forBarMetrics: .Default)


        //UINavigationBar.appearance().barTintColor = UIColor(red: 211.0/255.0, green: 68.0/255.0, blue:124.0/255.0, alpha: 0.3)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        if let barFont = UIFont(name: "MuseoSans-500", size: 20.0) {
            UINavigationBar.appearance().titleTextAttributes =
            [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName:barFont]
        }
        
        
        /*** UITabBarController Customizations ***/
        UITabBar.appearance().barTintColor = UIColor(red: 198.0/255.0, green: 39.0/255.0, blue: 107.0/255.0, alpha: 0.3)
        UITabBar.appearance().tintColor    = UIColor.whiteColor()
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)], forState: UIControlState.Selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(red: 252/255.0, green: 158/255.0, blue: 200/255.0, alpha: 1)], forState: UIControlState.Normal)
        //UITabBar.appearance().backgroundImage = UIImage(named: "header_1")
        let tabBarController = window?.rootViewController as! UITabBarController
    
        
        for item in tabBarController.tabBar.items! as [UITabBarItem]
        {
            if let image = item.image
            {
                item.image = image.imageWithRenderingMode(.AlwaysTemplate)
                
            }
        }
        
        
        /*****
        THIS MUST BE REMOVED IN THE FINAL RELEASE
        ********/
        //NSUserDefaults.standardUserDefaults().removeObjectForKey("token")
        
        
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
        
        self.clearNotificationCenter(application)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print("didRecieveLocalNotification")
        print(notification.userInfo!)
        
        if application.applicationState == .Inactive || application.applicationState == .Background
        {
            NSNotificationCenter.defaultCenter().postNotificationName("UserOpenedLocalNotification", object: notification.userInfo!)
        }
    }
    
    func clearNotificationCenter(application : UIApplication)
    {
        application.applicationIconBadgeNumber = 1
        application.applicationIconBadgeNumber = 0
    }
}

