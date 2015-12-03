//
//  SalonScheduleTableViewCell.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 11/6/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit

//@IBDesignable

class SalonScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var dash1View: UIView!
    @IBOutlet weak var dash2View: UIView!
    @IBOutlet weak var availabilityLabel: UILabel!
    

    var isBooked : Bool = false {
        didSet
        {
            if isBooked == true
            {
                print(isBooked)
                startTimeLabel.textColor = UIColor.lightGrayColor()
                endTimeLabel.textColor   = UIColor.lightGrayColor()
                fromLabel.textColor      = UIColor.lightGrayColor()
                toLabel.textColor        = UIColor.lightGrayColor()
                dash1View.backgroundColor = UIColor.lightGrayColor()
                dash2View.backgroundColor = UIColor.lightGrayColor()
                
                availabilityLabel.text      = "BOOKED"
                availabilityLabel.textColor = UIColor.lightGrayColor()
            }
            else
            {
                startTimeLabel?.textColor = UIColor.blackColor()
                endTimeLabel?.textColor   = UIColor.blackColor()
                fromLabel?.textColor      = UIColor.blackColor()
                toLabel?.textColor        = UIColor.blackColor()
                dash1View?.backgroundColor = UIColor(red: 213.0/255.0, green: 38.0/255.0, blue: 101.0/255.0, alpha: 1)
                dash2View?.backgroundColor = UIColor(red: 213.0/255.0, green: 38.0/255.0, blue: 101.0/255.0, alpha: 1)
                
                availabilityLabel?.text      = "AVAILABLE"
                availabilityLabel?.textColor = UIColor(red: 0, green: 175.0/255.0, blue: 0, alpha: 1.0) //UIColor(red: 213.0/255.0, green: 38.0/255.0, blue: 101.0/255.0, alpha: 1)
            }
        }
    }
    
    
    var defaultTextColor : UIColor = UIColor.darkGrayColor()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        /*startTimeLabel.textColor = defaultTextColor
        endTimeLabel.textColor   = defaultTextColor
        dashLabel.textColor      = defaultTextColor*/
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
