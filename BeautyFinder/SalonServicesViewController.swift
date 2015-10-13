//
//  SalonServicesViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 10/13/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit

class SalonServicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var segmentedControl: ADVSegmentedControl!
    
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
        cell.categoryPriceLabel.text = String(self.json!["categories", indexPath.section, "subcategories", indexPath.item, "price"].double!) + " KD"
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 70))
        
        let categoryLabel = UILabel(frame: CGRectZero)
        categoryLabel.text = self.json!["categories", section, "name"].string!
        categoryLabel.sizeToFit()
        categoryLabel.center = CGPointMake(headerView.frame.width/2, headerView.frame.height/2)
        
        headerView.addSubview(categoryLabel)
        
        return headerView
    }
}