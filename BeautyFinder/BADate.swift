//
//  BADate.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 1/28/16.
//  Copyright © 2016 Baims. All rights reserved.
//

import Foundation

class BADate : NSObject
{
    class func dateIsBeforeToday(date : String) -> Bool
    {
        //Ref date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let someDate = dateFormatter.dateFromString(date)
        
        //Get calendar
        let calendar = NSCalendar.currentCalendar()
        
        //Get just MM/dd/yyyy from current date
        let components = calendar.components([.Day, .Month, .Year] , fromDate: NSDate())
        
        //Convert to NSDate
        let today = calendar.dateFromComponents(components)
        
        
        if someDate!.timeIntervalSinceDate(today!).isSignMinus
        {
            return true
        }
        else
        {
            return false
        }
    }
}