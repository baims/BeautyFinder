//
//  String+EmailPhoneValidation.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 1/21/16.
//  Copyright © 2016 Baims. All rights reserved.
//

import Foundation

extension String
{
    func isValidEmail() -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluateWithObject(self)
        
        return result
    }
    
    func isValidPhoneNumber() -> Bool {
        
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        
        let result =  phoneTest.evaluateWithObject(self)
        
        return result
        
    }
}
