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

    
    func presentedDateUpdated(date: CVDate) {
        /*if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .Center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
            updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
            
            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
                self.monthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransformIdentity
                
                }) { _ in
                    
                    self.animationFinished = true
                    self.monthLabel.frame = updatedMonthLabel.frame
                    self.monthLabel.text = updatedMonthLabel.text
                    self.monthLabel.transform = CGAffineTransformIdentity
                    self.monthLabel.alpha = 1
                    updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }*/
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
//        let day = dayView.date.day
//        let randomDay = Int(arc4random_uniform(31))
//        if day == randomDay {
//            return true
//        }
        
        
        
        return false
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        //let day = dayView.date.day
        
        let red = CGFloat(arc4random_uniform(600) / 255)
        let green = CGFloat(arc4random_uniform(600) / 255)
        let blue = CGFloat(arc4random_uniform(600) / 255)
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        let numberOfDots = Int(arc4random_uniform(3) + 1)
        switch(numberOfDots) {
        case 2:
            return [color, color]
        case 3:
            return [color, color, color]
        default:
            return [color] // return 1 dot
        }
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 13
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
    
    func dayLabelPresentWeekdaySelectedBackgroundColor() -> UIColor {
        return UIColor(red: 208.0/255.0, green: 40.0/255.0, blue: 102.0/255.0, alpha: 1)
    }
    
    func dayLabelWeekdaySelectedBackgroundColor() -> UIColor {
        return UIColor(red: 208.0/255.0, green: 40.0/255.0, blue: 102.0/255.0, alpha: 1)
    }
    
    func dayLabelPresentWeekdaySelectedTextColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    func dayLabelPresentWeekdayFont() -> UIFont {
        return UIFont.systemFontOfSize(18)
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
}