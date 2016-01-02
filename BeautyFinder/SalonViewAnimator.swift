//
//  SalonViewAnimator.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 10/16/15.
//  Copyright © 2015 Yousef Alhusaini. All rights reserved.
//

import UIKit
import Kingfisher

class SalonViewAnimator: NSObject, UIViewControllerAnimatedTransitioning
{
    let moveDuration = 0.4
    let fadeDuration = 0.35
    var presenting = true
    var originFrame : CGRect!
    var imageViewPath : String!
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return moveDuration + fadeDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        let containerView = transitionContext.containerView()!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let fromView = presenting ? toView : transitionContext.viewForKey(UITransitionContextFromViewKey)!
        
        
        let whiteView = UIView(frame: containerView.frame)
        whiteView.backgroundColor = UIColor.whiteColor()
        
        containerView.addSubview(whiteView)
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(fromView)

        toView.alpha = 0
        
        /*** The move-animated imageView ***/
        let imageView = UIImageView()
        imageView.kf_setImageWithURL(NSURL(string: imageViewPath)!, placeholderImage: UIImage(named: "Icon-76"))
        imageView.frame = self.originFrame
        imageView.layer.cornerRadius = self.originFrame.width/2
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.clearColor()
        
        let finalCenter = CGPointMake(containerView.frame.width/2, 44 + ( imageView.frame.width/2 )) // final center of the animated imageView
        
        if !presenting
        {
            imageView.frame.size = self.originFrame.size
            imageView.center     = finalCenter
        }
        
        containerView.addSubview(imageView)
    
        
        UIView.animateWithDuration(0.2, delay: 0, options: [], animations:
            {

            fromView.alpha = 0.0
            }, completion: nil)
        
        
        UIView.animateWithDuration(moveDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: [], animations:
            {
                if self.presenting
                {
                    imageView.frame = CGRectMake(containerView.frame.width/2-(86/2), 44, 86, 86)
                }
                else
                {
                    imageView.frame = self.originFrame
                }
                
            }) { (completed) -> Void in
                
        }
        
        
        UIView.animateWithDuration(fadeDuration, delay: 0, options: [], animations:
            {
                toView.alpha = 1.0
                
            }) { (completed) -> Void in                
                imageView.removeFromSuperview()
                whiteView.removeFromSuperview()
                transitionContext.completeTransition(completed)
        }
    }
}
