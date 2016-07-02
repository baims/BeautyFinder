//
//  TabBarController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 1/13/16.
//  Copyright © 2016 Baims. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate
{
    var viewIsLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.userOpenedLocalNotification(_:)), name: "UserOpenedLocalNotification", object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        if !viewIsLoaded
        {
            viewIsLoaded = true
            
            for i in 0 ..< tabBar.items!.count// (var i = 0; i < tabBar.items?.count; i += 1)
            {
                print(i)
                tabBar.items![i].image = UIImage(named: "tabBarImages\(i)")!.imageWithRenderingMode(.AlwaysOriginal)
                tabBar.items![i].selectedImage = UIImage(named: "tabBarImagesSelected\(i)")!.imageWithRenderingMode(.AlwaysOriginal)
            }
            
            // force loading the ProfileViewController, so when the user taps it, it is already loaded and has all the information without the need to wait
            let _ = (viewControllers![2] as! UINavigationController).viewControllers[0].view
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool
    {
        if viewController == tabBarController.viewControllers![2]
        {
            if NSUserDefaults.standardUserDefaults().stringForKey("token") == nil
            {
                print("here")
                
                showSignInViewController()
                
                return false
            }
        }
        
        return true
    }
    
    
    func showSignInViewController()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LogInViewController") as! LogInViewController
        vc.needGoToProfileViewController = true
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func userOpenedLocalNotification(notification : NSNotification)
    {
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey("token")
        {
            let userInfo = notification.object as! [NSObject : AnyObject]
            
            print("userOpenedLocalNotification")
            print(userInfo["salonName"])
            
            self.selectedIndex = 2
            
            let profileViewController = (self.viewControllers![2] as! UINavigationController).viewControllers[0] as! ProfileViewController
            profileViewController.didLaunchFromNotification = true
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                profileViewController.performSegueWithIdentifier("booking", sender: userInfo)
            })
        }
    }
}
