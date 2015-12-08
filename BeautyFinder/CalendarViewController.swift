//
//  CalendarViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 11/6/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var superOfBlurView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    
    var didShowNewMonth = false
    
    var selectedDate : CVDate = CVDate(date: NSDate())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        calendarView.commitCalendarViewUpdate()
        calendarMenuView.commitMenuViewUpdate()
        
        superOfBlurView.layer.cornerRadius = 15
        superOfBlurView.clipsToBounds = true
        
        monthLabel.text = selectedDate.globalDescription
    }
    
    func startRefresh()
    {
        for weekV in calendarView.contentController.presentedMonthView.weekViews {
            for dayView in weekV.dayViews {
                dayView.setupDotMarker()
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func outerViewTapped(sender: UITapGestureRecognizer)
    {
        let parentViewController = self.parentViewController as! SalonViewController
        parentViewController.showCalendarViewController()
    }
}


// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension CalendarViewController : CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    // MARK: Optional methods
    
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }


    func didSelectDayView(dayView: DayView) {
        print(dayView.weekdayIndex)

        self.selectedDate = dayView.date
        self.monthLabel.text = self.selectedDate.globalDescription
        
        // refreshing the dot markers when a new month is selected
        startRefresh()
        
        
        
        let parentViewController = self.parentViewController as! SalonViewController
        parentViewController.newDateIsSelected(self.selectedDate)
        
        if didShowNewMonth
        {
            didShowNewMonth = false
        }
        else
        {
            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                parentViewController.showCalendarViewController()
            })
        }
    }

    
    
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool
    {
        if let parentViewController = self.parentViewController as? SalonViewController
        {
            if parentViewController.checkIfDateIsAvailable(dayView.date) == true
            {
                return true
            }
            else
            {
                return false
            }
        }
        else
        {
            return false
        }
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        if let parentViewController = self.parentViewController as? SalonViewController
        {
            if parentViewController.checkIfAvailableBookingExistInDate(dayView.date) == true
            {
                return [UIColor(red: 0, green: 175.0/255.0, blue: 0, alpha: 1.0)]
            }
            else
            {
                return [UIColor(red: 1.0, green: 0, blue: 52.0/255.0, alpha: 1.0)]
            }
        }
        else
        {
            return [UIColor.redColor()]
        }
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 14
    }
    
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .Short
    }
}

// MARK: - CVCalendarViewDelegate
/*
extension ViewController: CVCalendarViewDelegate {
func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
circleView.fillColor = .colorFromCode(0xCCCCCC)
return circleView
}

func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
if (dayView.isCurrentDay) {
return true
}
return false
}

func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
let π = M_PI

let ringSpacing: CGFloat = 3.0
let ringInsetWidth: CGFloat = 1.0
let ringVerticalOffset: CGFloat = 1.0
var ringLayer: CAShapeLayer!
let ringLineWidth: CGFloat = 4.0
let ringLineColour: UIColor = .blueColor()

let newView = UIView(frame: dayView.bounds)

let diameter: CGFloat = (newView.bounds.width) - ringSpacing
let radius: CGFloat = diameter / 2.0

let rect = CGRectMake(newView.frame.midX-radius, newView.frame.midY-radius-ringVerticalOffset, diameter, diameter)

ringLayer = CAShapeLayer()
newView.layer.addSublayer(ringLayer)

ringLayer.fillColor = nil
ringLayer.lineWidth = ringLineWidth
ringLayer.strokeColor = ringLineColour.CGColor

let ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
let ringRect: CGRect = CGRectInset(rect, ringLineWidthInset, ringLineWidthInset)
let centrePoint: CGPoint = CGPointMake(ringRect.midX, ringRect.midY)
let startAngle: CGFloat = CGFloat(-π/2.0)
let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)

ringLayer.path = ringPath.CGPath
ringLayer.frame = newView.layer.bounds

return newView
}

func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
if (Int(arc4random_uniform(3)) == 1) {
return true
}

return false
}
}
*/

// MARK: - CVCalendarViewAppearanceDelegate

extension CalendarViewController : CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
    
    
    
    func dayLabelWeekdayInTextColor() -> UIColor {
        return UIColor(red: 208.0/255.0, green: 40.0/255.0, blue: 102.0/255.0, alpha: 1)
    }
    
    func dayLabelWeekdaySelectedTextColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    func dayLabelWeekdaySelectedBackgroundColor() -> UIColor {
        return UIColor(red: 208.0/255.0, green: 40.0/255.0, blue: 102.0/255.0, alpha: 1)
    }
    
    
    
    func dayLabelPresentWeekdaySelectedBackgroundColor() -> UIColor {
        return UIColor(red: 208.0/255.0, green: 40.0/255.0, blue: 102.0/255.0, alpha: 1)
    }
    
    func dayLabelPresentWeekdaySelectedTextColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    func dayLabelPresentWeekdayTextColor() -> UIColor
    {
        return UIColor(red: 208.0/255.0, green: 40.0/255.0, blue: 102.0/255.0, alpha: 1)
    }
    
    func dayLabelPresentWeekdayFont() -> UIFont {
        return UIFont.systemFontOfSize(19)
    }
    
    
    
    
    func spaceBetweenWeekViews() -> CGFloat {
        return -1
    }
}

// MARK: - IB Actions

extension CalendarViewController
{
    @IBAction func switchChanged(sender: UISwitch)
    {
        if sender.on
        {
            calendarView.changeDaysOutShowingState(false)
            //shouldShowDaysOut = true
        }
        else
        {
            calendarView.changeDaysOutShowingState(true)
            //shouldShowDaysOut = false
        }
    }
    
    @IBAction func todayMonthView()
    {
        calendarView.toggleCurrentDayView()
    }
    
    /// Switch to WeekView mode.
    @IBAction func toWeekView(sender: AnyObject) {
        calendarView.changeMode(.WeekView)
    }
    
    /// Switch to MonthView mode.
    @IBAction func toMonthView(sender: AnyObject) {
        calendarView.changeMode(.MonthView)
    }
    
    @IBAction func loadPrevious(sender: AnyObject) {
        calendarView.loadPreviousView()
    }
    
    @IBAction func loadNext(sender: AnyObject) {
        calendarView.loadNextView()
    }
}

// MARK: - Convenience API Demo

extension CalendarViewController
{
    func toggleMonthViewWithMonthOffset(offset: Int)
    {
        let calendar = NSCalendar.currentCalendar()
        //let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(NSDate()) // from today
        
        components.month += offset
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
    
    func didShowNextMonthView(date: NSDate)
    {
        //let calendar = NSCalendar.currentCalendar()
        // let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
        print("Showing Month: \(components.month)")
        
        didShowNewMonth = true
    }
    
    
    func didShowPreviousMonthView(date: NSDate)
    {
        //let calendar = NSCalendar.currentCalendar()
        //let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
        print("Showing Month: \(components.month)")
        
        didShowNewMonth = true
    }
}


extension SalonViewController
{
    func getSelectedDateFromCVCalender() -> CVDate
    {
        return self.calendarContainerViewController.selectedDate
    }
    
    func newDateIsSelected(date : CVDate!)
    {
        self.scheduleContainerViewController.startRefresh(date)
    }
    
    func checkIfAvailableBookingExistInDate(date: CVDate!) -> Bool
    {
        return self.scheduleContainerViewController.availableBookingExistInDate(date)
    }
    
    func checkIfDateIsAvailable(date: CVDate!) -> Bool
    {
        return self.scheduleContainerViewController.isDateAvailable(date)
    }
}