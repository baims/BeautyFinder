//
//  DateAndTimeConverter.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 12/3/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import Foundation

class DateTimeConverter
{
    
    /**
     Gets time as a string (ex. 16:00:00) and returns it with AM or PM (ex. 4:00 AM)
     - Parameter time: ex. 16:00:00
     - Returns: ex. "4:00 PM"
     */
    
    class func convertTimeToString(time : String) -> String
    {
        let timeString : String
        
        var hour : String = time[time.startIndex.advancedBy(0) ... time.startIndex.advancedBy(1)]
        let minute : String = time[time.startIndex.advancedBy(3) ... time.startIndex.advancedBy(4)]
        
        
        if (Int(hour) >= 12)
        {
            hour = Int(hour) == 12 ? String(Int(hour)!) : String( Int(hour)! - 12 )
            
            timeString = hour + ":" + minute + " PM"
        }
        else
        {
            hour = String(Int(hour)!)
            
            timeString = hour + ":" + minute + " AM"
        }
        
        
        return timeString
    }
    
    
    /**
     Gets a date as a string (ex. 2015-01-20) and returns the day of it (ex. Thursday)
     - Parameter today: ex. 2015-01-20
     - Returns: ex. "Thursday"
     */
    class func getDayOfWeek(today:String)-> String?
    {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let todayDate = formatter.dateFromString(today)
        {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
            let weekDay = myComponents.weekday
            
            switch weekDay
            {
            case 1:
                return "Sunday"
            case 2 :
                return "Monday"
            case 3:
                return "Tuesday"
            case 4 :
                return "Wednesday"
            case 5:
                return "Thursday"
            case 6 :
                return "Friday"
            case 7:
                return "Saturday"
            default:
                return "OUT OF INDEX!"
            }
        }
        else
        {
            return nil
        }
    }
}