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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool
    {
        if viewController == tabBarController.viewControllers![2]
        {
            if NSUserDefaults.standardUserDefaults().stringForKey("token") == nil
            {
                print("here")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("LogInViewController") as! LogInViewController
                vc.needGoToProfileViewController = true
                
                self.presentViewController(vc, animated: true, completion: nil)
                
                return false
            }
        }
        // for loop the viewControllers property of the tabBar and look if the viewController parameter is one of them
        
        
        return true
    }
    

}
