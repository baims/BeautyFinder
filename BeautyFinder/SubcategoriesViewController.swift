//
//  SubcategoriesViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 10/2/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit
import Alamofire

class SubcategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout {
    
    var primaryKey : Int!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let refreshControl = UIRefreshControl()
    
    var searchIsHidden = true
    var json : JSON?
    var indexPathForSelectedItem : NSIndexPath?
    var titleString : String!
    
    var animator = SalonViewAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl.addTarget(self, action: "startRefresh", forControlEvents: .ValueChanged)
        collectionView?.addSubview(self.refreshControl)
        
        self.refreshControl.beginRefreshing()
        self.startRefresh()
        
        self.titleLabel.text = self.titleString
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
        
        self.navigationController?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
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
        Alamofire.request(.GET, k_website + "subcategory/\(self.primaryKey)", parameters:nil).responseJSON { (response) -> Void in
            
            if let Json = response.result.value
            {
                self.json = JSON(Json)
                
                self.refreshControl.endRefreshing()
                
                self.collectionView.reloadData()
                self.refreshControl.removeFromSuperview()
            }
            else if let error = response.result.error
            {
                print(error)
            }
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
        
        
        cell.title.text = json![indexPath.item, "name"].string!;
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
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        self.indexPathForSelectedItem = indexPath
        
        
        return true
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.view.frame.width > 320 ? CGSizeMake(108, 110) : CGSizeMake(92, 94)
    }
}