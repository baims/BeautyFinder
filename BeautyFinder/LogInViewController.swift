//
//  LogInViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 10/12/15.
//  Copyright © 2015 Baims. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices
import SwiftyJSON

class LogInViewController: UIViewController, UITextFieldDelegate
{
    var viewIsLoaded = false
    var needGoToProfileViewController = false
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logoYConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldYConstraint: NSLayoutConstraint!
    @IBOutlet weak var signUpButtonYConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidLayoutSubviews()
    {
        if !viewIsLoaded
        {
            viewIsLoaded = true
            
            /*** Changing textField's placeholder text color ***/
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor(white: 1.0, alpha: 0.4)])
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor(white: 1.0, alpha: 0.4)])
            
            //emailTextField.text = "badran1996@gmail.com"
            //passwordTextField.text = "bader555"
            
            
            
            /*** Changing the placement of the textFields/Buttons depending on the device ***/
            switch self.view.frame.height
            {
            case 480: // iPhone 4/4s
                textFieldYConstraint.constant = 150
                
            case 568: // iPhone 5/5s/5c
                textFieldYConstraint.constant = 174
                signUpButtonYConstraint.constant = 46
                
            case 667: // iPhone 6/6s
                textFieldYConstraint.constant = 106
                signUpButtonYConstraint.constant = 280
                
            case 736: // iPhone 6+/6s+
                textFieldYConstraint.constant = 130
                signUpButtonYConstraint.constant = 300
                
            default:
                textFieldYConstraint.constant = 106
                signUpButtonYConstraint.constant = 280
            }
        }
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /*** Showing the keyboard on iphone 6/6+ immediately after showing the VC ***/
        switch self.view.frame.height
        {
        case 667: // iPhone 6/6s
            self.emailTextField.becomeFirstResponder()
        case 736:
            self.emailTextField.becomeFirstResponder()
        default:
            break
        }
        
        // Making sure the status bar is white when this view controller appears
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
    }
    
    
    @IBAction func backButtonTapped(sender: UIButton)
    {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func logInButtonTapped(sender: UIButton)
    {
        if !emailTextField.text!.isValidEmail()
        {
            showAlertView("Your email address is not valid", message: "Please enter a valid email address")
            return
        }
        else if passwordTextField.text!.isEmpty
        {
            showAlertView("Enter a password", message: "Please enter your password")
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Alamofire.request(.POST, k_website + "login/", parameters: ["username" : self.emailTextField.text!, "password" : self.passwordTextField.text!]).validate().responseJSON
            { (response) -> Void in
            
                if let Json = response.result.value {
                    let json = JSON(Json)
                    let token = json["token"].string!
                    
                    NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    if self.needGoToProfileViewController
                    {
                        (self.presentingViewController as! TabBarController).selectedIndex = 2
                    }
                    
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
                        // reload everything in self.presentingViewController so it shows that the user is signed in
                    })
                }
                else if let error = response.result.error
                {
                    print(error)
                    
                    if error.code == -6003
                    {
                        self.showAlertView("Something's Wrong!", message: "Your email and password does not match")
                    }
                    else if error.code == -1009
                    {
                        self.showAlertView("No internet connection!", message: "Please check your internet connection")
                    }
                    else
                    {
                        self.showAlertView("Something's Wrong!", message: "Please check the provided data and check your internet connection")
                    }
                }
                
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    
    @IBAction func forgotPasswordButtonTapped(sender: UIButton)
    {
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
        
        let safariViewController = SFSafariViewController(URL: NSURL(string: k_website + "reset/recover")!)
        self.presentViewController(safariViewController, animated: true, completion: nil)
    }
    
    
    func showAlertView(title:String = "Something's wrong", message: String = "Please check your email address and phone number and make sure they are valid")
    {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 1 // email textField
        {
            passwordTextField.becomeFirstResponder()
        }
        else if textField.tag == 2 // password textField
        {
            passwordTextField.resignFirstResponder()
        }
        
        return true
    }
    
    
    
    /*** Gesture Recognizers ***/
    @IBAction func dismissKeyboard(sender: AnyObject)
    {
        if self.view.frame.height != 667 && self.view.frame.height != 736
        {
            self.emailTextField.resignFirstResponder()
            self.passwordTextField.resignFirstResponder()
        }
    }
}
