//
//  BAWebViewDelegate.swift
//  MyFatoora
//
//  Created by Bader Alrshaid on 3/27/16.
//  Copyright © 2016 Bader Alrshaid. All rights reserved.
//

import UIKit

@objc protocol BAWebViewDelegate
{
    optional func webViewIsLoadingNewURL(url: NSURL!)
    optional func webViewDidLoadNewURL(url: NSURL!)
    optional func webViewCancelButtonIsTapped()
}
