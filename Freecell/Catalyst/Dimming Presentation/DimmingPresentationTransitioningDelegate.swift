//
//  DimmingPresentationTransitioningDelegate.swift
//  Feeding
//
//  Created by Jason Ji on 5/6/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import UIKit
public class DimmingPresentationTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    public let params: DimmingPresentationParams
    
    public init(params: DimmingPresentationParams) {
        self.params = params
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DimmingPresentationAnimator(params: params, transitionType: .present)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DimmingPresentationAnimator(params: params, transitionType: .dismiss)
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(params: params, presentedViewController: presented, presentingViewController: presenting)
    }
}
