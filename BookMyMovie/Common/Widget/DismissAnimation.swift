//
//  DismissAnimation.swift
//  BookMyMovie
//
//  Created by Victor on 2019/2/19.
//  Copyright © 2019 Victor. All rights reserved.
//

// Reference: https://www.thorntech.com/2016/02/ios-tutorial-close-modal-dragging/

import UIKit

class DismissAnimation : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        let finalFrame = CGRect(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height),
                                size: UIScreen.main.bounds.size)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {fromVC.view.frame = finalFrame}) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}

class Interactor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}
