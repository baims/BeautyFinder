//
//  LogInViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 10/12/15.
//  Copyright © 2015 Baims. All rights reserved.
//

import UIKit
import Alamofire

class LogInViewController: UIViewController, UITextFieldDelegate {
    
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
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        
        emailTextField.text = "badran1996@gmail.com"
        passwordTextField.text = "bader555"
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
    
    
    @IBAction func logInButtonTapped(sender: UIButton)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Alamofire.request(.POST, "https://aqueous-dawn-8486.herokuapp.com/login/", parameters: ["username" : self.emailTextField.text!, "password" : self.passwordTextField.text!]).validate().responseJSON
            { (response) -> Void in
            
                if let Json = response.result.value {
                    let json = JSON(Json)
                    let token = json["token"].string!
                    
                    NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    print(NSUserDefaults.standardUserDefaults().stringForKey("token")!)
                    
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
                        // reload everything in self.presentingViewController so it shows that the user is signed in
                    })
                }
                else if let error = response.result.error
                {
                    print(error)
                    
                    let alertController = UIAlertController(title: "", message: "Your email and password does not match", preferredStyle: .Alert)
                    let cancel = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                    
                    alertController.addAction(cancel)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
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
}
