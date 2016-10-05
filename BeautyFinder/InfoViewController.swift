//
//  InfoViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 10/4/16.
//  Copyright © 2016 Baims. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController
{
    @IBOutlet weak var infoSheet: UIView!
    @IBOutlet weak var termsAndConditionsButtonLabel: UIButton!
    @IBOutlet weak var termsAndConditionsButtonArrow: UIButton!
    
    var infoSheetCenter : CGPoint!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        infoSheet.layer.cornerRadius = 16
        infoSheet.layer.masksToBounds = true
        
        if infoSheet.center.y > 0
        {
            // placing addSheet above the screen
            infoSheetCenter = infoSheet.center
            placeAddSheetOnTopOfScreen()
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func placeAddSheetOnTopOfScreen()
    {
        infoSheet.center.y = 0 - infoSheet.frame.height/2
    }
    
    func showInfoSheetWithAnimation()
    {
        print(infoSheetCenter)
        
        UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.infoSheet.center = self.infoSheetCenter!
        }) { (completed) in
            
        }
    }
    
    func hideViewController()
    {
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.infoSheet.center.y += 80
            }, completion: { (completed) in
                
                (self.parentViewController as! CategoriesViewController).hideInfoVC()
                
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 1, options: [], animations: {
                    
                    }, completion: nil)
                
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 1, options: [], animations: {
                    self.placeAddSheetOnTopOfScreen()
                    }, completion: { (completed) in

                })
        })
    }
    
    @IBAction func userTappedOutsideOfInfoView(sender: UITapGestureRecognizer)
    {
        let view    = sender.view
        let loc     = sender.locationInView(view)
        let subview = view?.hitTest(loc, withEvent: nil)
        
        if subview != infoSheet // means that he's tapped outside of addSheet to dismiss this VC
        {
            hideViewController()
        }
    }
    
    // MARK: Terms & Conditions buttons stuff
    
    // TOUCH UP INSIDE events
    @IBAction func termsAndConditionsButtonIsTapped()
    {
        (self.parentViewController as! CategoriesViewController).performSegueWithIdentifier("termsAndConditions", sender: nil)
        
        self.termsAndConditionsButtonTouchedUpOutside()
    }
    
    // TOUCH UP OUTSIDE events
    @IBAction func termsAndConditionsButtonTouchedUpOutside()
    {
        self.termsAndConditionsButtonLabel.highlighted = false
        self.termsAndConditionsButtonArrow.highlighted = false
    }
    
    
    // TOUCH DOWN events
    @IBAction func termsAndConditionsButtonTouchedDown(sender: UIButton)
    {
        self.termsAndConditionsButtonArrow.highlighted = true
        self.termsAndConditionsButtonLabel.highlighted = true
        
        print("touchedDown")
    }
    
    @IBAction func termsAndConditionsButtonArrowTouchedDown(sender: UIButton)
    {
        self.termsAndConditionsButtonTouchedDown(sender)
    }
    
    
}
