//
//  CategoriesViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 9/4/15.
//  Copyright (c) 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON
import Datez

class CategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var centerYConstraintOfLoadingView: NSLayoutConstraint!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var infoArrowImageView: UIImageView!
    
    //let refreshControl = UIRefreshControl()
    
    var searchIsHidden = true
    //var json : JSON?
    
    var viewIsLoaded = false
    
    var indexPathForSelectedItem : NSIndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        ////////////////////////////////////
//        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        
//        let date = NSDate()
//        
//        let notification = UILocalNotification()
//        notification.fireDate = date + 10.seconds.timeInterval
//        notification.alertBody = "You have an appointment tomorrow with Mairy in Bader Salon at 8:00 PM)"
//        notification.userInfo = ["salonName" : "Bader Salon",
//                                 "salonAddress" : "Mishref block 5 whatever",
//                                 "salonImageUrl" : "http://beautyfinders.com/media/salon/image.jpeg",
//                                 "subcategoryName" : "Hair Wash",
//                                 "subcategoryPrice" : 20.0,
//                                 "beauticianName" : "Mairy",
//                                 "beauticianImageUrl" : "http://beautyfinders.com/media/Beautician/img1456063529780_1_icsrXSC.jpg",
//                                 "dateOfBooking" : "2-7-2016",
//                                 "startTime" : "18:00:00",
//                                 "endTime" : "18:30:00",
//                                 "startFromPrice" : true,
//                                 "lat" : 10.743322,
//                                 "long" : 23.9887433]
//        
//        UIApplication.sharedApplication().scheduleLocalNotification(notification)
//        
//        print("notification fire date is: \(notification.fireDate!)")
//        
//        ///////////////////////////////////////
        
        headerImageView.contentMode = .ScaleAspectFill
        headerImageView.layer.masksToBounds = true
    }
    
    override func viewDidLayoutSubviews()
    {
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        if !viewIsLoaded
        {
            viewIsLoaded = true
            
            UIView.animateWithDuration(0.6, delay: 0, options: [.Repeat, .CurveEaseInOut, .Autoreverse], animations: {
                // TODO: scale it bigger and smaller
                }, completion: { (completed) in
                    
            })
            
            print("viewDidLayoutSubviews")
            
            self.startRefresh()
        }
        
        //self.collectionView.setContentOffset(CGPointMake(0, -self.refreshControl.frame.height), animated: true)
    }

    override func viewWillAppear(animated: Bool) {
        if let indexPath = self.indexPathForSelectedItem
        {
            self.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        }
        
        self.navigationController?.navigationBar.hidden = true
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "Category"
        {
            let vc = segue.destinationViewController as! SubcategoriesViewController
            vc.primaryKey = categoriesJson![self.indexPathForSelectedItem!.section, "subcategories", self.indexPathForSelectedItem!.item, "pk"].int!
            
            
            /*** Getting category/subcategory names from self.json and capitlize the first letter of each word ***/
            var categoryName = categoriesJson![self.indexPathForSelectedItem!.section, "name"].string!
            categoryName = categoryName.lowercaseString
            categoryName.replaceRange(categoryName.startIndex ... categoryName.startIndex, with: String(categoryName[categoryName.startIndex]).capitalizedString)
            
            var subcategoryName = categoriesJson![self.indexPathForSelectedItem!.section, "subcategories", self.indexPathForSelectedItem!.item, "name"].string!
            subcategoryName = subcategoryName.lowercaseString
            subcategoryName.replaceRange(subcategoryName.startIndex ... subcategoryName.startIndex, with: String(subcategoryName[subcategoryName.startIndex]).capitalizedString)
            
            vc.titleString = categoryName + " " + subcategoryName
        }
    }

    
    
    func startRefresh()
    {
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Alamofire.request(.GET, k_website + "homepage/").responseJSON { (response) -> Void in
            
            if let Json = response.result.value {
                categoriesJson = JSON(Json)
                
                print(categoriesJson)
                
                
                self.hideLoadingView()
                
                self.collectionView.reloadData()
            }
            else if let error = response.result.error
            {
                print(error)
            }
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    func hideLoadingView()
    {
        print("animating now ....")
        
        self.collectionView.alpha = 0
        
        UIView.animateWithDuration(0.3) {
            self.centerYConstraintOfLoadingView.constant -= 50
            self.view.layoutIfNeeded()
            self.loadingView.alpha = 0
            
            self.collectionView.alpha = 1
            self.collectionView.center.y -= 50
        }
    }
}


// MARK: Categories CollectionView
extension CategoriesViewController
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        guard let json = categoriesJson else {
            return 0
        }
        
        return json.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let json = categoriesJson else {
            return 0
        }
        return json[section, "subcategories"].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CategoriesCollectionViewCell
        
        cell.title.text = categoriesJson![indexPath.section, "subcategories", indexPath.item, "name"].string!
        cell.title.fadeLength = 4
        cell.title.scrollRate = 30
        
        
        cell.imageView.kf_setImageWithURL(NSURL(string: k_website + categoriesJson![indexPath.section, "subcategories", indexPath.item, "image"].string!)!, placeholderImage: UIImage(named: "Icon-72"))
        
        cell.imageView.layer.cornerRadius = (cell.frame.size.width-22)/2
        cell.imageView.layer.masksToBounds = true
        cell.imageView.layer.borderWidth = 0.5
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.1).CGColor
        
        let selectedView = UIView()
        let circledView  = UIView(frame: CGRectZero)
        circledView.frame.size = CGSizeMake(cell.frame.size.width-22, cell.frame.size.width-22)
        circledView.center.x = cell.frame.width/2
        circledView.frame.origin.y = 0
        circledView.backgroundColor     = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        circledView.layer.cornerRadius  = cell.imageView.layer.cornerRadius
        circledView.layer.masksToBounds = true
        
        selectedView.addSubview(circledView)
        
        cell.selectedBackgroundView = selectedView
        cell.bringSubviewToFront(cell.selectedBackgroundView!)
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        switch kind
        {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! CategoriesHeaderCollectionReusableView
            
            headerView.title.text = categoriesJson![indexPath.section, "name"].string?.uppercaseString
            
            return headerView
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        self.indexPathForSelectedItem = indexPath
        
        
        return true
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.view.frame.width > 320 ? CGSizeMake(108, 110) : CGSizeMake(92, 94)
    }
}
