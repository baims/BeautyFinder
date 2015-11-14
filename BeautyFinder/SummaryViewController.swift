//
//  SummaryViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 11/14/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    
    @IBOutlet weak var textOfPayButtonLabel: UILabel!
    
    
    var salonName : String!

    var subcategoryName : String!
    var subcategoryPK   : Int!
    var subcategoryPrice : Double!
    
    var beauticianName  : String!
    var beauticianPK    : Int!
    
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
        //print(salonName)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        print("viewWillAppear")
        
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey("token")
        {
            self.textOfPayButtonLabel.text = "Pay & Book"
        }
        else
        {
            self.textOfPayButtonLabel.text = "Log In To Continue Booking"
        }
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
            
            print(token)
        }
        else
        {
            self.performSegueWithIdentifier("logIn", sender: nil)
        }
    }

}
