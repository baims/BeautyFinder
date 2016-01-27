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
    
    
    @IBOutlet weak var emailTextField: BAAutoResizingTextField!
    @IBOutlet weak var phoneTextField: BAAutoResizingTextField!
    
    
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
    var indexOfSelectedCell : NSIndexPath?
    

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
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "booking"
        {
            let jsonOfSelectedIndex = self.json!["lastOrders", self.indexOfSelectedCell!.row]
            let summaryViewController = segue.destinationViewController as! SummaryViewController
            
            summaryViewController.salonName        = jsonOfSelectedIndex["salonName"].string!
            summaryViewController.salonImageUrl    = k_website + jsonOfSelectedIndex["salonLogo"].string!
            summaryViewController.salonAddress     = jsonOfSelectedIndex["salonAddress"].string!
            
            print(summaryViewController.salonName)
            
            summaryViewController.subcategoryName  = jsonOfSelectedIndex["service"].string!
            //summaryViewController.subcategoryPK    = jsonOfSelectedIndex["starttime"].string!
            summaryViewController.subcategoryPrice =  jsonOfSelectedIndex["price"].double!
            
            summaryViewController.beauticianName   = jsonOfSelectedIndex["beautician"].string!
            //summaryViewController.beauticianPK     = jsonOfSelectedIndex["starttime"].string!
            summaryViewController.beauticianImageUrl = k_website + jsonOfSelectedIndex["beauticianPicture"].string!
            
            summaryViewController.dateOfBooking    = jsonOfSelectedIndex["date"].string!
            summaryViewController.startTime        = jsonOfSelectedIndex["starttime"].string!
            summaryViewController.endTime          = DateTimeConverter.convertTimeToString(jsonOfSelectedIndex["endtime"].string!)
            
            summaryViewController.needToHideBookButton = true
        }
        
    }
    
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
        let headers = ["Authorization" : "Token \(token!)"]
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        if phoneIsChanged
        {
            Alamofire.request(.POST, k_website + "changePhone/", parameters: ["phone" : self.phoneTextField.text!], headers: headers).responseJSON(completionHandler: { (response) -> Void in
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if let Json = response.result.value
                {
                    let respond = JSON(Json)
                    print(respond)
                    
                    /** Dealing with the respond from server **/
                    if respond["Operation"].string! == "ok"
                    {
                        self.getProfileJsonIfSignedIn()
                    }
                }
                else if let error = response.result.error
                {
                    print(error)
                }
            })
        }
        
        if emailIsChanged
        {
            Alamofire.request(.POST, k_website + "changeEmail/", parameters: ["email" : self.emailTextField.text!], headers: headers).responseJSON(completionHandler: { (response) -> Void in
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if let Json = response.result.value
                {
                    let respond = JSON(Json)
                    print(respond)
                    
                    /** Dealing with the respond from server **/
                    if respond["Operation"].string! == "ok"
                    {
                        self.getProfileJsonIfSignedIn()
                    }
                }
                else if let error = response.result.error
                {
                    print(error)
                }
            })
        }
    }
    
    func updateElementsOnScreen()
    {
        // TODO: implement this function to update labels/cells with new data in the json
        if json == nil
        {
            // removing everything
            emailTextField.text = ""
            phoneTextField.text = ""
            
            self.tableView.reloadData()
        }
        else
        {
            // update everything just like in json
            emailTextField.text = self.json!["email"].string!
            phoneTextField.text = self.json!["Phonenumber"].string!
            
            self.tableView.reloadData()
        }
    }

    func showAlertView(title:String = "Something's wrong", message: String = "Please check your email address and phone number and make sure they are valid")
    {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: UIButton)
    {
        if emailTextField.text!.isValidEmail()
        {
            updateProfileDataOnServer()
            
            saveButton.enabled = false
            
            emailTextField.resignFirstResponder()
            phoneTextField.resignFirstResponder()
        }
        else
        {
            showAlertView()
        }
    }
    
    
    @IBAction func cancelButtonTapped(sender: UIButton)
    {
        updateElementsOnScreen()
        
        saveButton.enabled = false
        
        emailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
    }
    
    
    @IBAction func signOutButtonTapped(sender: UIButton)
    {
        let alertView = UIAlertController(title: "Sign out", message: "Are you sure you want to sign out ?", preferredStyle: .Alert)
        let signOutAction = UIAlertAction(title: "Sign out", style: UIAlertActionStyle.Destructive)
            { (alertAction) -> Void in
                
            NSUserDefaults.standardUserDefaults().removeObjectForKey("token")
            
            self.json = nil
            
            self.updateElementsOnScreen()
            
            let tabBarController = self.tabBarController as! TabBarController
            tabBarController.selectedIndex = 0
            tabBarController.showSignInViewController()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertView.addAction(signOutAction)
        alertView.addAction(cancelAction)
        
        self.presentViewController(alertView, animated: true, completion: nil)
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
        
//        if json["lastOrders"].array!.count > 3
//        {
//            return json["lastOrders"].array!.count + 1
//        }
//        else
//        {
//            return json["lastOrders"].array!.count
//        }
        
        return json["lastOrders"].array!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProfileTableViewCell
        
        // TODO: implement this freakin' cell
        
        
        let accessoryView = UIImageView(image: UIImage(named: "arrow"))
        cell.accessoryView = accessoryView
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?
    {
        indexOfSelectedCell = indexPath
        
        return indexOfSelectedCell
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
        cancelButton.hidden = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        cancelButton.hidden = true
    }
    
    func textFieldDidChange(sender: UITextField)
    {
        /** hiding/showing save & cancel buttons **/
        if emailIsChanged == true || phoneIsChanged == true
        {
            saveButton.enabled = true
        }
        else
        {
            saveButton.enabled = false
        }
        
        sender.invalidateIntrinsicContentSize()
    }
}