//
//  AreaSearchViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 9/18/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit
import Alamofire

class AreaSearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var searchJson : JSON?
    
    var indexPathForSelectedItem : NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(text : String)
    {
        guard !text.isEmpty else
        {
            //Alamofire.Manager.sharedInstance.session.invalidateAndCancel()
            
            searchJson = nil
            
            collectionView.reloadData()
            
            return
        }
        
        //Alamofire.Manager.sharedInstance.session.invalidateAndCancel()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Alamofire.request(.GET, k_website + "area/\(text)").responseJSON { (response) -> Void in
            
            if let Json = response.result.value {
                self.searchJson = JSON(Json)

                self.collectionView.reloadData()
            }
            else if let error = response.result.error
            {
                print(error)
            }
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
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
}

// MARK: CollectionView
extension AreaSearchViewController : UICollectionViewDelegateFlowLayout
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        guard let json = searchJson else
        {
            return 0
        }
        
        return json.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let json = searchJson else
        {
            return 0
        }
        
        return json[section, "salons"].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CategoriesCollectionViewCell
        
        cell.title.text = searchJson![indexPath.section, "salons", indexPath.item, "name"].string!;
        cell.imageView.kf_setImageWithURL(NSURL(string: k_website + searchJson![indexPath.section, "salons", indexPath.item, "logo"].string!)!, placeholderImage: UIImage(named: "Icon-72"))
        
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
            
            headerView.title.text = searchJson![indexPath.section, "name"].string!
            
            return headerView
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        indexPathForSelectedItem = indexPath
        
        let parentViewController = self.parentViewController as! SearchViewController
        parentViewController.salonIsChosenWithJson(searchJson![indexPath.section, "salons", indexPath.item])
        
        return true
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.view.frame.width > 320 ? CGSizeMake(108, 110) : CGSizeMake(92, 94)
    }
}

extension SearchViewController
{
    func salonIsChosenWithJson(json : JSON)
    {
        self.salonJson = json
        performSegueWithIdentifier("Salon", sender: nil)
    }
}