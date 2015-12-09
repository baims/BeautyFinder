//
//  SearchViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 9/18/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var segmentedControl: ADVSegmentedControl!
    @IBOutlet weak var areaSearchContainerView: UIView!
    @IBOutlet weak var salonSearchContainerView: UIView!
    @IBOutlet weak var categorySearchContainerView: UIView!
    
    let searchField    = SearchTextField(frame: CGRectZero)
    
    var salonSearchViewController : SalonSearchViewController!
    var areaSearchViewController : AreaSearchViewController!
    var categorySearchViewController : CategorySearchViewController!
    
    var salonJson : JSON?
    
    var animator = SalonViewAnimator()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        segmentedControl.items = ["Salon", "Area", "Category"]
        segmentedControl.font = UIFont(name: "MuseoSans-700", size: 14)
        segmentedControl.addTarget(self, action: "segmentValueChanged:", forControlEvents: .ValueChanged)
        segmentedControl.selectedIndex = 0
        
        
        searchField.becomeFirstResponder()
        searchField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        let navBarFrame = self.navigationController?.navigationBar.frame
        
        self.searchField.frame.size = CGSizeMake(navBarFrame!.size.width-40, 30)
        self.searchField.center     = CGPointMake(navBarFrame!.width/2, navBarFrame!.height/2)
        self.searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        self.searchField.delegate   = self
        
        self.navigationController?.navigationBar.addSubview(self.searchField)
        
        self.navigationController?.navigationBar.hidden = false
        
        
        if let indexPath = areaSearchViewController.indexPathForSelectedItem
        {
            areaSearchViewController.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        }
        else if let indexPath = salonSearchViewController.indexPathForSelectedItem
        {
            salonSearchViewController.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        }
        else if let indexPath = categorySearchViewController.indexPathForSelectedItem
        {
            categorySearchViewController.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        }
        
        self.navigationController?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        self.searchField.removeFromSuperview()
        
        self.navigationController?.navigationBar.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "salonSearch"
        {
            salonSearchViewController = segue.destinationViewController as! SalonSearchViewController
        }
        else if segue.identifier == "areaSearch"
        {
            areaSearchViewController = segue.destinationViewController as! AreaSearchViewController
        }
        else if segue.identifier == "categorySearch"
        {
            categorySearchViewController = segue.destinationViewController as! CategorySearchViewController
        }
        else if segue.identifier == "Salon"
        {
            self.navigationController?.delegate = self
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
            
            let vc = segue.destinationViewController as! SalonViewController
            vc.salonJson = salonJson!
        }
        else if segue.identifier == "Category"
        {
            let dic = sender as! [String : AnyObject]
            let vc = segue.destinationViewController as! SubcategoriesViewController
            
            vc.primaryKey = dic["pk"] as! Int
            vc.titleString = dic["title"] as! String
        }
    }
}


// MARK: Search Field Delegate (UITextFieldDelegate)
extension SearchViewController
{
    func textFieldDidBeginEditing(textField: UITextField)
    {
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidChange(textField : UITextField)
    {
        if segmentedControl.selectedIndex == 0
        {
            self.salonSearchViewController.refresh(searchField.text!)
        }
        else if segmentedControl.selectedIndex == 1
        {
            self.areaSearchViewController.refresh(searchField.text!)
        }
        else if segmentedControl.selectedIndex == 2
        {
            self.categorySearchViewController.refresh(searchField.text!)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.searchField.resignFirstResponder()
    }
}


// MARK: SegmentedControl
extension SearchViewController
{
    func segmentValueChanged(sender: AnyObject?){
        
        if segmentedControl.selectedIndex == 0
        {
            self.salonSearchContainerView.hidden = false
            self.areaSearchContainerView.hidden  = true
            self.categorySearchContainerView.hidden = true
        }
        else if segmentedControl.selectedIndex == 1
        {
            self.salonSearchContainerView.hidden = true
            self.areaSearchContainerView.hidden  = false
            self.categorySearchContainerView.hidden = true
            
            self.areaSearchViewController.refresh(searchField.text!)
        }
        else if segmentedControl.selectedIndex == 2
        {
            self.salonSearchContainerView.hidden = true
            self.areaSearchContainerView.hidden  = true
            self.categorySearchContainerView.hidden = false
            
            self.categorySearchViewController.refresh(searchField.text!)
        }
        else
        {
            
        }
    }
}

extension SearchViewController : UINavigationControllerDelegate
{
    /** animator : SubcategoriesAnimator is defined in SubcategoriesViewController.swift **/
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if operation == .Push
        {
            animator.presenting = true
            
            if segmentedControl.selectedIndex == 0 // salon search
            {
                let cell = salonSearchViewController.collectionView.cellForItemAtIndexPath(salonSearchViewController.indexPathForSelectedItem!) as! CategoriesCollectionViewCell
                animator.originFrame = cell.imageView.superview?.superview?.convertRect(cell.imageView.frame, toView: nil)
                animator.imageViewPath = k_website + salonSearchViewController.searchJson![salonSearchViewController.indexPathForSelectedItem!.item, "logo"].string!
            }
            else if segmentedControl.selectedIndex == 1 // area search
            {
                let cell = areaSearchViewController.collectionView.cellForItemAtIndexPath(areaSearchViewController.indexPathForSelectedItem!) as! CategoriesCollectionViewCell
                animator.originFrame = cell.imageView.superview?.superview?.convertRect(cell.imageView.frame, toView: nil)
                animator.imageViewPath = k_website + areaSearchViewController.searchJson![areaSearchViewController.indexPathForSelectedItem!.section, "salons", areaSearchViewController.indexPathForSelectedItem!.item, "logo"].string!
            }
        }
        else if operation == .Pop
        {
            animator.presenting = false
        }
        
        
        return animator
    }
    
    // to get "swipe back" gesture working
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
}