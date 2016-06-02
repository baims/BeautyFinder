//
//  SalonServicesViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 10/13/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit
import Kingfisher

class SalonViewController: UIViewController, BACartDelegate {
    
    
    var servicesViewController : SalonServicesContainerViewController!
    @IBOutlet weak var servicesContainerView: UIView!
    
    var beauticiansViewController : SalonBeauticiansContainerViewController!
    @IBOutlet weak var beauticiansContainerView: UIView!
    
    var calendarContainerViewController : CalendarViewController!
    @IBOutlet weak var calendarContainerView: UIView!
    
    var scheduleContainerViewController : SalonScheduleViewController!
    @IBOutlet weak var scheduleContainerView: UIView!
    
    @IBOutlet weak var segmentedControl: ADVSegmentedControl!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var salonNameLabel: UILabel!
    @IBOutlet weak var salonAddressLabel: UILabel!

    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var cartCounterLabel: UILabel!
    
    
    var salonJson : JSON?
    
    var indexPathForSelectedRow : NSIndexPath?
    
    
    /* Things needed to be passed to the summaryVC */
    var subcategoryName : String!
    var subcategoryPK   : Int!
    var subcategoryPrice : Double!
    
    var beauticianName  : String!
    var beauticianPK    : Int!
    var beauticianImageUrl : String!
    
    var dateOfBooking   : String!
    var startTime       : String!
    var endTime         : String!
    
    var orders = [BAOrderData]()
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        segmentedControl.items = [" 1. Service", "  2. Beautician ", "   3. Schedule"/*, "4. Book"*/]
        segmentedControl.font = UIFont(name: "MuseoSans-700", size: 14)
        segmentedControl.selectedIndex = 0
        segmentedControl.addTarget(self, action: #selector(SalonViewController.segmentValueChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        self.logoImageView.kf_setImageWithURL(NSURL(string: k_website + self.salonJson!["logo"].string!)!, placeholderImage: UIImage(named: "Icon-76"))
        self.logoImageView.layer.cornerRadius = logoImageView.frame.width/2
        self.logoImageView.clipsToBounds = true
        
        self.salonNameLabel.text = self.salonJson!["name"].string!
        self.salonAddressLabel.text = self.salonJson!["area"].string! + ", " + self.salonJson!["address"].string!
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.tabBarController!.tabBar.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        self.logoImageView.hidden = false
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "services"
        {
            /*let selectedCell = self.tableView.cellForRowAtIndexPath(self.tableView.indexPathForSelectedRow!) as! SalonServicesTableViewCell
            
            let vc = segue.destinationViewController as! SalonBeauticiansViewController
            vc.salonPK          = self.salonJson!["pk"].int!
            vc.salonName        = self.salonNameLabel.text!
            vc.salonImagePath   = self.salonJson!["logo"].string!
            vc.salonAddress     = self.salonAddressLabel.text!
            //vc.salonLocation  = (self.json!["longitude"].double!, self.json!["latitude"].double!)
            vc.subcategoryPK  = self.salonJson!["categories", self.tableView.indexPathForSelectedRow!.section, "subcategories", self.tableView.indexPathForSelectedRow!.row, "pk"].int!
            vc.subcategoryName  = selectedCell.categoryNameLabel.text!
            vc.subcategoryPrice = (selectedCell.categoryPriceLabel.text! as NSString).doubleValue*/
            
            self.servicesViewController = segue.destinationViewController as! SalonServicesContainerViewController
            self.servicesViewController.json = self.salonJson!
        }
        else if segue.identifier == "beauticians"
        {
            self.beauticiansViewController = segue.destinationViewController as! SalonBeauticiansContainerViewController
        }
        else if segue.identifier == "calendar"
        {
            self.calendarContainerViewController = segue.destinationViewController as! CalendarViewController
        }
        else if segue.identifier == "schedule"
        {
            self.scheduleContainerViewController = segue.destinationViewController as! SalonScheduleViewController
        }
        else if segue.identifier == "summarySegue"
        {
            self.navigationController?.delegate = nil
            self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
            
//            let summaryViewController = segue.destinationViewController as! SummaryViewController
//            
//            summaryViewController.salonName        = self.salonNameLabel.text!
//            summaryViewController.salonImageUrl    = k_website + self.salonJson!["logo"].string!
//            summaryViewController.salonAddress     = self.salonAddressLabel.text!
//            
//            summaryViewController.subcategoryName  = self.subcategoryName
//            summaryViewController.subcategoryPK    = self.subcategoryPK
//            summaryViewController.subcategoryPrice = self.subcategoryPrice
//            
//            summaryViewController.beauticianName   = self.beauticianName
//            summaryViewController.beauticianPK     = self.beauticianPK
//            summaryViewController.beauticianImageUrl = self.beauticianImageUrl
//            
//            summaryViewController.dateOfBooking    = self.dateOfBooking
//            summaryViewController.startTime        = self.startTime
//            summaryViewController.endTime          = self.endTime
//            
//            summaryViewController.latitude         = self.salonJson!["latitude"].double!
//            summaryViewController.longitude        = self.salonJson!["longitude"].double!
            
            let newOrder = BAOrderData()
            newOrder.beauticianName     = self.beauticianName
            newOrder.beauticianPK       = self.beauticianPK
            newOrder.beauticianImageUrl = self.beauticianImageUrl
            newOrder.dateOfBooking      = self.dateOfBooking
            newOrder.startTime          = self.startTime
            newOrder.endTime            = self.endTime
            newOrder.subcategoryPrice   = self.subcategoryPrice
            newOrder.subcategoryPK      = self.subcategoryPK
            newOrder.subcategoryName    = self.subcategoryName
            
            orders.append(newOrder)
            
            /*
             - show the cart button with a counter on it
             - go back to the services page
             - show him a notification if it's the first time (NSUserDefaults)
             - when he taps the cart button, orders should be sent to the BACartViewController
             - when he taps the continue shopping button, orders should be sent back to this VC
             - trying to go back to the first page should show a notification saying that everything will be lost because users cannot book in more than 1 salon at a time
            */
        }
    }

    
    @IBAction func backButtonPressed(sender: UIButton)
    {
        switch (self.segmentedControl.selectedIndex)
        {
        case 0:
            self.logoImageView.hidden = true
            
            self.navigationController?.popViewControllerAnimated(true)
            
        case 1:
            self.segmentedControl.selectedIndex = 0
            
            animateHiding(self.beauticiansContainerView, andShowing: self.servicesContainerView)
            
        case 2:
            self.segmentedControl.selectedIndex = 1
            
            animateHiding(self.scheduleContainerView, andShowing: self.beauticiansContainerView)
            
        default:
            print("Out of index!")
        }
    }
    
