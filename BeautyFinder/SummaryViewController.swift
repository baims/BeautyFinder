//
//  SummaryViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 11/14/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class SummaryViewController: UIViewController {
        
    @IBOutlet weak var beauticianImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var textOfPayButtonLabel: UILabel!
    @IBOutlet weak var salonNameLabel: UILabel!
    @IBOutlet weak var beauticianNameLabel: UILabel!
    @IBOutlet weak var subcatgoryNameLabel: UILabel!
    @IBOutlet weak var salonAddressLabel: UILabel!
    @IBOutlet weak var dateOfBookingLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var totalPriceView: UIView!
    
    @IBOutlet weak var bookAndPayButton: UIButton!
    
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var salonNameLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalPriceBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bookAndPayButtonHeightConstraint: NSLayoutConstraint!
    
    
    var viewIsLoaded = false
    
    var needToHideBookButton = false
    
    var salonName     : String!
    var salonImageUrl : String!
    var salonAddress  : String!
    
    var subcategoryName  : String!
    var subcategoryPK    : Int!
    var subcategoryPrice : Double!
    
    var beauticianName     : String!
    var beauticianPK       : Int!
    var beauticianImageUrl : String!
    
    var dateOfBooking   : String!
    var startTime       : String!
    var endTime         : String!
    
    var longitude : Double!
    var latitude  : Double!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        salonNameLabel.text      = salonName
        salonAddressLabel.text   = salonAddress
        
        beauticianNameLabel.text = beauticianName
        
        subcatgoryNameLabel.text = subcategoryName
        totalPriceLabel.text = "\(subcategoryPrice) KD" //String(format: "%.3f", arguments: [subcategoryPrice]) + " KD"
        
        dateOfBookingLabel.text = dateOfBooking
        startTimeLabel.text     = DateTimeConverter.convertTimeToString(startTime)
        endTimeLabel.text       = DateTimeConverter.convertTimeToString(endTime)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews()
    {
        self.logoImageView.kf_setImageWithURL(NSURL(string: self.salonImageUrl)!, placeholderImage: UIImage(named: "Icon-76"))
        self.logoImageView.layer.cornerRadius = logoImageView.frame.width/2
        self.logoImageView.clipsToBounds = true
        self.logoImageView.layer.borderWidth = 0.5
        self.logoImageView.layer.borderColor = UIColor(white: 0, alpha: 0.1).CGColor
        
        self.beauticianImageView.kf_setImageWithURL(NSURL(string: self.beauticianImageUrl)!, placeholderImage: UIImage(named: "Icon-76"))
        self.beauticianImageView.layer.cornerRadius = beauticianImageView.frame.width/2
        self.beauticianImageView.clipsToBounds = true
        self.beauticianImageView.layer.borderWidth = 0.5
        self.beauticianImageView.layer.borderColor = UIColor(white: 0, alpha: 0.1).CGColor
        
        
        totalPriceLabel.sizeToFit()
        
        
        if !viewIsLoaded
        {
            viewIsLoaded = true
            
            if needToHideBookButton
            {
                bookAndPayButtonHeightConstraint.constant = 0
            }
            
            /*** Changing the placement of the labels/images depending on the device ***/
            switch self.view.frame.height
            {
            case 480: // iPhone 4/4s
                stackViewTopConstraint.constant = 6
                salonNameLabelTopConstraint.constant = 12
                totalPriceBottomConstraint.constant = 6
                
            case 568: // iPhone 5/5s/5c
                salonNameLabelTopConstraint.constant = 40
                
            case 667: // iPhone 6/6s
                stackViewTopConstraint.constant      = 30
                salonNameLabelTopConstraint.constant = 64
                totalPriceBottomConstraint.constant  = 50
                
            case 736: // iPhone 6+/6s+
                stackViewTopConstraint.constant      = 40
                salonNameLabelTopConstraint.constant = 90
                totalPriceBottomConstraint.constant  = 60
                
            default:
                stackViewTopConstraint.constant = 106
                stackViewTopConstraint.constant = 280
            }
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {        
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey("token")
        {
            self.textOfPayButtonLabel.text = "Pay & Book"
        }
        else
        {
            self.textOfPayButtonLabel.text = "Log In To Continue Booking"
        }
    }

    @IBAction func backButtonTapped(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func bookAndPayButtonTapped(sender: UIButton)
    {
        if let token = NSUserDefaults.standardUserDefaults().stringForKey("token")
        {
            SwiftSpinner.show("Please Wait...")
            // reserving booking
            self.reserveBooking(token)
        }
        else
        {
            self.performSegueWithIdentifier("logIn", sender: nil)
        }
    }
    
    
    @IBAction func openLocationInMaps(sender: UIButton)
    {
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!))
        {
            let actionSheet = UIAlertController(title: "Open Location in:", message: nil, preferredStyle: .ActionSheet)
           
            let openGoogleMaps = UIAlertAction(title: "Google Maps", style: .Default, handler: { (action) in
                UIApplication.sharedApplication().openURL(NSURL(string:
                    "comgooglemaps://?daddr=\(self.latitude),\(self.longitude)&zoom=14")!)
            })
            
            let openAppleMaps = UIAlertAction(title: "Apple Maps", style: .Default, handler: { (action) in
                UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/?ll=\(self.latitude),\(self.longitude)&z=17")!)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            actionSheet.addAction(openGoogleMaps)
            actionSheet.addAction(openAppleMaps)
            actionSheet.addAction(cancelAction)
            
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
        else
        {
            let alertView = UIAlertController(title: "You don't have Google Maps", message: "You can download Google Maps app from the App Store to get the directions to this salon, or you can open it in Apple Maps", preferredStyle: .Alert)
            
            let openGoogleMapsAction = UIAlertAction(title: "Download Google Maps", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/us/app/google-maps/id585027354?mt=8")!)
            })
            let openAppleMapsAction = UIAlertAction(title: "Open Apple Maps", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/?ll=\(self.latitude),\(self.longitude)&z=17")!)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            alertView.addAction(openGoogleMapsAction)
            alertView.addAction(openAppleMapsAction)
            alertView.addAction(cancelAction)
            
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
    

    func reserveBooking(token : String!)
    {
        sendRequestToWebsite(token, withExtensionLink: "reserve/")
    }
    
    func orderBooking(token: String!)
    {
        sendRequestToWebsite(token, withExtensionLink: "order/")
    }
    
    
    /**
      Sends request for the website for booking or reserving appointments
 - Parameter extensionLink: may take values "order/" or "reserve/"
 */
    func sendRequestToWebsite(token : String!, withExtensionLink extensionLink: String!)
    {
        let parameters = ["beauticianpk" : beauticianPK,
                          "starttime" : "\(startTime)",
                          "endtime" : "\(endTime)",
                          "date" : dateOfBooking,
                          "subcategorypk" : subcategoryPK] as [String : AnyObject]
        
        let headers = ["Authorization" : "Token \(token)"]
        
        Alamofire.request(.POST, k_website + extensionLink, parameters: parameters, headers: headers).responseJSON(completionHandler: { (response) -> Void in
        
                    if let Json = response.result.value
                    {
                        let json = JSON(Json)
                        if json["Operation"].string! == "ok" && extensionLink == "reserve/"
                        {
                            self.getProfileDataAndFetchMyFatoorahLink(token)
                        }
                        else if json["Operation"].string! == "error" && extensionLink == "reserve/"
                        {
                            SwiftSpinner.hide()
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.showAlertView("We're Sorry!", message: "This appointment is already booked by another customer! Please try again with another time or date.")
                            })
                        }
                        else if json["Operation"].string! == "ok" && extensionLink == "order/"
                        {
                            SwiftSpinner.hide()
                            
                            // TODO: show some fancy stuff to let the user know that the booking has succeeded
                            dispatch_async(dispatch_get_main_queue(), { 
                                self.bookAndPayButton.hidden = true
                                self.showAlertView("Thank you!", message: "We received your payment successfully.")
                            })
                        }
                        print(json)
                    }
                    else if let error = response.result.error
                    {
                        print(error)
                    }
                })
        
        print("\n\nWebsite: \(k_website + extensionLink)")
        print("\n\nParameters: ")
        print(parameters)
        print("\n\nHeader: ")
        print(headers)
        print("\n\n")
    }
    
    func getProfileDataAndFetchMyFatoorahLink(token: String!)
    {
        // Getting name, email and phone number of the user
        // and then fetching the payment link from myFatoorah ( inside the block )
        let headers = ["Authorization" : "Token \(token)"]
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        
        Alamofire.request(.GET, k_website + "user/profile/", parameters: nil, headers: headers).responseJSON(completionHandler: { (response) -> Void in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            
            if let resultJson = response.result.value
            {
                let json = JSON(resultJson)
                
                
                self.fetchMyfatoorahLinkWith(withName: json["name"].string!,
                    email: json["email"].string!, phone: json["Phonenumber"].string!,
                    service: self.subcategoryName, price: self.subcategoryPrice)
            }
            else if let error = response.result.error
            {
                print(error)
            }
        })
    }
}
