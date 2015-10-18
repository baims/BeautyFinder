//
//  SalonBeauticiansViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 10/16/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class SalonBeauticiansViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: ADVSegmentedControl!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var salonNameLabel: UILabel!
    @IBOutlet weak var salonAddressLabel: UILabel!
    
    let refreshControl = UIRefreshControl()
    
    let website = "https://aqueous-dawn-8486.herokuapp.com/"
    var beauticianJson : JSON?
    
    /*** to be sent from the previous view controller ***/
    //var salonJson       : JSON? // will be sent through -prepareForSegue: from previous view controller
    var salonPK          : Int!
    var salonName        : String!
    var salonImagePath   : String!
    var salonAddress     : String!
    var salonLocation    : (longitude: Double!, latitude: Double!)
    var subcategoryPK    : Int! // will be sent through -prepareForSegue: from previous view controller
    var subcategoryName  : String!
    var subcategoryPrice : Double!
    
    var indexPathForSelectedItem : NSIndexPath?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl.items = [" 1. Service", "  2. Beautician ", "   3. Schedule"/*, "4. Book"*/]
        segmentedControl.font = UIFont(name: "MuseoSans-700", size: 14)
        segmentedControl.selectedIndex = 1
        segmentedControl.userInteractionEnabled = false
        segmentedControl.addTarget(self, action: "segmentValueChanged:", forControlEvents: .ValueChanged)
        
        
        self.refreshControl.addTarget(self, action: "startRefresh", forControlEvents: .ValueChanged)
        collectionView?.addSubview(self.refreshControl)
    }
    
    override func viewDidLayoutSubviews() {
        self.logoImageView.kf_setImageWithURL(NSURL(string: self.website + self.salonImagePath)!, placeholderImage: UIImage(named: "Icon-76"))
        self.logoImageView.layer.cornerRadius = logoImageView.frame.width/2
        self.logoImageView.clipsToBounds = true
        
        self.salonNameLabel.text    = self.salonName
        self.salonAddressLabel.text = self.salonAddress
        
        
        self.refreshControl.beginRefreshing()
        self.startRefresh()
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
    
    @IBAction func backButtonPressed(sender: UIButton)
    {
        self.logoImageView.hidden = true
        
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    func startRefresh()
    {
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let requestUrl = "https://aqueous-dawn-8486.herokuapp.com/schedule/\(salonPK)/\(subcategoryPK)/"
        print(requestUrl)
        
        Alamofire.request(.GET, requestUrl).responseJSON { (response) -> Void in
            
            if let Json = response.result.value {
                self.beauticianJson = JSON(Json)
                
                self.refreshControl.endRefreshing()
                
                self.collectionView.reloadData()
                self.refreshControl.removeFromSuperview()
            }
            else if let error = response.result.error
            {
                print(error)
            }
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
}


// CollectionView
extension SalonBeauticiansViewController
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
        //cell.imageView.kf_setImageWithURL(NSURL(string: self.website + self.beauticianJson![indexPath.item, "image"].string!)!, placeholderImage: UIImage(named: "Icon-72"))
        
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
            
            headerView.title.text = self.subcategoryName
            
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