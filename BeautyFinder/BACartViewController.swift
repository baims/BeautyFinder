//
//  BACartViewController.swift
//  CartForBeautyFinder
//
//  Created by Bader Alrshaid on 5/14/16.
//  Copyright © 2016 Bader Alrshaid. All rights reserved.
//

import UIKit
import PureLayout

protocol BACartDelegate {
    func dismissCartViewController(orders : [BAOrderData]!)
}

class BACartViewController: UIViewController
{
    var totalPrice : Double = 0;
    
    var cartTitle = UILabel()
    var totalLabel = UILabel()
    let bookAndPayButton = UIButton(type: .Custom)
    let bookAndPayLabel = UILabel()
    let continueShoppingButton = UIButton(type: .Custom)
    let continueShoppingLabel = UILabel()
    let buttonsSeparator = UIView()
    
    var orders : [BAOrderData]!
    var scrollView = UIScrollView(frame: CGRectZero)
    
    var orderViews = [BAOrderView]()
    var xButtons   = [UIButton]()
    var orderViewsCenters = [CGPoint]()
    
    let kCellWidth : CGFloat = 180
    var kCellSpacing : CGFloat! = 40
    
    var delegate : BACartDelegate!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clearColor()
        
        
        /*** Blur View ***/
        let blurView = UIVisualEffectView(frame: CGRectZero)
        let blurEffect = UIBlurEffect(style: .Dark)
        blurView.effect = blurEffect
        self.view.addSubview(blurView)

        blurView.autoPinEdgesToSuperviewEdges()
        
        
        /*** Scroll View ***/
        scrollView.delegate = self
        scrollView.delaysContentTouches = false
        scrollView.contentSize = CGSizeMake(max(view.frame.width+1, CGFloat(orders.count+1) * 0.5 * view.frame.width), view.frame.height)
        self.view.addSubview(scrollView)
        
        scrollView.autoPinEdgesToSuperviewEdges()
        
        for i in 0..<orders.count
        {
            let view = BAOrderView(frame: CGRectMake(0, 0, kCellWidth, 290), withOrderData: orders[i])
            
            if i == 0
            {
                view.center = CGPointMake(0.5 * self.view.frame.width, scrollView.contentSize.height/2 - 20)
                orderViewsCenters.append(view.center)
            }
            else
            {
                view.center = CGPointMake(orderViewsCenters.last!.x + kCellWidth + kCellSpacing, orderViewsCenters.last!.y)
                orderViewsCenters.append(view.center)
            }
            
            view.layer.cornerRadius = 20
            view.layer.masksToBounds = true
            scrollView.addSubview(view)
            
            orderViews.append(view)
            
            
            let xButton = UIButton(type: .Custom)
            xButton.frame = CGRectMake(0, 0, 52, 52)
            xButton.setImage(UIImage(named: "xButton"), forState: .Normal)
            xButton.center = CGPointMake(view.frame.origin.x+5, view.frame.origin.y+5)
            xButton.imageEdgeInsets = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
            xButton.addTarget(self, action: #selector(BACartViewController.deleteOrderButtonTapped(_:)), forControlEvents: .TouchUpInside)
            xButton.userInteractionEnabled = true
            scrollView.addSubview(xButton)
            
            xButtons.append(xButton)
            
            // Calculating total
            totalPrice += orders[i].subcategoryPrice
        }
        
        scrollView.contentSize.width = orderViewsCenters.last!.x + self.view.frame.width/2
        
        
        /*** Buttons ***/
        bookAndPayButton.setImage(UIImage(named: "long_btn"), forState: .Normal)
        self.view.addSubview(bookAndPayButton)
        
        bookAndPayButton.autoPinEdgeToSuperviewEdge(.Trailing)
        bookAndPayButton.autoPinEdgeToSuperviewEdge(.Bottom)
        bookAndPayButton.autoSetDimensionsToSize(CGSizeMake(self.view.frame.width/2, 50))
        
        
        bookAndPayLabel.textColor = UIColor.whiteColor()
        bookAndPayLabel.text = "Book & Pay"
        bookAndPayLabel.font = UIFont(name: "MuseoSans-500", size: 16)
        self.view.addSubview(bookAndPayLabel)
        
        bookAndPayLabel.autoAlignAxis(.Vertical, toSameAxisOfView: bookAndPayButton)
        bookAndPayLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: bookAndPayButton)
        
        
        continueShoppingButton.setImage(UIImage(named: "long_btn"), forState: .Normal)
        continueShoppingButton.addTarget(self, action: #selector(self.continueShoppingButtonTapped(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(continueShoppingButton)
        
        continueShoppingButton.autoPinEdgeToSuperviewEdge(.Leading)
        continueShoppingButton.autoPinEdgeToSuperviewEdge(.Bottom)
        continueShoppingButton.autoSetDimensionsToSize(CGSizeMake(self.view.frame.width/2, 50))
        
        
        continueShoppingLabel.textColor = UIColor.whiteColor()
        continueShoppingLabel.text = "Continue Shopping"
        continueShoppingLabel.font = UIFont(name: "MuseoSans-500", size: 16)
        self.view.addSubview(continueShoppingLabel)
        
        continueShoppingLabel.autoAlignAxis(.Vertical, toSameAxisOfView: continueShoppingButton)
        continueShoppingLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: continueShoppingButton)
        
        
        buttonsSeparator.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        self.view.addSubview(buttonsSeparator)
        
