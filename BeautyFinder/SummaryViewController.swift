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
    
    let website = "https://aqueous-dawn-8486.herokuapp.com/"
    
    var salonName : String!
    var salonImageUrl : String!

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
        
        
        
        UIView.animateWithDuration(0.2, delay: 0.1, options: [UIViewAnimationOptions.Repeat, UIViewAnimationOptions.Autoreverse, UIViewAnimationOptions.CurveEaseOut], animations: { () -> Void in
            
            self.beauticianImageView.hidden = true
            }) { (completed) -> Void in
                if (self.beauticianImageView.frame.size.height == 0)
                {
                    //self.beauticianImageView.hidden = true
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
        
        Alamofire.request(.POST, website + "reserve/", parameters: parameters, headers: headers).responseString { (response) -> Void in
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
        
        print("\n\nWebsite: \(website + "reserve/")")
        print("\n\nParameters: ")
        print(parameters)
        print("\n\nHeader: ")
        print(headers)
        print("\n\n")
    }
}
