//
//  UIImageView+URL.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 10/1/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit

class UIImageView_URL: NSObject
{
}

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            
            NSURLConnection.sendAsynchronousRequest(request, queue: .mainQueue(), completionHandler: { (response, data, error) -> Void in
                if let data = data
                {
                    self.image = UIImage(data: data)
                }
            })
        }
    }
}