        buttonsSeparator.autoSetDimension(.Width, toSize: 1)
        buttonsSeparator.autoMatchDimension(.Height, toDimension: .Height, ofView: continueShoppingButton)
        buttonsSeparator.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: continueShoppingButton)
        buttonsSeparator.autoPinEdge(.Left, toEdge: .Right, ofView: continueShoppingButton)
        
        
        /*** Page Title ***/
        cartTitle.text = "Cart (\(self.orders.count))"
        cartTitle.textColor = UIColor.whiteColor()
        cartTitle.font = UIFont(name: "MuseoSans-500", size: 24)
        self.view.addSubview(cartTitle)
        
        cartTitle.autoAlignAxisToSuperviewAxis(.Vertical)
        cartTitle.autoPinEdgeToSuperviewEdge(.Top, withInset: 30)
        
        /*** Total Label ***/
        totalLabel.text = String(format: "Total: %.3f", arguments: [totalPrice]) + " KD"
        totalLabel.textColor = UIColor.whiteColor()
        totalLabel.font = UIFont(name: "MuseoSans-500", size: 18)
        self.view.addSubview(totalLabel)
        
        totalLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: buttonsSeparator, withOffset: -20)
        totalLabel.autoAlignAxis(.Vertical, toSameAxisOfView: buttonsSeparator)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.view.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    
        let scrollViewCenter = scrollView.center
        scrollView.center.x = self.view.frame.width * 1.5
        
        let cartTitleCenter = cartTitle.center
        cartTitle.center.y = -40
        
        let bookAndPayButtonCenter = bookAndPayButton.center
        bookAndPayButton.center.y = self.view.frame.height+120
        
        let bookAndPayLabelCenter = bookAndPayLabel.center
        bookAndPayLabel.center.y = self.view.frame.height+120
        
        let continueShoppingButtonCenter = continueShoppingButton.center
        continueShoppingButton.center.y = self.view.frame.height+120
        
        let continueShoppingLabelCenter = continueShoppingLabel.center
        continueShoppingLabel.center.y = self.view.frame.height+120
        
        let buttonsSeparatorCenter = buttonsSeparator.center
        buttonsSeparator.center.y = self.view.frame.height+120
        
        let totalLabelCenter = totalLabel.center
        totalLabel.center.y = self.view.frame.height+100
        
        
        UIView.animateWithDuration(0.2, animations: {
            self.view.alpha = 1
            }) { (completed) in
                UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.scrollView.center = scrollViewCenter
                    self.cartTitle.center  = cartTitleCenter
                    self.bookAndPayButton.center = bookAndPayButtonCenter
                    self.bookAndPayLabel.center  = bookAndPayLabelCenter
                    self.continueShoppingLabel.center  = continueShoppingLabelCenter
                    self.continueShoppingButton.center = continueShoppingButtonCenter
                    self.buttonsSeparator.center = buttonsSeparatorCenter
                    self.totalLabel.center = totalLabelCenter
                    }, completion: nil)
        }
    }

    override func didReceiveMemoryWarning()
    {
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
    
    func continueShoppingButtonTapped(sender : UIButton)
    {
        UIView.animateWithDuration(0.2, animations: {
            self.view.alpha = 1
        }) { (completed) in
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.scrollView.center = CGPointMake(self.view.frame.size.width+200, self.scrollView.center.y)
                self.cartTitle.center  = CGPointMake(self.cartTitle.center.x, self.cartTitle.center.x-300)
                self.bookAndPayButton.center = CGPointMake(self.bookAndPayButton.center.x, self.bookAndPayButton.center.y+300)
                self.bookAndPayLabel.center  = CGPointMake(self.bookAndPayLabel.center.x, self.bookAndPayLabel.center.y+300)
                self.continueShoppingLabel.center  = CGPointMake(self.continueShoppingLabel.center.x, self.continueShoppingLabel.center.y+300)
                self.continueShoppingButton.center = CGPointMake(self.continueShoppingButton.center.x, self.continueShoppingButton.center.y+300)
                self.buttonsSeparator.center = CGPointMake(self.buttonsSeparator.center.x, self.buttonsSeparator.center.y+300)
                self.totalLabel.center = CGPointMake(self.totalLabel.center.x, self.totalLabel.center.y+300)
                self.view.alpha = 0
            }) {
                (completed) in
                self.delegate.dismissCartViewController(self.orders)
            }
        }
    }

    func deleteOrderButtonTapped(sender : UIButton)
    {
        scrollView.userInteractionEnabled = false
        
        let currentViewIndex = xButtons.indexOf(sender)!
        print(currentViewIndex)
        
        UIView.animateWithDuration(0.1, animations: {
            sender.transform = CGAffineTransformMakeScale(0.01, 0.01)
            }) { (completed) in
                sender.removeFromSuperview()
        }
        
        UIView.animateWithDuration(0.1, delay: 0.1, options: [], animations: { 
            self.orderViews[currentViewIndex].transform = CGAffineTransformMakeScale(0.01, 0.01)
            }) { (completed) in
                self.orderViews[currentViewIndex].removeFromSuperview()
        }
        
        for i in (currentViewIndex..<orders.count-1).reverse()
        {
            UIView.animateWithDuration(0.2, delay: 0.2, options: [.CurveEaseOut], animations: {
                self.orderViews[i+1].center = self.orderViews[i].center
                self.xButtons[i+1].center   = self.xButtons[i].center
            }) { (completed) in
               
            }
        }
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.updateScrollViewContentSizeAndOrdersAfterAnimation(currentViewIndex)
            })
    }
    
    func updateScrollViewContentSizeAndOrdersAfterAnimation(index : Int)
    {
        print(index)
        self.orderViews.removeAtIndex(index)
        self.xButtons.removeAtIndex(index)
        self.orders.removeAtIndex(index)
        
        scrollView.contentSize = CGSizeMake(max(view.frame.width+1, CGFloat(orders.count+1) * 0.5 * view.frame.width), view.frame.height)
        scrollView.userInteractionEnabled = true
        
        if orders.count != 0
        {
            cartTitle.text = "Cart (\(self.orders.count))"
        }
        else
        {
            // hide this VC and show the salon VC again
        }
    }
}

// MARK: UIScrollViewDelegate
extension BACartViewController : UIScrollViewDelegate
{
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        let kMaxIndex = CGFloat(orders.count)
        let targetX = scrollView.contentOffset.x + velocity.x * 100
        var targetIndex = round(targetX / (kCellWidth + kCellSpacing))
        
        
        if targetIndex < 0
        {
            targetIndex = 0
        }
        
        if targetIndex > kMaxIndex
        {
            targetIndex = kMaxIndex
        }
        
        targetContentOffset.memory.x = targetIndex * (kCellWidth + kCellSpacing)
    }
}
