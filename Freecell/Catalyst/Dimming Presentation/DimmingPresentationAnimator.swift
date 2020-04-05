//
//  DimmingPresentationAnimator.swift
//  Feeding
//
//  Created by Jason Ji on 5/6/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import UIKit

public enum TransitionType {
    case present, push, dismiss, pop
    
    init?(operation: UINavigationController.Operation) {
        switch operation {
        case .push: self = .push
        case .pop: self = .pop
        default: return nil
        }
    }
}

public class DimmingPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let params: DimmingPresentationParams
    let transitionType: TransitionType
    
    public init(params: DimmingPresentationParams, transitionType: TransitionType) {
        self.params = params
        self.transitionType = transitionType
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return params.duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionType {
        case .present:
            animatePresentation(using: transitionContext)
        case .dismiss:
            animateDismissal(using: transitionContext)
        case .push:
            break
        case .pop:
            break
        }
    }
    
    func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            fatalError("Couldn't get view controllers for this transition")
        }
        
        containerView.addSubview(toViewController.view)
        toViewController.view.layer.cornerRadius = params.presentedCornerRadius
        toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
        toViewController.view.transform = CGAffineTransform(translationX: 0, y: containerView.bounds.size.height)
        
        UIView.animate(withDuration: params.duration, animations: {
            toViewController.view.transform = .identity
            toViewController.setNeedsStatusBarAppearanceUpdate()
            
        }, completion: { (finished) in
            transitionContext.completeTransition(finished)
        })
    }
    
    func animateDismissal(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            fatalError("Couldn't get view controllers for this transition")
        }
        
        UIView.animate(withDuration: params.duration, animations: {
            fromViewController.view.transform = CGAffineTransform(translationX: 0, y: containerView.bounds.size.height)
        
        }, completion: { (finished) in
            transitionContext.completeTransition(finished)
        })
    }
}
