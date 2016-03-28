//
//  ProfileViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 1/12/16.
//  Copyright © 2016 Baims. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

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
    
    var viewIsLoaded = false
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        getProfileJsonIfSignedIn()
        
        emailTextField.addTarget(self, action: #selector(ProfileViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        phoneTextField.addTarget(self, action: #selector(ProfileViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.hidden = true
        
        if let indexPath = self.tableView.indexPathForSelectedRow
        {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: animated)
        }
        
        
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
    
    
    override func viewDidLayoutSubviews()
    {
        if !viewIsLoaded
        {
            viewIsLoaded = true
            
            self.tableView.contentOffset.y = -20
        }
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
            summaryViewController.subcategoryPrice = jsonOfSelectedIndex["price"].double!
            
            summaryViewController.beauticianName   = jsonOfSelectedIndex["beautician"].string!
            //summaryViewController.beauticianPK     = jsonOfSelectedIndex["starttime"].string!
            summaryViewController.beauticianImageUrl = k_website + jsonOfSelectedIndex["beauticianPicture"].string!
            
            summaryViewController.dateOfBooking    = jsonOfSelectedIndex["date"].string!
            summaryViewController.startTime        = jsonOfSelectedIndex["starttime"].string!
            summaryViewController.endTime          = jsonOfSelectedIndex["endtime"].string!
            
            summaryViewController.latitude         = jsonOfSelectedIndex["lat"].double!
            summaryViewController.longitude        = jsonOfSelectedIndex["long"].double!
            
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
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
                
        Alamofire.request(.GET, k_website + "user/profile/", parameters: nil, headers: headers).responseJSON(completionHandler: { (response) -> Void in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            
            if let resultJson = response.result.value
            {
                // if self.json is not nil AND it is not the same as the fetched json from server, then we can update elements on screen, otherwise there is no need to update elements on screen
                if let json = self.json where json != JSON(resultJson)
                {
                    self.json = JSON(resultJson)
                    
                    // updating elements on screen
                    self.updateElementsOnScreen()
                }
                else if self.json == nil
                {
                    self.json = JSON(resultJson)
                    
                    // updating elements on screen
                    self.updateElementsOnScreen()
                }
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
                    if respond["Operation"].string == "ok"
                    {
                        self.getProfileJsonIfSignedIn()
                    }
                    else
                    {
                        self.showAlertView("Error", message: respond["error"].string!)
                        
                        self.saveButton.enabled = true
                        self.cancelButton.hidden = false
                    }
                }
                else if let error = response.result.error
                {
                    print(error)
                    
                    if error.code == -1009
                    {
                        self.showAlertView("No internet connection!", message: "Please check your internet connection")
                    }
                    else
                    {
                        self.showAlertView("Something's Wrong!", message: "Please check the provided data and check your internet connection")
                    }
                    
                    self.saveButton.enabled = true
                    self.cancelButton.hidden = false
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
                    if respond["Operation"].string == "ok"
                    {
                        self.getProfileJsonIfSignedIn()
                    }
                    else
                    {
                        self.showAlertView("Error", message: respond["error"].string!)
                        
                        self.saveButton.enabled = true
                        self.cancelButton.hidden = false
                    }
                }
                else if let error = response.result.error
                {
                    print(error)
                    
                    if error.code == -1009
                    {
                        self.showAlertView("No internet connection!", message: "Please check your internet connection")
                    }
                    else
                    {
                        self.showAlertView("Something's Wrong!", message: "Please check the provided data and check your internet connection")
                    }
                    
                    self.saveButton.enabled = true
                    self.cancelButton.hidden = false
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
        if phoneIsChanged && phoneTextField.text!.characters.count < 8
        {
            showAlertView("Phone number is not valid", message: "Phone number should be 8 or more digits")
            return
        }
        else if emailIsChanged && !emailTextField.text!.isValidEmail()
        {
            showAlertView("Your email address is not valid", message: "Please enter a valid email address")
            return
        }
        
        saveButton.enabled = false
        
        updateProfileDataOnServer()
            
        emailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
    }
    
    
    @IBAction func cancelButtonTapped(sender: UIButton)
    {
        updateElementsOnScreen()
        
        saveButton.enabled = false
        cancelButton.hidden = true
        
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
            return 0 // which will be "There is no orders"
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
        let json = self.json!["lastOrders", indexPath.row]
        
        // date label
        cell.dateLabel.text = json["date"].string!
        
        // order date is before 'today' or not
        if BADate.dateIsBeforeToday(json["date"].string!)
        {
            print("http://beautyfinders.com" + json["salonLogo"].string!)
        }
        
        cell.salonNameLabel.text = json["salonName"].string!
        cell.serviceLabel.text   = json["service"].string!
        
        
        cell.addressLabel.text   = json["salonAddress"].string!
        cell.addressLabel.fadeLength = 4
        cell.addressLabel.scrollRate = 30
        
        cell.salonLogo.kf_setImageWithURL(NSURL(string: "http://beautyfinders.com" + json["salonLogo"].string!)!, placeholderImage: UIImage(named: "Icon-72"))
        
        cell.salonLogo.layer.cornerRadius = 86/2
        cell.salonLogo.layer.masksToBounds = true
        cell.salonLogo.layer.borderWidth = 0.5
        cell.salonLogo.layer.borderColor = UIColor(white: 0, alpha: 0.1).CGColor
        
        
        let accessoryView = UIImageView(image: UIImage(named: "arrow"))
        cell.accessoryView = accessoryView
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 50))
        headerView.backgroundColor = UIColor.whiteColor()
        
        
        // label in header
        let categoryLabel = UILabel(frame: CGRectZero)
        categoryLabel.text = "Previous Orders"
        categoryLabel.textColor = UIColor(red: 171.0/255.0, green: 171.0/255.0, blue: 171.0/255.0, alpha: 1)
        categoryLabel.font = UIFont(name: "MuseoSans-700", size: 16)
        categoryLabel.sizeToFit()
        categoryLabel.center = CGPointMake(headerView.frame.width/2, headerView.frame.height/2)
        
        headerView.addSubview(categoryLabel)
        
        
        // devider in header
        let deviderImageView = UIImageView(image: UIImage(named: "divider"))
        deviderImageView.frame.size = CGSizeMake(headerView.frame.width-30, 1)
        deviderImageView.center     = CGPointMake(headerView.frame.width/2, headerView.frame.height)
        deviderImageView.alpha = 0.5
        
        headerView.addSubview(deviderImageView)
        
        return headerView
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! ProfileTableViewCell).addressLabel.restartLabel()
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