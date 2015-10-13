//
//  CategoriesViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 9/4/15.
//  Copyright (c) 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit
import Alamofire
//import SwiftyJSON

class CategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let refreshControl = UIRefreshControl()
    
    let website = "https://aqueous-dawn-8486.herokuapp.com/"
    var searchIsHidden = true
    var json : JSON?
    
    var indexPathForSelectedItem : NSIndexPath!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.refreshControl.addTarget(self, action: "startRefresh", forControlEvents: .ValueChanged)
        collectionView?.addSubview(self.refreshControl)
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        self.refreshControl.beginRefreshing()
        self.startRefresh()
        
        //self.collectionView.setContentOffset(CGPointMake(0, -self.refreshControl.frame.height), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Category"
        {
            let vc = segue.destinationViewController as! SubcategoriesViewController
            vc.primaryKey = self.json![self.indexPathForSelectedItem.section, "subcategories", self.indexPathForSelectedItem.item, "pk"].int!
            vc.title      = self.json![self.indexPathForSelectedItem.section, "name"].string! + " " + self.json![self.indexPathForSelectedItem.section, "subcategories", self.indexPathForSelectedItem.item, "name"].string!
            
        }
    }

    
    
    func startRefresh()
    {
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.GET, "https://aqueous-dawn-8486.herokuapp.com/homepage/").responseJSON { (response) -> Void in
            
            if let Json = response.result.value {
                self.json = JSON(Json)
                
                self.refreshControl.endRefreshing()
                
                self.collectionView.reloadData()
                self.refreshControl.removeFromSuperview()
            }
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
}


// MARK: Categories CollectionView
extension CategoriesViewController
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        guard let json = json else {
            return 0
        }
        
        return json.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let json = json else {
            return 0
        }
        return json[section, "subcategories"].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CategoriesCollectionViewCell
        
        cell.title.text = self.json![indexPath.section, "subcategories", indexPath.item, "name"].string!
        cell.imageView.imageFromUrl(self.website + self.json![indexPath.section, "subcategories", indexPath.item, "image"].string!)
        
        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2
        cell.imageView.layer.masksToBounds = true
        
        let selectedView = UIView()
        let circledView  = UIView(frame: cell.imageView.frame)
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
            
            headerView.title.text = self.json![indexPath.section, "name"].string?.uppercaseString
            
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
}