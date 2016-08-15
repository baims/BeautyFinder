//
//  BAOrderData.swift
//  CartForBeautyFinder
//
//  Created by Bader Alrshaid on 5/17/16.
//  Copyright © 2016 Bader Alrshaid. All rights reserved.
//

import UIKit

class BAOrderData : NSObject {
    //var salonName     : String!
    //var salonImageUrl : String!
    //var salonAddress  : String!
    
    var subcategoryName  : String! = "Hair Cutting"
    var subcategoryPK    : Int! = 2
    var subcategoryPrice : Double! = 2.3
    
    var beauticianName     : String! = "Merry"
    var beauticianPK       : Int! = 3
    var beauticianImageUrl : String! = "http://beautyfinders.com/media/Beautician/robroy_XMEOYBF.jpg"
    
    var dateOfBooking   : String! = "22 / 12 / 2016"
    var startTime       : String! = "8:00 AM"
    var endTime         : String! = "10:00 AM"
    
    var startFromPrice : Bool! = false
}

func == (lhs: BAOrderData, rhs: BAOrderData) -> Bool
{
    print("\(lhs.dateOfBooking) == \(rhs.dateOfBooking)")
    print("\(lhs.startTime) == \(rhs.startTime)")
    
    if lhs.dateOfBooking != rhs.dateOfBooking
    {
        return false
    }
    
    if lhs.startTime != rhs.startTime
    {
        return false
    }
    
    if lhs.endTime != rhs.endTime
    {
        return false
    }
    
    if lhs.beauticianName != rhs.beauticianName
    {
        return false
    }
    
    return true
}


infix operator ~ {}

func ~ (lhs : BAOrderData, rhs: BAOrderData) -> Bool
{
    if lhs.beauticianName != rhs.beauticianName
    {
        return false
    }
    
    if lhs.dateOfBooking != rhs.dateOfBooking
    {
        return false
    }
    
    
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyy-MM-dd HH:mm:ss"
    
    let leftStartDate = formatter.dateFromString("\(lhs.dateOfBooking) \(lhs.startTime)")
    let leftEndDate = formatter.dateFromString("\(lhs.dateOfBooking) \(lhs.endTime)")
    let rightStartDate = formatter.dateFromString("\(rhs.dateOfBooking) \(rhs.startTime)")
    let rightEndDate = formatter.dateFromString("\(rhs.dateOfBooking) \(rhs.endTime)")
    
    if (rightStartDate?.timeIntervalSince1970 >= leftStartDate?.timeIntervalSince1970 && rightStartDate?.timeIntervalSince1970 <= leftEndDate?.timeIntervalSince1970)
    || (rightEndDate?.timeIntervalSince1970 >= leftStartDate?.timeIntervalSince1970 && rightEndDate?.timeIntervalSince1970 <= leftEndDate?.timeIntervalSince1970)
    {
        print("CONFLICT: THERE IS AN OVERLAP!")
        return true
    }
    
    
    return false
}