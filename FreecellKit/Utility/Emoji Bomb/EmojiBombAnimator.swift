//
//  EmojiBombAnimator.swift
//  GiftgramKit
//
//  Created by Ji,Jason on 11/17/17.
//  Copyright © 2017 Capital One Labs. All rights reserved.
//

import UIKit

public struct EmojiBombAnimationParameters {
    public var baseline: CGFloat
    public var variation: CGFloat
    public var density: CGFloat
    public var maximumMagnitude: CGFloat
    public var forceOffset: CGFloat
    public var gravity: CGFloat
    public var numberOfViews: Int
    
    
    public init(baseline: CGFloat = 0.5, variation: CGFloat = 0.1, density: CGFloat = 1.0, maximumMagnitude: CGFloat = 1.0, forceOffset: CGFloat = 0.1, gravity: CGFloat = 1.0, numberOfViews: Int = 200) {
        self.baseline = baseline
        self.variation = variation
        self.density = density
        self.maximumMagnitude = maximumMagnitude
        self.gravity = gravity
        self.numberOfViews = numberOfViews
        self.forceOffset = forceOffset
    }
}

public class EmojiBombAnimator {
    let container: UIView
    
    let animator: UIDynamicAnimator
    var gravityBehavior: UIGravityBehavior?
    var collisionBehavior: UICollisionBehavior?
    
    public var animationParameters: EmojiBombAnimationParameters
    
    var labels = [UILabel]()
    
    public init(container: UIView, animationParameters params: EmojiBombAnimationParameters = EmojiBombAnimationParameters()) {
        self.container = container
        self.animationParameters = params
        
        animator = UIDynamicAnimator(referenceView: container)
    }
    
    public func startAnimation() {
        print("==============================")
        print("Baseline: \(animationParameters.baseline)")
        print("Variation: \(animationParameters.variation)")
        print("Density: \(animationParameters.density)")
        print("Max Magnitude: \(animationParameters.maximumMagnitude)")
        print("Force offset: \(animationParameters.forceOffset)")
        print("Gravity: \(animationParameters.gravity)")
        print("Number of Views: \(animationParameters.numberOfViews)")
        print("==============================")
        
        reset()
        
        let monkey = "🐵"
        var pushBehaviors = [UIPushBehavior]()
        
        for _ in 0 ..< animationParameters.numberOfViews {
            let label = createEmojiLabel(emoji: monkey)
            labels.append(label)
            container.addSubview(label)
            
            let initialVerticalRange = container.frame.height * animationParameters.variation
            let initialVerticalBaseline = container.frame.height * animationParameters.baseline
            let forceOffsetRange = label.frame.width * animationParameters.forceOffset + 1
            
            let xPos = arc4random_uniform(UInt32(container.frame.width))
            let yPos = Int(arc4random_uniform(UInt32(initialVerticalRange))) - Int(initialVerticalRange/2)
            label.center = CGPoint(x: Int(xPos), y: Int(initialVerticalBaseline) + yPos)
            
            let xDirection = CGFloat(arc4random())/0xFFFFFFFF - 0.5
            let forceOffset = arc4random_uniform(UInt32(forceOffsetRange))
            let pushBehavior = UIPushBehavior(items: [label], mode: .instantaneous)
            pushBehavior.pushDirection = CGVector(dx: xDirection, dy: -1.0)
            pushBehavior.magnitude = CGFloat(arc4random())/0xFFFFFFFF * animationParameters.maximumMagnitude
            pushBehavior.setTargetOffsetFromCenter(UIOffset(horizontal: CGFloat(forceOffset), vertical: 0), for: label)
            
            pushBehaviors.append(pushBehavior)
        }
        
        gravityBehavior = UIGravityBehavior(items: labels)
        gravityBehavior?.magnitude = animationParameters.gravity
        collisionBehavior = UICollisionBehavior(items: labels)
        collisionBehavior?.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: -1*container.frame.height, left: -1*container.frame.width, bottom: container.frame.height, right: container.frame.width))
        collisionBehavior?.collisionMode = .boundaries
        
        
        let densityBehavior = UIDynamicItemBehavior(items: labels)
        densityBehavior.density = animationParameters.density
        
        animator.addBehavior(gravityBehavior!)
        animator.addBehavior(collisionBehavior!)
        animator.addBehavior(densityBehavior)
        pushBehaviors.forEach { animator.addBehavior($0) }
    }
    
    func reset() {
        labels.forEach { $0.removeFromSuperview() }
        labels = []
        animator.removeAllBehaviors()
    }
    
    func createEmojiLabel(emoji: String) -> UILabel {
        let label = UILabel(frame: .zero)
        
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.text = emoji
        label.sizeToFit()
        
        return label
    }
}
