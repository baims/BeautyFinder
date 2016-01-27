//
//  BAAutoResizingTextField.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 1/21/16.
//  Copyright © 2016 Baims. All rights reserved.
//

import UIKit

class BAAutoResizingTextField: UITextField {

    override func intrinsicContentSize() -> CGSize {
        if self.editing == true
        {
            let size = NSString(string: self.text!).sizeWithAttributes(self.typingAttributes)
            return CGSizeMake(size.width + 2, size.height)
        }
        
        return super.intrinsicContentSize()
    }
}
