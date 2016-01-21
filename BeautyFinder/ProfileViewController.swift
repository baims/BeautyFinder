//
//  ProfileViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 1/12/16.
//  Copyright © 2016 Baims. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate
{
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    
    var emailIsChanged : Bool {
        get {
            if json == nil {
                return false
            }
            else if emailTextField.text == self.json!["email"].string!
            {
                return false
            }
            else
            {
                return true
            }
        }
    }
    var phoneIsChanged : Bool {
        get {
            if json == nil {
                return false
            }
            else if phoneTextField.text == self.json!["Phonenumber"].string!
            {
                return false
            }
            else
            {
                return true
            }
        }
    }
    
    var json : JSON?
    var token : String?
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        getProfileJsonIfSignedIn()
        
        emailTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
        phoneTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.hidden = true
        
        getProfileJsonIfSignedIn()
        
        if token == nil
        {
            // showing SignInVC
            print(self.tabBarController?.selectedIndex)
            self.tabBarController!.selectedIndex = 0
            
            performSegueWithIdentifier("logIn", sender: self)
        }
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getProfileJsonIfSignedIn()
    {
        if let token = NSUserDefaults.standardUserDefaults().objectForKey("token")
        {
            self.token = (token as! String)
            getProfileDataFromServer()
        }
        else
        {
            self.json = nil
            self.token = nil
            
            updateElementsOnScreen()
        }
    }
    
    private func getProfileDataFromServer()
    {
        let headers = ["Authorization" : "Token \(token!)"]
                
        Alamofire.request(.GET, k_website + "user/profile/", parameters: nil, headers: headers).responseJSON(completionHandler: { (response) -> Void in
            
            if let Json = response.result.value
            {
                self.json = JSON(Json)
                print(self.json)
                // updating elements on screen
                self.updateElementsOnScreen()
            }
            else if let error = response.result.error
            {
                print(error)
            }
        })
    }
    
    private func updateProfileDataOnServer()
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        if phoneIsChanged
        {
            // TODO: update phone number on server ( api )
        }
        
        if emailIsChanged
        {
            // TODO: update email on server ( api )
        }
    }
    
    func updateElementsOnScreen()
    {
        // TODO: implement this function to update labels/cells with new data in the json
        if json == nil
        {
            // remove everything
        }
        else
        {
            // update everything just like in json
            emailTextField.text = self.json!["email"].string!
            phoneTextField.text = self.json!["Phonenumber"].string!
        }
    }

    
    @IBAction func saveButtonTapped(sender: UIButton)
    {
        updateProfileDataOnServer()
        
        saveButton.enabled = false
        cancelButton.hidden = true
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton)
    {
        updateElementsOnScreen()
        
        saveButton.enabled = false
        cancelButton.hidden = true
        
        emailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
    }
    
}

// MARK: UITableViewDelegate & DataSource & UIScrollViewDelegate
extension ProfileViewController
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let json = self.json else
        {
            return 1 // which will be "There is no orders"
        }
        
        if json["lastOrders"].array!.count > 3
        {
            return json["lastOrders"].array!.count + 1
        }
        else
        {
            return json["lastOrders"].array!.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -20
        {
            scrollView.contentOffset.y = -20
        }
    }
}

// MARK: UITextFieldDelegate
extension ProfileViewController
{
    func textFieldDidBeginEditing(textField: UITextField)
    {
        print("didBeginEditing")
    }
    
    func textFieldDidChange(sender: UITextField)
    {
        /** hiding/showing save & cancel buttons **/
        if emailIsChanged == true || phoneIsChanged == true
        {
            saveButton.enabled = true
            cancelButton.hidden = false
        }
        else
        {
            saveButton.enabled = false
            cancelButton.hidden = true
        }
        
        sender.resignFirstResponder()
        //sender.sizeToFit()
        //sender.setNeedsLayout()
        //self.view.setNeedsLayout()
        sender.becomeFirstResponder()
    }
}