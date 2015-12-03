//
//  SubcategoriesAnimationController.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 10/16/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit

extension SubcategoriesViewController : UINavigationControllerDelegate
{
    /** animator : SubcategoriesAnimator is defined in SubcategoriesViewController.swift **/
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        guard toVC != navigationController.viewControllers[0] else
        {
            return nil
        }
        
        
        if operation == .Push
        {
            animator.presenting = true
            
            let cell = collectionView.cellForItemAtIndexPath(self.indexPathForSelectedItem!) as! CategoriesCollectionViewCell
            animator.originFrame = cell.imageView.superview?.superview?.convertRect(cell.imageView.frame, toView: nil)
            animator.imageViewPath = k_website + self.json![indexPathForSelectedItem!.item, "logo"].string!
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


