//
//  BAAlertView.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 8/10/16.
//  Copyright © 2016 Baims. All rights reserved.
//

import UIKit

class BAAlertView : NSObject
{
    class func showAlertView(vc: UIViewController, title:String = "Something's wrong", message: String = "Please check your email address and phone number and make sure they are valid")
    {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        alertView.addAction(okAction)
        vc.presentViewController(alertView, animated: true, completion: nil)
    }
}
