//
//  SalonScheduleViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 11/6/15.
//  Copyright © 2015 Baims. All rights reserved.
//

import UIKit
import CVCalendar

class SalonScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var tableViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewLeadingConstraint: NSLayoutConstraint!
    
    var viewIsLoaded = false
    
    var json : JSON?
    var indexPathForSelectedRow : NSIndexPath!
    
    var selectedDate : CVDate!
    var jsonOfSelectedDate : JSON?
    
    
    
    override func viewDidLayoutSubviews()
    {
        if !viewIsLoaded
        {
            viewIsLoaded = true
            
            
            if self.view.frame.width == 414 // iPhone 6+/6s+
            {
                tableViewTrailingConstraint.constant = -20
                tableViewLeadingConstraint.constant  = -20
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showCalendarView(sender: UIButton)
    {
        let parentViewController = self.parentViewController as! SalonViewController
        parentViewController.showCalendarViewController()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func startRefresh(json : JSON!)
    {
        self.startRefresh(CVDate(date: NSDate()), json: json)
    }
    
    func startRefresh(date : CVDate!, json : JSON!)
    {
        self.json = json
        
        self.startRefresh(date)
    }
    
    func startRefresh(date : CVDate!)
    {
        self.selectedDate = date
        
        let stringOfDate : String = String(format: "%i-%02i-%02i", arguments: [self.selectedDate.year, self.selectedDate.month, self.selectedDate.day]) // writing the date in YYYY-MM-DD format (ex: 2015-11-06 )
        let dayOfWeek = DateTimeConverter.getDayOfWeek(stringOfDate)!
        
        self.dateLabel.text = dayOfWeek + "   \(selectedDate.day)/\(selectedDate.month)/\(selectedDate.year)"
        
        
        self.jsonOfSelectedDate = nil
        
        for schedule in self.json!["schedule"].array! where schedule["date"].string! == stringOfDate
        {
            self.jsonOfSelectedDate = schedule
            
            //print(self.jsonOfSelectedDate)
        }
        
        self.tableView.reloadData()
    }
    
    
    func availableBookingExistInDate(date: CVDate!) -> Bool
    {
        let stringOfDate : String = String(format: "%i-%02i-%02i", arguments: [date.year, date.month, date.day]) // writing the date in YYYY-MM-DD format (ex: 2015-11-06 )
        
        if let _ = self.json
        {
            for schedule in self.json!["schedule"].array! where schedule["date"].string! == stringOfDate
            {
                for time in schedule["time"].array! where time["is_busy"].bool! == false
                {
                    return true
                }
            }
        }
        
        return false
    }
    
    
    func isDateAvailable(date: CVDate!) -> Bool
    {
        let stringOfDate : String = String(format: "%i-%02i-%02i", arguments: [date.year, date.month, date.day]) // writing the date in YYYY-MM-DD format (ex: 2015-11-06 )
        
        if let _ = self.json
        {
            for schedule in self.json!["schedule"].array! where schedule["date"].string! == stringOfDate
            {
                return true
            }
        }
        
        return false
    }
}


extension SalonScheduleViewController
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let Json = jsonOfSelectedDate else
        {
            return 0
        }
        
        return Json["time"].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SalonScheduleTableViewCell
        
        
        cell.startTimeLabel.text = DateTimeConverter.convertTimeToString(self.jsonOfSelectedDate!["time", indexPath.row, "start"].string!)
        cell.endTimeLabel.text   = DateTimeConverter.convertTimeToString(self.jsonOfSelectedDate!["time", indexPath.row, "end"].string!)
        //cell.isBooked            = self.jsonOfSelectedDate!["time", indexPath.row, "is_busy"].bool!
        
        if self.jsonOfSelectedDate!["time", indexPath.row, "is_busy"].bool! == false
        {
            cell.bookingStatus = .Available
            
            let presentingVC = self.parentViewController as! SalonViewController
            
            print(json!)
            
            for existingOrder in presentingVC.orders
            {
                let cellOrder = BAOrderData()
                cellOrder.beauticianName = json!["name"].string!
                cellOrder.dateOfBooking  = String(format: "%i-%i-%i", arguments: [self.selectedDate.year, self.selectedDate.month, self.selectedDate.day])
                cellOrder.startTime      = self.jsonOfSelectedDate!["time", indexPath.row, "start"].string!
                cellOrder.endTime        = self.jsonOfSelectedDate!["time", indexPath.row, "end"].string!
                
                if existingOrder == cellOrder
                {
                    cell.bookingStatus = .InCart
                    break
                }
            }
        }
        else
        {
            cell.bookingStatus = .Booked
        }
        
        
        
        if cell.bookingStatus == .Booked || cell.bookingStatus == .InCart
        {
            cell.selectionStyle = .None // to disable highlighting when the user uses
            
            cell.accessoryView = nil
        }
        else
        {
            cell.selectionStyle = .Gray
            
            let accessoryView = UIImageView(image: UIImage(named: "arrow"))
            cell.accessoryView = accessoryView
        }
        
        
        let selectedBackgroundView = UIView(frame: cell.frame)
        selectedBackgroundView.backgroundColor = UIColor(red: 50.0/255, green: 50.0/255, blue: 50.0/255, alpha: 0.2)
        //selectedBackgroundView.alpha = 0.2
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.indexPathForSelectedRow = indexPath
        
        let date      = "\(selectedDate.year)-\(selectedDate.month)-\(selectedDate.day)"
        let startTime = self.jsonOfSelectedDate!["time", self.indexPathForSelectedRow.row, "start"].string!
        let endTime = self.jsonOfSelectedDate!["time", self.indexPathForSelectedRow.row, "end"].string!
        
        let parentViewController = self.parentViewController as! SalonViewController
        parentViewController.scheduleIsSelectedWithDate(date, startTime: startTime, endTime: endTime)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SalonScheduleTableViewCell
        
        print(cell.bookingStatus)
        
        if cell.bookingStatus == .Available
        {
            return indexPath
        }
        else
        {
            return nil
        }
    }
    
    
    /*func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
     }*/
}

extension SalonViewController
{
    func showCalendarViewController()
    {
        if self.calendarContainerView.hidden == true
        {
            let showingFromCenter = CGPointMake(self.scheduleContainerView.frame.size.width-40, self.scheduleContainerView.frame.origin.y+30)
            self.animateHiding(nil, hidingToCenter: nil, andShowing: self.calendarContainerView, showingFromCenter: showingFromCenter, showingToCenter: self.view.center)
        }
        else
        {
            let hidingToCenter = CGPointMake(self.scheduleContainerView.frame.size.width-30, self.scheduleContainerView.frame.origin.y+30)
            self.animateHiding(self.calendarContainerView, hidingCenter: hidingToCenter, andShowing: nil, showingCenter: CGPointZero)
        }
    }
    
    func scheduleIsSelectedWithDate(date: String!, startTime: String!, endTime: String!)
    {
        self.dateOfBooking = date
        self.startTime     = startTime
        self.endTime       = endTime
        
        //self.performSegueWithIdentifier("summarySegue", sender: nil)
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
        newOrder.startFromPrice     = self.startFromPrice
        
        orders.append(newOrder)
        
        /*
         - show him a notification if it's the first time (NSUserDefaults) OR MAKE HEART ANIMATION EVERY TIME NEW ELEMENT IS THERE
         - trying to go back to the first page should show a notification saying that everything will be lost because users cannot book in more than 1 salon at a time
         */
        
        self.updateCart(true)
    }
}