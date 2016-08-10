//
//  SignUpViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 10/12/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift
import SwiftyJSON

class SignUpViewController: UIViewController, UITextFieldDelegate
{
    var viewIsLoaded = false
    
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    @IBOutlet weak var logoTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldYConstraint: NSLayoutConstraint!
    @IBOutlet weak var signUpButtonYConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            
            nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSForegroundColorAttributeName : UIColor(white: 1.0, alpha: 0.4)])
            phoneTextField.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSForegroundColorAttributeName : UIColor(white: 1.0, alpha: 0.4)])
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor(white: 1.0, alpha: 0.4)])
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor(white: 1.0, alpha: 0.4)])
            
            
            
            /*** Changing the placement of the textFields/Buttons depending on the device ***/
            switch self.view.frame.height
            {
            case 480: // iPhone 4/4s
                textFieldYConstraint.constant = 120
                logoTopLayoutConstraint.active = false
                let constraint = NSLayoutConstraint(item: logoImageView, attribute: .Bottom, relatedBy: .Equal, toItem: nameTextField, attribute: .Top, multiplier: 1, constant: -50)
                self.view.addConstraint(constraint)
                
            case 568: // iPhone 5/5s/5c
                textFieldYConstraint.constant = 150
                signUpButtonYConstraint.constant = 46
                
            case 667: // iPhone 6/6s
                textFieldYConstraint.constant = 91
                signUpButtonYConstraint.constant = 274
                
            case 736: // iPhone 6/6s
                textFieldYConstraint.constant = 115
                signUpButtonYConstraint.constant = 300
                
            default:
                textFieldYConstraint.constant = 91
                signUpButtonYConstraint.constant = 274
            }
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /*** Showing the keyboard on iphone 6/6+ immediately after showing the VC ***/
        switch self.view.frame.height
        {
        case 667: // iPhone 6/6s
            self.nameTextField.becomeFirstResponder()
        case 736:
            self.nameTextField.becomeFirstResponder()
        default:
            break
        }
    }

    
    @IBAction func backButtonTapped(sender: UIButton)
    {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(sender: UIButton)
    {
        if !emailTextField.text!.isValidEmail()
        {
            BAAlertView.showAlertView(self, title: "Your email address is not valid", message: "Please enter a valid email address")
            return
        }
        else if phoneTextField.text!.characters.count < 8
        {
            BAAlertView.showAlertView(self, title: "Phone number is not valid", message: "Phone number should be 8 or more digits")
            return
        }
        else if passwordTextField.text!.characters.count < 6
        {
            BAAlertView.showAlertView(self, title: "Password is very short", message: "Your password should be 6 or more characters")
            return
        }
        else if nameTextField.text!.isEmpty
        {
            BAAlertView.showAlertView(self, title: "Name field is empty", message: "Please enter your name")
            return
        }
        
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Alamofire.request(.POST, k_website + "register/", parameters:
            ["email" : self.emailTextField.text!,
            "password" : self.passwordTextField.text!,
                "phone" : self.phoneTextField.text!,
                "first_name" : self.nameTextField.text!]).responseJSON
            { (response) -> Void in
                
                if let Json = response.result.value {
                    print(Json)
                    
                    let json = JSON(Json)
                    
                    if json["Operation"].string == "ok"
                    {
                        self.signIn(self.emailTextField.text!, password: self.passwordTextField.text!)
                    }
                    else
                    {
                        BAAlertView.showAlertView(self, title: "Error", message: json["error"].string!)
                    }
                }
                else if let error = response.result.error
                {
                    print(error)
                    
                    if error.code == -1009
                    {
                        BAAlertView.showAlertView(self, title: "No internet connection!", message: "Please check your internet connection")
                    }
                    else
                    {
                        BAAlertView.showAlertView(self, title: "Something's Wrong!", message: "Please check the provided data and check your internet connection")
                    }
                }
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    
    func signIn(username: String!, password: String!)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Alamofire.request(.POST, k_website + "login/", parameters: ["username" : username, "password" : password]).validate().responseJSON
            { (response) -> Void in
                
                if let Json = response.result.value {
                    let json = JSON(Json)
                    let token = json["token"].string!
                    
                    NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    print(NSUserDefaults.standardUserDefaults().stringForKey("token")!)
                    
                    self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
                        // reload everything in self.presentingViewController so it shows that the user is signed in
                    })
                }
                else if let error = response.result.error
                {
                    print(error)
                    
                    if error.code == -6003
                    {
                        BAAlertView.showAlertView(self, title: "Something's Wrong!", message: "Your email and password does not match")
                    }
                    else if error.code == -1009
                    {
                        BAAlertView.showAlertView(self, title: "No internet connection!", message: "Please check your internet connection")
                    }
                    else
                    {
                        BAAlertView.showAlertView(self, title: "Something's Wrong!", message: "Please check the provided data and check your internet connection")
                    }
                }
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }

    

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField.tag == 1 // name textField
        {
            self.phoneTextField.becomeFirstResponder()
        }
        else if textField.tag == 2 // phone textField
        {
            self.emailTextField.becomeFirstResponder()
        }
        else if textField.tag == 3 // email textField
        {
            self.passwordTextField.becomeFirstResponder()
        }
        else if textField.tag == 4 // password textField
        {
            self.passwordTextField.resignFirstResponder()
        }
        
        return true
    }
    
    
    
    /*** Gesture Recognizers ***/
    @IBAction func dismissKeyboard(sender: AnyObject)
    {
        if self.view.frame.height != 667 && self.view.frame.height != 736
        {
            self.nameTextField.resignFirstResponder()
            self.phoneTextField.resignFirstResponder()
            self.emailTextField.resignFirstResponder()
            self.passwordTextField.resignFirstResponder()
        }
    }
}
