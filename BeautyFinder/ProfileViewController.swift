//
//  ProfileViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 1/12/16.
//  Copyright © 2016 Baims. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController
{
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    
    let emailIsChanged = false
    let phoneNumberIsChanged = false
    
    var json : JSON?
    var token : String?
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        getProfileJsonIfSignedIn()
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
        
        if phoneNumberIsChanged
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
    }
    
}
