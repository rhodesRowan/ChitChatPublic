
//
//  SlideInTransition.swift
//  chitChat
//
//  Created by Rowan Rhodes on 17/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    //MARK:- Properties
    var isPresenting = false
    let dimmingView = UIView()
    var transition: UIViewControllerContextTransitioning?
    
    //MARK:- Public
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to), let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        let containerView = transitionContext.containerView
        let finalWidth = toViewController.view.bounds.width * 0.8
        let finalHeight = toViewController.view.bounds.height
        self.transition = transitionContext
        if isPresenting {
            self.dimmingView.backgroundColor = .black
            self.dimmingView.alpha = 0.0
            containerView.addSubview(dimmingView)
            self.dimmingView.frame = containerView.bounds
            // add menu view controller to container
            containerView.addSubview(toViewController.view)
            
            // init frame off the screen
            toViewController.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHeight)
        }
        
        let transform = {
            self.dimmingView.alpha = 0.5
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
        }
        // animate back off screen
        let identity = {
            self.dimmingView.alpha = 0.5
            fromViewController.view.transform = .identity
        }
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? transform() : identity()
        }) { (_) in
            transitionContext.completeTransition(!isCancelled)
        }
    }
}
