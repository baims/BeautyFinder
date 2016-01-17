//
//  CategorySearchViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 12/8/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit

class CategorySearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var indexPathForSelectedItem : NSIndexPath?
    
    var searchJson : JSON?
    var searchText : String?
    
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
        searchText = text
        
        var array = [JSON]()
        
        guard text.isEmpty == false else
        {
            searchJson = nil
            
            collectionView.reloadData()
            
            return
        }
        
        
        if let json = categoriesJson
        {
            for category in json.array!
            {
                if category["name"].string!.lowercaseString.rangeOfString(text.lowercaseString) != nil
                {
                    array.append(category)
                }
                else
                {
                    for subcategory in category["subcategories"].array! where subcategory["name"].string!.lowercaseString.rangeOfString(text.lowercaseString) != nil
                    {
                        array.append(category)
                        break
                    }
                }
            }
        }
        
        searchJson = JSON(array)
        print(searchJson)
        
        collectionView.reloadData()
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

extension CategorySearchViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        guard let json = searchJson else {
            return 0
        }
        
        return json.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let json = searchJson else {
            return 0
        }
        return json[section, "subcategories"].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CategoriesCollectionViewCell

        
        cell.title.text = searchJson![indexPath.section, "subcategories", indexPath.item, "name"].string!
        cell.imageView.kf_setImageWithURL(NSURL(string: k_website + searchJson![indexPath.section, "subcategories", indexPath.item, "image"].string!)!, placeholderImage: UIImage(named: "Icon-72"))
        
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
            
            headerView.title.text = searchJson![indexPath.section, "name"].string?.uppercaseString
            
            return headerView
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        self.indexPathForSelectedItem = indexPath
        
        let primaryKey = categoriesJson![self.indexPathForSelectedItem!.section, "subcategories", self.indexPathForSelectedItem!.item, "pk"].int!
        
        
        /*** Getting category/subcategory names from self.json and capitlize the first letter of each word ***/
        var categoryName = searchJson![self.indexPathForSelectedItem!.section, "name"].string!
        categoryName = categoryName.lowercaseString
        categoryName.replaceRange(categoryName.startIndex ... categoryName.startIndex, with: String(categoryName[categoryName.startIndex]).capitalizedString)
        
        var subcategoryName = searchJson![self.indexPathForSelectedItem!.section, "subcategories", self.indexPathForSelectedItem!.item, "name"].string!
        subcategoryName = subcategoryName.lowercaseString
        subcategoryName.replaceRange(subcategoryName.startIndex ... subcategoryName.startIndex, with: String(subcategoryName[subcategoryName.startIndex]).capitalizedString)
        
        let titleString      = categoryName + " " + subcategoryName
        
        
        let parentViewController = self.parentViewController as! SearchViewController
        parentViewController.categoryIsChosenWithPrimaryKey(primaryKey, title: titleString)
        
        return true
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        print(self.collectionView.frame.width)
        return self.view.frame.width > 320 ? CGSizeMake(108, 110) : CGSizeMake(92, 94)
    }
}


extension SearchViewController
{
    func categoryIsChosenWithPrimaryKey(pk : Int, title : String)
    {        
        self.performSegueWithIdentifier("Category", sender: ["pk" : pk, "title" : title])
    }
}