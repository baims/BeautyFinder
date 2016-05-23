//
//  BAOrderData.swift
//  CartForBeautyFinder
//
//  Created by Bader Alrshaid on 5/17/16.
//  Copyright © 2016 Bader Alrshaid. All rights reserved.
//

import UIKit

class BAOrderData: NSObject {
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
}
