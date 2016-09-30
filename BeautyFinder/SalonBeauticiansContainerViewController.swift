//
//  SalonBeauticiansContainerViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 10/29/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SalonBeauticiansContainerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingView: UIView!
    
    
    var beauticianJson : JSON?
    
    var indexPathForSelectedItem : NSIndexPath?
    
    var salonPK : Int!
    var subcategoryPK : Int!
    var subcategoryName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        startRefresh(9, subcategoryPK: 1, subcategoryName: "")
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
    
    
    func startRefresh(salonPK : Int!, subcategoryPK : Int!, subcategoryName : String!)
    {
        self.beauticianJson = nil
        self.collectionView.reloadData()
        
        UIView.animateWithDuration(0.2) { 
            self.loadingView.alpha = 1
        }
        
        self.salonPK         = salonPK
        self.subcategoryPK   = subcategoryPK
        self.subcategoryName = subcategoryName
        
        
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let requestUrl = k_website + "schedule/\(self.salonPK)/\(self.subcategoryPK)/"
        print(requestUrl)
        
        
        Alamofire.request(.GET, requestUrl).responseJSON { (response) -> Void in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if let Json = response.result.value {
                self.beauticianJson = JSON(Json)
                
                
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
        
        
        UIView.animateWithDuration(0.2) {
            self.loadingView.alpha = 0
        }
    }
}


extension SalonBeauticiansContainerViewController : UICollectionViewDelegateFlowLayout
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let json = beauticianJson else {
            return 0
        }
        
        return json.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CategoriesCollectionViewCell
        
        cell.title.text = self.beauticianJson![indexPath.item, "name"].string!
        cell.imageView.kf_setImageWithURL(NSURL(string: k_website + self.beauticianJson![indexPath.item, "image"].string!)!, placeholderImage: UIImage(named: "Icon-72"))

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
            
            headerView.title.text = self.subcategoryName
            
            return headerView
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        self.indexPathForSelectedItem = indexPath
        
        let beauticianName = self.beauticianJson![indexPath.item, "name"].string!
        let beauticianPK = self.beauticianJson![indexPath.item, "pk"].int!
        let beauticianImageUrl = k_website + self.beauticianJson![indexPath.item, "image"].string!
        
        
        let superView = self.parentViewController as! SalonViewController
        superView.beauticianIsSelectedWithName(beauticianName, beauticianPK: beauticianPK, beauticianImageUrl:  beauticianImageUrl, beauticianJSON: beauticianJson![indexPath.item])
        
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        })
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.view.frame.width > 330 ? CGSizeMake(108, 110) : CGSizeMake(92, 94)
    }
}

extension SalonViewController
{
    func beauticianIsSelectedWithName(beauticianName: String!, beauticianPK : Int!, beauticianImageUrl : String!, beauticianJSON : JSON!)
    {
        self.beauticianName = beauticianName
        self.beauticianPK = beauticianPK
        self.beauticianImageUrl = beauticianImageUrl
        
        self.segmentedControl.selectedIndex = 2;
        
       /* self.logoImageView.hidden = true
        self.salonAddressLabel.hidden = true
        self.salonNameLabel.hidden = true
        */
        
        //self.calendarContainerView.hidden = false
        
        self.scheduleContainerViewController.startRefresh(beauticianJSON)
        self.calendarContainerViewController.startRefresh()
        
        self.calendarContainerViewController.didShowNewMonth = true
        self.calendarContainerViewController.calendarView.toggleCurrentDayView()
        self.calendarContainerViewController.didShowNewMonth = false
        
        self.animateHiding(self.beauticiansContainerView, andShowing: self.scheduleContainerView)
    }
}
