//
//  SearchTextField.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 9/18/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit

class SearchTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.borderStyle        = .None
        self.backgroundColor    = UIColor(red: 177/255, green: 133/255, blue: 150/255, alpha: 0.7)
        self.textColor          = UIColor.whiteColor()
        self.layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
}
