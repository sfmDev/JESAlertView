//
//  JESAlertViewAnimation.swift
//  Demo
//
//  Created by JerryShi on 8/3/16.
//  Copyright © 2016 jerryshi. All rights reserved.
//

import UIKit

class JESAlertViewAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        if (isPresenting) {
            return 0.45
        } else {
            return 0.25
        }
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if (isPresenting) {
            self.presentAnimateTransition(transitionContext)
        } else {
            self.dismissAnimateTransition(transitionContext)
        }
    }
    
    func presentAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let alertController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! JESAlertView
        let containerView = transitionContext.containerView()
        
        alertController.overlayView.alpha = 0.0
        if (alertController.isAlert()) {
            alertController.alertView.alpha = 0.0
            alertController.alertView.center = alertController.view.center
            alertController.alertView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        } else {
            alertController.alertView.transform = CGAffineTransformMakeTranslation(0, alertController.alertView.frame.height)
        }
        containerView!.addSubview(alertController.view)
        
        UIView.animateWithDuration(0.25, animations: {
            alertController.overlayView.alpha = 1.0
            if (alertController.isAlert()) {
                alertController.alertView.alpha = 1.0
                alertController.alertView.transform = CGAffineTransformMakeScale(1.05, 1.05)
            } else {
                let bounce = alertController.alertView.frame.height / 480 * 10.0 + 10.0
                alertController.alertView.transform = CGAffineTransformMakeTranslation(0, -bounce)
            }
        }) { finished in
            UIView.animateWithDuration(0.2, animations: {
                alertController.alertView.transform = CGAffineTransformIdentity
                }, completion: { finished in
                    if (finished) {
                        transitionContext.completeTransition(true)
                    }
            })
        }
    }
    
    func dismissAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let alertController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! JESAlertView
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
            alertController.overlayView.alpha = 0.0
            if (alertController.isAlert()) {
                alertController.alertView.alpha = 0.0
                alertController.alertView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            } else {
                alertController.containerView.transform = CGAffineTransformMakeTranslation(0, alertController.alertView.frame.height)
            }
            }, completion: { finished in
                transitionContext.completeTransition(true)
        })
    }
}
