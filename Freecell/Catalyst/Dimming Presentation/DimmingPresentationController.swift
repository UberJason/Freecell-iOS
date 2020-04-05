//
//  DimmingPresentationController.swift
//  Feeding
//
//  Created by Jason Ji on 5/6/18.
//  Copyright © Jason Ji. All rights reserved.
//

import UIKit

public class DimmingPresentationController: UIPresentationController {
    enum PresentationState {
        case presenting, presented, dismissing, dismissed
    }
    
    let params: DimmingPresentationParams
    var state = PresentationState.presenting
    
    let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.isUserInteractionEnabled = true
        return view
    }()

    public init(params: DimmingPresentationParams, presentedViewController presented: UIViewController, presentingViewController presenting: UIViewController?) {
        self.params = params
        super.init(presentedViewController: presented, presenting: presenting)
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            fatalError("No container view for this presentation controller?!")
        }

        let containerWidth = containerView.bounds.size.width
        let contentWidth = params.contentWidth
        let contentHeight = params.contentHeight ?? preferredContentSize.height
      
        return CGRect(x: (containerWidth - contentWidth)/2, y: 40 + containerView.safeAreaInsets.top, width: contentWidth, height: contentHeight)
    }
    
    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedViewController.view.frame = frameOfPresentedViewInContainerView
    }
    
    public override func presentationTransitionWillBegin() {
        state = .presenting

        guard let containerView = containerView, let presentedView = presentedView else { return }
        containerView.addSubviewFullFrame(dimmingView)
        containerView.addSubview(presentedView)
        
        dimmingView.alpha = 0.0
        
        containerView.layoutIfNeeded()
        
        let transitionCoordinator = presentingViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { (context) in
            self.dimmingView.alpha = self.params.maxDimmedAlpha
        }, completion: { _ in })
        
    }
    
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        state = .presented
        
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    public override func dismissalTransitionWillBegin() {
        state = .dismissing
        
        let transitionCoordinator = presentingViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { (context) in
            self.dimmingView.alpha = 0.0
        }, completion: { _ in })
    }
    
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        state = .dismissed
        
        if completed {
            dimmingView.removeFromSuperview()
        }
        else {
            dimmingView.alpha = params.maxDimmedAlpha
        }
    }
    
    public override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        
        if state == .presented {
            self.presentedView?.frame = self.frameOfPresentedViewInContainerView
        }
    }
}
