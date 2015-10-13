//
//  SignUpViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 10/12/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

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
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        phoneTextField.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func backButtonTapped(sender: UIButton)
    {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(sender: UIButton)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Alamofire.request(.POST, "https://aqueous-dawn-8486.herokuapp.com/register/", parameters:
            ["email" : self.emailTextField.text!,
            "password" : self.passwordTextField.text!,
                "phone" : self.phoneTextField.text!,
                "first_name" : self.nameTextField.text!]).responseJSON
            { (response) -> Void in
                
                if let Json = response.result.value {
                    print(Json)
                    
                    /// IF OPETATION = OK THEN SIGN IN THE USER AND SAVE TOKEN IN NSUSERDEFAULTS
                }
                else if let error = response.result.error
                {
                    print(error)
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
}
