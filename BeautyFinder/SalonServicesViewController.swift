//
//  SalonServicesViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 10/13/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit
import Kingfisher

class SalonServicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var segmentedControl: ADVSegmentedControl!
    
    let website = "https://aqueous-dawn-8486.herokuapp.com/"
    
    var serviceImageViews : [[UIImageView?]] = []
    
    var json : JSON?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        segmentedControl.items = ["SERVICES", "BEAUTICIANS"]
        segmentedControl.font = UIFont(name: "MuseoSans-700", size: 14)
        segmentedControl.selectedIndex = 0
        segmentedControl.addTarget(self, action: "segmentValueChanged:", forControlEvents: .ValueChanged)
        
        self.title = self.json!["name"].string!
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

}

// MARK: SegmentedControl
extension SalonServicesViewController
{
    func segmentValueChanged(sender: AnyObject?){
        
        if segmentedControl.selectedIndex == 0
        {
            //self.salonSearchContainerView.hidden = false
            //self.areaSearchContainerView.hidden  = true
        }
        else if segmentedControl.selectedIndex == 1
        {
            
        }
    }
}


extension SalonServicesViewController
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SalonServicesTableViewCell
        
        cell.categoryNameLabel.text = self.json!["categories", indexPath.section, "name"].string! + " " + self.json!["categories", indexPath.section, "subcategories", indexPath.item, "name"].string!
        cell.categoryPriceLabel.text = String(format: "%.3f", arguments: [self.json!["categories", indexPath.section, "subcategories", indexPath.item, "price"].double!]) + " KD"
        
        cell.categoryImageView.kf_setImageWithURL(NSURL(string: self.website + self.json!["categories", indexPath.section, "subcategories", indexPath.item, "image"].string!)!, placeholderImage: UIImage(named: "Icon-76"))
        
        
        cell.categoryImageView.layer.cornerRadius = cell.categoryImageView.frame.size.width/2
        cell.categoryImageView.layer.masksToBounds = true
        
        
        
        let accessoryView = UIImageView(image: UIImage(named: "arrow"))
        cell.accessoryView = accessoryView
        
        cell.selectionStyle = .Gray
        
        let selectedBackgroundView = UIView(frame: cell.frame)
        selectedBackgroundView.backgroundColor = UIColor(red: 50.0/255, green: 50.0/255, blue: 50.0/255, alpha: 0.2)
        //selectedBackgroundView.alpha = 0.2
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 70))
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