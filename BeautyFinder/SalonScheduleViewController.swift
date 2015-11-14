//
//  SalonScheduleViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 11/6/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit
import CVCalendar

class SalonScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var json : JSON?
    var indexPathForSelectedRow : NSIndexPath!
    
    var selectedDate : CVDate!
    var jsonOfSelectedDate : JSON?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        let dayOfWeek = self.getDayOfWeek(stringOfDate)!
        
        self.dateLabel.text = dayOfWeek + "   \(selectedDate.day)/\(selectedDate.month)/\(selectedDate.year)"
        
        
        
        self.jsonOfSelectedDate = nil
        
        for schedule in self.json!["schedule"].array! where schedule["date"].string! == stringOfDate
        {
            self.jsonOfSelectedDate = schedule
            
            print(self.jsonOfSelectedDate)
        }

        self.tableView.reloadData()
    }
    
    
    func convertTimeToString(time : String) -> String
    {
        let timeString : String
        
        var hour : String = time[time.startIndex.advancedBy(0) ... time.startIndex.advancedBy(1)]
        let minute : String = time[time.startIndex.advancedBy(3) ... time.startIndex.advancedBy(4)]
        
        
        if (Int(hour) >= 12)
        {
            hour = String( Int(hour)! - 12 )
            
            timeString = hour + ":" + minute + "pm"
        }
        else
        {
            hour = String(Int(hour)!)
            
            timeString = hour + ":" + minute + "am"
        }

        
        return timeString
    }
    
    
    func getDayOfWeek(today:String)-> String?
    {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let todayDate = formatter.dateFromString(today)
        {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
            let weekDay = myComponents.weekday
            
            switch weekDay
            {
            case 1:
                return "Sunday"
            case 2 :
                return "Monday"
            case 3:
                return "Tuesday"
            case 4 :
                return "Wednesday"
            case 5:
                return "Thursday"
            case 6 :
                return "Friday"
            case 7:
                return "Saturday"
            default:
                return "OUT OF INDEX!"
            }
        }
        else
        {
            return nil
        }
    }
}


extension SalonScheduleViewController
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let Json = jsonOfSelectedDate else
        {
            return 0
        }
        
        return Json["time"].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SalonScheduleTableViewCell
        
        
        cell.startTimeLabel.text = self.convertTimeToString(self.jsonOfSelectedDate!["time", indexPath.row, "start"].string!)
        cell.endTimeLabel.text   = self.convertTimeToString(self.jsonOfSelectedDate!["time", indexPath.row, "end"].string!)
        
        
        if self.jsonOfSelectedDate!["time", indexPath.row, "is_busy"].bool!
        {
            cell.selectionStyle = .None // to disable highlighting when the user uses
        }
        else
        {
            cell.selectionStyle = .Gray
        }
        
        
        let accessoryView = UIImageView(image: UIImage(named: "arrow"))
        cell.accessoryView = accessoryView
        
        let selectedBackgroundView = UIView(frame: cell.frame)
        selectedBackgroundView.backgroundColor = UIColor(red: 50.0/255, green: 50.0/255, blue: 50.0/255, alpha: 0.2)
        //selectedBackgroundView.alpha = 0.2
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.indexPathForSelectedRow = indexPath
        
        let date      = "\(selectedDate.year)/\(selectedDate.month)/\(selectedDate.day)"
        let startTime = self.jsonOfSelectedDate!["time", self.indexPathForSelectedRow.row, "start"].string!
        let endTime = self.jsonOfSelectedDate!["time", self.indexPathForSelectedRow.row, "end"].string!
        
        let parentViewController = self.parentViewController as! SalonViewController
        parentViewController.scheduleIsSelectedWithDate(date, startTime: startTime, endTime: endTime)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?
    {
        if self.jsonOfSelectedDate!["time", indexPath.row, "is_busy"].bool!
        {
            return nil
        }
        else
        {
            return indexPath
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
        
        self.performSegueWithIdentifier("summarySegue", sender: nil)
    }
}