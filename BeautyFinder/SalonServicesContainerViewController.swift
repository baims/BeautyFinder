//
//  SalonServicesContainerViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 10/29/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit

class SalonServicesContainerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var json : JSON?
    
    var indexPathForSelectedRow : NSIndexPath?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func startFromButtonTapped(sender: UIButton)
    {
        showAlertView("This is a start from price", message: "This means you may end up paying more inside the salon depending on your hair length")
    }
    
    func showAlertView(title:String = "Something's wrong", message: String = "Please check your email address and phone number and make sure they are valid")
    {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
}

extension SalonServicesContainerViewController
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let json = json else
        {
            return 0
        }
        
        return json["categories"].count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let json = json else
        {
            return 0
        }
        
        return json["categories", section, "subcategories"].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SalonServicesTableViewCell
        
        cell.categoryNameLabel.text = self.json!["categories", indexPath.section, "name"].string! + " " + self.json!["categories", indexPath.section, "subcategories", indexPath.item, "name"].string!
        cell.categoryPriceLabel.text = String(format: "%.3f", arguments: [self.json!["categories", indexPath.section, "subcategories", indexPath.item, "price"].double!]) + " KD"
        
        cell.categoryImageView.kf_setImageWithURL(NSURL(string: k_website + self.json!["categories", indexPath.section, "subcategories", indexPath.item, "image"].string!)!, placeholderImage: UIImage(named: "Icon-76"))
        
        cell.startFromView.hidden = !self.json!["categories", indexPath.section, "subcategories", indexPath.item, "startfrom"].bool!
        
        
        cell.categoryImageView.layer.cornerRadius = cell.categoryImageView.frame.size.width/2
        cell.categoryImageView.layer.masksToBounds = true
        cell.categoryImageView.layer.borderWidth = 0.5
        cell.categoryImageView.layer.borderColor = UIColor(white: 0, alpha: 0.1).CGColor
        
        print(json!)
        
        let accessoryView = UIImageView(image: UIImage(named: "arrow"))
        cell.accessoryView = accessoryView
        
        cell.selectionStyle = .Gray
        
        let selectedBackgroundView = UIView(frame: cell.frame)
        selectedBackgroundView.backgroundColor = UIColor(red: 50.0/255, green: 50.0/255, blue: 50.0/255, alpha: 0.2)
        //selectedBackgroundView.alpha = 0.2
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.indexPathForSelectedRow = indexPath
        
        let selectedCell = self.tableView.cellForRowAtIndexPath(self.indexPathForSelectedRow!) as! SalonServicesTableViewCell
        let salonPK       = self.json!["pk"].int!
        let subcategoryPK = self.json!["categories", self.indexPathForSelectedRow!.section, "subcategories", self.indexPathForSelectedRow!.row, "pk"].int!
        let subcategoryName  = selectedCell.categoryNameLabel.text!
        let subcategoryPrice = (selectedCell.categoryPriceLabel.text! as NSString).doubleValue
        let startFromPrice = self.json!["categories", indexPath.section, "subcategories", indexPath.item, "startfrom"].bool!
        
        let superView = self.parentViewController as! SalonViewController
        superView.serviceIsSelected(salonPK, subcategoryPK: subcategoryPK, subcategoryName: subcategoryName, subcategoryPrice: subcategoryPrice, startFromPrice: startFromPrice)
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 50))
        headerView.backgroundColor = UIColor.whiteColor()
        
        
        // label in header
        let categoryLabel = UILabel(frame: CGRectZero)
        categoryLabel.text = self.json!["categories", section, "name"].string!
        categoryLabel.textColor = UIColor(red: 171.0/255.0, green: 171.0/255.0, blue: 171.0/255.0, alpha: 1)
        categoryLabel.font = UIFont(name: "MuseoSans-700", size: 16)
        categoryLabel.sizeToFit()
        categoryLabel.center = CGPointMake(headerView.frame.width/2, headerView.frame.height/2)
        
        headerView.addSubview(categoryLabel)
        
        
        // devider in header
        let deviderImageView = UIImageView(image: UIImage(named: "divider"))
        deviderImageView.frame.size = CGSizeMake(headerView.frame.width-30, 1)
        deviderImageView.center     = CGPointMake(headerView.frame.width/2, headerView.frame.height)
        deviderImageView.alpha = 0.5
        
        headerView.addSubview(deviderImageView)
        
        return headerView
    }
}


extension SalonViewController
{
    func serviceIsSelected(salonPK : Int, subcategoryPK : Int!, subcategoryName : String!, subcategoryPrice : Double!, startFromPrice : Bool!)
    {
        self.subcategoryName  = subcategoryName
        self.subcategoryPK    = subcategoryPK
        self.subcategoryPrice = subcategoryPrice
        self.startFromPrice   = startFromPrice
        
        self.segmentedControl.selectedIndex = 1;
        
        self.beauticiansViewController.startRefresh(salonPK, subcategoryPK: self.subcategoryPK, subcategoryName: self.subcategoryName)
        
        self.animateHiding(self.servicesContainerView, andShowing: self.beauticiansContainerView)
    
    }
}