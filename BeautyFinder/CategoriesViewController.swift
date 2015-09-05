//
//  CategoriesViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 9/4/15.
//  Copyright (c) 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}


extension CategoriesViewController
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CategoriesCollectionViewCell
        
        cell.title.text      = "whatever222222"
        cell.imageView.image = UIImage(named: "header_3")
        
        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2
        cell.imageView.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind
        {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! CategoriesHeaderCollectionReusableView
            
            switch indexPath.section
            {
            case 0:
                headerView.title.text = "HAIR"
            default:
                headerView.title.text = "MASSAGE"
            }
            
            return headerView
            
        default:
            return UICollectionReusableView()
        }
    }
}