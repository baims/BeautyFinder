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
    @IBOutlet weak var dashLabel: UILabel!
    
    var defaultTextColor : UIColor = UIColor.darkGrayColor()
    
    /*@IBInspectable var isBooked : Bool = false
    {
        didSet
        {
            if isBooked == true
            {
                defaultTextColor = UIColor.lightGrayColor()
                defaultTextColor = UIColor.lightGrayColor()
                defaultTextColor = UIColor.lightGrayColor()
            }
            else
            {
                defaultTextColor = UIColor.darkGrayColor()
                defaultTextColor = UIColor.darkGrayColor()
                defaultTextColor = UIColor.darkGrayColor()
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
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
