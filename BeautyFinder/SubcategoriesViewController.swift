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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func startRefresh()
    {
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        print(self.primaryKey)
        Alamofire.request(.GET, "https://aqueous-dawn-8486.herokuapp.com/subcategory/1", parameters:nil).responseJSON { (response) -> Void in
            
            if let Json = response.result.value {
                self.json = JSON(Json)
                
                print(self.json)
                
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
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CategoriesCollectionViewCell
        
        return cell
    }
}