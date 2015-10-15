//
//  SearchViewController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 9/18/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var segmentedControl: ADVSegmentedControl!
    @IBOutlet weak var areaSearchContainerView: UIView!
    @IBOutlet weak var salonSearchContainerView: UIView!
    
    let searchField    = SearchTextField(frame: CGRectZero)

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        segmentedControl.items = ["Salon", "Area", "Category"]
        segmentedControl.font = UIFont(name: "MuseoSans-700", size: 14)
        segmentedControl.selectedIndex = 0
        segmentedControl.addTarget(self, action: "segmentValueChanged:", forControlEvents: .ValueChanged)
        
        
        searchField.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        let navBarFrame = self.navigationController?.navigationBar.frame
        
        self.searchField.frame.size = CGSizeMake(navBarFrame!.size.width-40, 30)
        self.searchField.center     = CGPointMake(navBarFrame!.width/2, navBarFrame!.height/2)
        self.searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        self.searchField.delegate   = self
        
        self.navigationController?.navigationBar.addSubview(self.searchField)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        self.searchField.removeFromSuperview()
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
        }
        else if segmentedControl.selectedIndex == 1
        {
            
        }
        else if segmentedControl.selectedIndex == 2
        {
            self.salonSearchContainerView.hidden = true
            self.areaSearchContainerView.hidden  = false
        }
        else
        {
            
        }
    }
}