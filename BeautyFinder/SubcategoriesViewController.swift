//
//  SubcategoriesViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 10/2/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit
import Alamofire

class SubcategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var primaryKey : Int!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let refreshControl = UIRefreshControl()
    
    let website = "https://aqueous-dawn-8486.herokuapp.com/"
    var searchIsHidden = true
    var json : JSON?
    var indexPathForSelectedItem : NSIndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.refreshControl.addTarget(self, action: "startRefresh", forControlEvents: .ValueChanged)
        collectionView?.addSubview(self.refreshControl)
        
        self.refreshControl.beginRefreshing()
        self.startRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        if let indexPath = indexPathForSelectedItem
        {
            self.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "Salon"
        {
            let vc = segue.destinationViewController as! SalonServicesViewController
            vc.json = self.json![indexPathForSelectedItem!.item]
        }
    }

    
    func startRefresh()
    {
        Alamofire.request(.GET, "https://aqueous-dawn-8486.herokuapp.com/subcategory/\(self.primaryKey)", parameters:nil).responseJSON { (response) -> Void in
            
            if let Json = response.result.value
            {
                self.json = JSON(Json)
                
                self.refreshControl.endRefreshing()
                
                self.collectionView.reloadData()
                self.refreshControl.removeFromSuperview()
            }
        }
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
        
        cell.title.text = json![indexPath.item, "name"].string!;
        cell.imageView.kf_setImageWithURL(NSURL(string: self.website + self.json![indexPath.item, "logo"].string!)!, placeholderImage: UIImage(named: "Icon-72"))
        
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
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        self.indexPathForSelectedItem = indexPath
        
        
        return true
    }
}