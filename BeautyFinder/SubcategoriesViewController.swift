//
//  SubcategoriesViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 10/2/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SubcategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout {
    
    var primaryKey : Int!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var centerYConstraintOfLoadingView: NSLayoutConstraint!
    
    
    var searchIsHidden = true
    var json : JSON?
    var indexPathForSelectedItem : NSIndexPath?
    var titleString : String!
    
    var animator = SalonViewAnimator()
    
    var viewIsLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.act = UIRefreshControl()
//        //self.refreshControl.addTarget(self, action: #selector(SubcategoriesViewController.startRefresh), forControlEvents: .ValueChanged)
//        //self.refreshControl.tintColor = UIColor.greenColor()
//        //collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
//        //collectionView.alwaysBounceVertical = true
//        
//        self.view.addSubview(self.refreshControl)
//        
//        self.refreshControl.autoCenterInSuperview()
//        
//        self.refreshControl.beginRefreshing()
        
        
        
        
        self.titleLabel.text = self.titleString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        if let indexPath = indexPathForSelectedItem
        {
            self.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        }
        
        // removing the segue animations ( if it was set by showing the SalonViewController in -prepareForSegue(segue:,sender:)
        self.navigationController?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        // showing tabBar ( if it was hidden from the SalonViewController )
        self.tabBarController!.tabBar.hidden = false
        
        
        print("viewWillAppear")
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        if !viewIsLoaded
        {
            viewIsLoaded = true
            
            print("viewDidLayoutSubviews")
            
            self.startRefresh()
        }
        
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "Salon"
        {
            self.navigationController?.delegate = self
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
            
            let vc = segue.destinationViewController as! SalonViewController
            vc.salonJson = self.json![indexPathForSelectedItem!.item]
        }
    }

    
    func startRefresh()
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Alamofire.request(.GET, k_website + "subcategory/\(self.primaryKey)", parameters:nil).responseJSON { (response) -> Void in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if let Json = response.result.value
            {
                self.json = JSON(Json)
                
                print(self.json)
                
                self.hideLoadingView()
                
                self.collectionView.reloadData()
            }
            else if let error = response.result.error
            {
                print(error)
            }
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
    
    
    @IBAction func backButtonPressed(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension SubcategoriesViewController
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let json = json else {
            return 0
        }
        
        return json.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CategoriesCollectionViewCell
        
        
        cell.title.text = json![indexPath.item, "name"].string!
        cell.title.fadeLength = 4
        cell.title.scrollRate = 30
        
        
        
        cell.imageView.kf_setImageWithURL(NSURL(string: k_website + self.json![indexPath.item, "logo"].string!)!, placeholderImage: UIImage(named: "Icon-72"))
        
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

    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        //(cell as! CategoriesCollectionViewCell).title.restartLabel()
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
