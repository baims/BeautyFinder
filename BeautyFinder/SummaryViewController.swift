//
//  SummaryViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 11/14/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit
import Alamofire

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
    
    var viewIsLoaded = false
    
    var needToHideBookButton = false
    
    var salonName : String!
    var salonImageUrl : String!
    var salonAddress : String!
    
    var subcategoryName : String!
    var subcategoryPK   : Int!
    var subcategoryPrice : Double!
    
    var beauticianName  : String!
    var beauticianPK    : Int!
    var beauticianImageUrl : String!
    
    var dateOfBooking   : String!
    var startTime       : String!
    var endTime         : String!
    
    

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
                bookAndPayButton.hidden = true
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
            // use the token to reserve the booking
            // then go to knet page
            // finally, if the payment succeeds, then book the appointment
            
            self.reserveBooking(token)
        }
        else
        {
            self.performSegueWithIdentifier("logIn", sender: nil)
        }
    }

    func reserveBooking(token : String!)
    {
        let parameters = ["beauticianpk" : beauticianPK,
            "starttime" : "\(startTime)",
            "endtime" : "\(endTime)",
            "date" : dateOfBooking,
            "subcategorypk" : subcategoryPK] as [String : AnyObject]
        
        let headers = ["Authorization" : "Token \(token)"]
        
        Alamofire.request(.POST, k_website + "reserve/", parameters: parameters, headers: headers).responseString { (response) -> Void in
            if let string = response.result.value
                        {
                            //let json = JSON(Json)
                            print(string)
                        }
                        else if let error = response.result.error
                        {
                            print(error)
                        }
        }
//         responseJSON(completionHandler: { (response) -> Void in
//            
//            if let Json = response.result.value
//            {
//                let json = JSON(Json)
//                print(json)
//            }
//            else if let error = response.result.error
//            {
//                print(error)
//            }
//        })
        
        print("\n\nWebsite: \(k_website + "reserve/")")
        print("\n\nParameters: ")
        print(parameters)
        print("\n\nHeader: ")
        print(headers)
        print("\n\n")
    }
}