    @IBAction func cartButtonTapped(sender: UIButton?)
    {
        let cartViewController = BACartViewController()
        cartViewController.orders = self.orders
        cartViewController.delegate = self
        
        let navController = UINavigationController(rootViewController: cartViewController)
        navController.modalPresentationStyle = .OverCurrentContext
        navController.navigationBarHidden = true
        
        presentViewController(navController, animated: false, completion: nil)
    }
    
    @IBAction func openLocationInMaps(sender: UIButton)
    {
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!))
        {
            let actionSheet = UIAlertController(title: "Open Location in:", message: nil, preferredStyle: .ActionSheet)
            
            let openGoogleMaps = UIAlertAction(title: "Google Maps", style: .Default, handler: { (action) in
                UIApplication.sharedApplication().openURL(NSURL(string:
                    "comgooglemaps://?daddr=\(self.salonJson!["latitude"].double!),\(self.salonJson!["longitude"].double!)&zoom=14")!)
            })
            
            let openAppleMaps = UIAlertAction(title: "Apple Maps", style: .Default, handler: { (action) in
                UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/?ll=\(self.salonJson!["latitude"].double!),\(self.salonJson!["longitude"].double!)&z=17")!)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            actionSheet.addAction(openGoogleMaps)
            actionSheet.addAction(openAppleMaps)
            actionSheet.addAction(cancelAction)
            
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
        else
        {
            let alertView = UIAlertController(title: "You don't have Google Maps", message: "You can download Google Maps app from the App Store to get the directions to this salon, or you can open it in Apple Maps", preferredStyle: .Alert)
            
            let openGoogleMapsAction = UIAlertAction(title: "Download Google Maps", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/us/app/google-maps/id585027354?mt=8")!)
            })
            let openAppleMapsAction = UIAlertAction(title: "Open Apple Maps", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/?ll=\(self.salonJson!["latitude"].double!),\(self.salonJson!["longitude"].double!)&z=17")!)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            alertView.addAction(openGoogleMapsAction)
            alertView.addAction(openAppleMapsAction)
            alertView.addAction(cancelAction)
            
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    // hiding & showing containerViews with animation
    func animateHiding(firstContainerView : UIView!, andShowing secondContainerView: UIView!)
    {
        self.animateHiding(firstContainerView, hidingCenter: self.servicesContainerView.center, andShowing: secondContainerView, showingCenter: secondContainerView.center)
    }
    
    func animateHiding(firstContainerView : UIView?, hidingCenter firstCenter: CGPoint!, andShowing secondContainerView: UIView?, showingCenter secondCenter: CGPoint!)
    {
        /*if let _secondContainerView = secondContainerView
        {
            _secondContainerView.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
            _secondContainerView.center    = self.servicesContainerView.center
            _secondContainerView.hidden    = false
        }
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: { () -> Void in
            if let _firstContainerView = firstContainerView
            {
                _firstContainerView.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
                _firstContainerView.center = firstCenter
            }
            
            if let _secondContainerView = secondContainerView
            {
                _secondContainerView.transform = CGAffineTransformMakeScale(1, 1)
                _secondContainerView.center = secondCenter
            }
            }, completion: { (completed) -> Void in
                if let _firstContainerView = firstContainerView
                {
                    _firstContainerView.hidden = true
                }
        })*/
        
        self.animateHiding(firstContainerView, hidingToCenter: firstCenter, andShowing: secondContainerView, showingFromCenter: nil, showingToCenter: secondCenter)
    }
    
    func animateHiding(firstContainerView: UIView?, hidingToCenter: CGPoint?, andShowing secondContainerView:UIView?, showingFromCenter : CGPoint?, showingToCenter : CGPoint?)
        {
            if let _secondContainerView = secondContainerView
            {
                _secondContainerView.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
                _secondContainerView.hidden    = false
                
                if let _ = showingFromCenter
                {
                    _secondContainerView.center = showingFromCenter!
                }
                else
                {
                    _secondContainerView.center = secondContainerView!.center
                }
            }
            
            
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: { () -> Void in
                if let _firstContainerView = firstContainerView
                {
                    _firstContainerView.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
                    
                    if let _ = hidingToCenter
                    {
                        _firstContainerView.center = hidingToCenter!
                    }
                    else
                    {
                        _firstContainerView.center = firstContainerView!.center
                    }
                }
                
                if let _secondContainerView = secondContainerView
                {
                    _secondContainerView.transform = CGAffineTransformMakeScale(1, 1)
                    if let _ = showingToCenter
                    {
                        _secondContainerView.center = showingToCenter!
                    }
                    else
                    {
                        _secondContainerView.center = secondContainerView!.center
                    }
                }
                }, completion: { (completed) -> Void in
                    if let _firstContainerView = firstContainerView
                    {
                        _firstContainerView.hidden = true
                    }
            })
    }
}

// MARK : Cart Handling stuff
extension SalonViewController
{
    func updateCart(animateToServicesContainerView : Bool)
    {
        cartCounterLabel.text = "\(orders.count > 0 ? orders.count : 1)"
        
        if cartButton.hidden == true && orders.count > 0 // new order, show cart with animation
        {
            cartButton.transform       = CGAffineTransformMakeScale(0.0001, 0.0001)
            cartCounterLabel.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
            
            cartButton.hidden = false
            cartCounterLabel.hidden = false
            
            UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 2, options: [], animations: { 
                self.cartButton.transform       = CGAffineTransformMakeScale(1,1)
                self.cartCounterLabel.transform = CGAffineTransformMakeScale(1,1)
            }) {
                (completed) in
                self.segmentedControl.selectedIndex = 0
                self.animateHiding(self.scheduleContainerView, andShowing: self.servicesContainerView)
            }
        }
        else if cartButton.hidden == false && orders.count == 0
        {
            UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 2, options: [], animations: {
                self.cartButton.transform       = CGAffineTransformMakeScale(0.0001,0.0001)
                self.cartCounterLabel.transform = CGAffineTransformMakeScale(0.0001,0.0001)
            }) {
                (completed) in
                self.cartButton.hidden = true
                self.cartCounterLabel.hidden = true
            }
        }
        else if animateToServicesContainerView
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.segmentedControl.selectedIndex = 0
                self.animateHiding(self.scheduleContainerView, andShowing: self.servicesContainerView)
            })
        }
    }
    
    func dismissCartViewController(orders: [BAOrderData]!)
    {
        self.orders = orders
        dismissViewControllerAnimated(false) { 
            self.updateCart(false)
        }
    }
}


// MARK: SegmentedControl
extension SalonViewController
{
    func segmentValueChanged(sender: AnyObject?)
    {
        if servicesContainerView.hidden == false
        {
            segmentedControl.selectedIndex = 0
            segmentedControl.flashSelectedItem()
        }
        else if segmentedControl.selectedIndex > 1 && beauticiansContainerView.hidden == false
        {
            segmentedControl.selectedIndex = 1
            segmentedControl.flashSelectedItem()
        }
        else if segmentedControl.selectedIndex == 0 && beauticiansContainerView.hidden == false
        {
            animateHiding(beauticiansContainerView, andShowing: self.servicesContainerView)
        }
        else if segmentedControl.selectedIndex == 0 && scheduleContainerView.hidden == false
        {
            animateHiding(scheduleContainerView, andShowing: servicesContainerView)
        }
        else if segmentedControl.selectedIndex == 1 && scheduleContainerView.hidden == false
        {
            animateHiding(scheduleContainerView, andShowing: beauticiansContainerView)
        }
    }
}