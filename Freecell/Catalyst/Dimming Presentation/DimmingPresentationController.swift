//
//  DimmingPresentationController.swift
//  Feeding
//
//  Created by Jason Ji on 5/6/18.
//  Copyright © Jason Ji. All rights reserved.
//

import UIKit

public class DimmingPresentationController: UIPresentationController {
    private static let snapshotViewTag = 975
    
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
    
    lazy var gestureRecognizer: UITapGestureRecognizer = {
        var gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(_:)))
        return gestureRecognizer
    }()
    
    public init(params: DimmingPresentationParams, presentedViewController presented: UIViewController, presentingViewController presenting: UIViewController?) {
        self.params = params
        super.init(presentedViewController: presented, presenting: presenting)
        dimmingView.addGestureRecognizer(gestureRecognizer)
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView,
            let presentedView = presentedView else {
                fatalError("No container view for this presentation controller?!")
        }

        let containerWidth = containerView.bounds.size.width
        let containerHeight = containerView.bounds.size.height
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // HACK: There seems to be a bug with systemLayoutSizeFitting(_:) when the superview has NSAutoresizingMaskLayoutConstraints.
        // Or maybe it's something else with UIPresentationController, but I haven't had time to investigate this yet.
        // The outcome of systemLayoutSizeFitting(_:) seems to ignore the width/height of the superview.
        // And UIPresentationController seems to expect the root presentedView to have translatesAutoresizingMaskIntoConstraints to be true:
        // https://stackoverflow.com/a/18655931/1722048
        // So here we add a constraint temporarily, calculate systemLayoutSizeFitting, and then remove it.

        let temporaryWidthConstraint = presentedView.subviews.first?.widthAnchor.constraint(equalToConstant: params.contentWidth)
        temporaryWidthConstraint?.priority = UILayoutPriority(rawValue: 999)
        temporaryWidthConstraint?.isActive = true
        
        let preferredContentSize = presentedView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        let contentWidth = params.contentWidth
        let contentHeight = params.contentHeight ?? preferredContentSize.height
        
        temporaryWidthConstraint?.isActive = false
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        let topY = params.bottomInsetRespectsSafeArea ?
                                        containerHeight - contentHeight - params.bottomInset - containerView.safeAreaInsets.bottom :
                                        containerHeight - contentHeight - params.bottomInset
        
        return CGRect(x: (containerWidth - contentWidth)/2, y: topY, width: contentWidth, height: contentHeight)
    }
    
    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedViewController.view.frame = frameOfPresentedViewInContainerView
    }
    
    public override func presentationTransitionWillBegin() {
        state = .presenting
        let closeButtonSize: CGFloat = 44.0
        let closeButtonVerticalConstraint = (params.bottomInset - closeButtonSize)/2
        
        if let containerView = containerView, let presentedView = presentedView {
            containerView.addSubview(dimmingView)
            containerView.addSubview(presentedView)
            
            dimmingView.frame = containerView.bounds
            dimmingView.alpha = 0.0
            
            let bottomAnchor = params.bottomInsetRespectsSafeArea ? containerView.safeAreaLayoutGuide.bottomAnchor : containerView.bottomAnchor
            
            containerView.layoutIfNeeded()
            
            let transitionCoordinator = presentingViewController.transitionCoordinator
            transitionCoordinator?.animate(alongsideTransition: { (context) in
                self.dimmingView.alpha = self.params.maxDimmedAlpha
                self.params.viewsToHide?.forEach { $0.alpha = 0.0 }
            }, completion: { (context) in
                
            })
        }
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
            self.params.viewsToHide?.forEach { $0.alpha = 1.0 }
        }, completion: { (context) in
            
        })
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
    
    @objc func dimmingViewTapped(_ recognizer: UITapGestureRecognizer) {
//        NotificationCenter.default.post(name: .dimmingViewTapped, object: nil)
    }
    
    @objc func closeButtonTapped(_ sender: UIButton) {
//        NotificationCenter.default.post(name: .closeButtonTapped, object: nil)
    }
    
    // The below two methods are a hack to deal with _UIRemoteViewController being presented
    // without any input from us to set the context as .overFullScreen.
    func presentedViewWillBeRemoved() {
        guard state != .dismissing, state != .dismissed else { return }
        if let snapshotView = containerView?.snapshotView(afterScreenUpdates: false) {
            snapshotView.alpha = 0.0
            snapshotView.tag = DimmingPresentationController.snapshotViewTag
            containerView?.addSubview(snapshotView)
            containerView?.bringSubviewToFront(snapshotView)
            UIView.animate(withDuration: 0.3) {
                snapshotView.alpha = 1.0
            }
        }
    }
    
    func presentedViewWillBeRestored() {
        if let snapshotView = containerView?.viewWithTag(DimmingPresentationController.snapshotViewTag) {
            snapshotView.removeFromSuperview()
        }
    }
}
