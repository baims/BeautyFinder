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
    }
    
    override func viewDidLayoutSubviews() {
        if !viewIsLoaded
        {
            viewIsLoaded = true
            
            for (var i = 0; i < tabBar.items?.count; i++)
            {
                print(i)
                tabBar.items![i].image = UIImage(named: "tabBarImages\(i)")!.imageWithRenderingMode(.AlwaysOriginal)
                tabBar.items![i].selectedImage = UIImage(named: "tabBarImagesSelected\(i)")!.imageWithRenderingMode(.AlwaysOriginal)
            }
            
            // force loading the ProfileViewController
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
        // for loop the viewControllers property of the tabBar and look if the viewController parameter is one of them
        
        
        return true
    }
    
    
    func showSignInViewController()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LogInViewController") as! LogInViewController
        vc.needGoToProfileViewController = true
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
}
