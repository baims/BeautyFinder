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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.userOpenedLocalNotification(_:)), name: "UserOpenedLocalNotification", object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        if !viewIsLoaded
        {
            viewIsLoaded = true
            
            /*** Loading images for each tab of the Tab Bar ***/
            for i in 0 ..< tabBar.items!.count
            {
                print(i)
                tabBar.items![i].image = UIImage(named: "tabBarImages\(i)")!.imageWithRenderingMode(.AlwaysOriginal)
                tabBar.items![i].selectedImage = UIImage(named: "tabBarImagesSelected\(i)")!.imageWithRenderingMode(.AlwaysOriginal)
            }
            
            // force loading the ProfileViewController, so when the user taps it, it is already loaded and has all the information without the need to wait
            let _ = (viewControllers![2] as! UINavigationController).viewControllers[0].view
        }
    }
    
    /*** Everytime the user wants to change the tab, we check if it's the last tab (profile) to make sure he's signed in to view it ***/
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool
    {
        if viewController == tabBarController.viewControllers![2]
        {
            // if user is not signed in, he can't see the ProfileViewController and he's taken to the LogInViewController instead
            if NSUserDefaults.standardUserDefaults().stringForKey("token") == nil
            {
                showSignInViewController()
                
                return false
            }
        }
        
        return true
    }
    
    /*** This method shows the LogInViewController modally ***/
    func showSignInViewController()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LogInViewController") as! LogInViewController
        vc.needGoToProfileViewController = true // this indicates that we must show ProfileViewController when the user logs in successfully
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
}


/*** NSNotificationCenter handling (posting/observing) ***/
extension TabBarController
{
    func userOpenedLocalNotification(notification : NSNotification)
    {
        // making sure user is signed in ( because we're showing ProfileViewController
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey("token")
        {
            // Getting the data sent along with the notification
            let userInfo = notification.object as! [NSObject : AnyObject]
            
            print("userOpenedLocalNotification")
            print(userInfo["salonName"])
            
            // force showing ProfileViewController
            self.selectedIndex = 2
            
            let profileViewController = (self.viewControllers![2] as! UINavigationController).viewControllers[0] as! ProfileViewController
            profileViewController.didLaunchFromNotification = true
            
            // showing the booking details by a push segue, sending the userInfo (details) with it
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                profileViewController.performSegueWithIdentifier("booking", sender: userInfo)
            })
        }
    }
}