//
//  TermsAndConditionsViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 10/5/16.
//  Copyright © 2016 Baims. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backButtonTapped()
    {
        if let _ = self.navigationController
        {
            self.navigationController!.popViewControllerAnimated(true)
        }
        else
        {
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
}
