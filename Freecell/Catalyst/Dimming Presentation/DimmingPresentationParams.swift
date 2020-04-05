//
//  DimmingPresentationParams.swift
//  Feeding
//
//  Created by Ji,Jason on 9/29/17.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import UIKit

public struct DimmingPresentationParams {
    public let duration: TimeInterval
    public let animationScale: CGFloat
    public let maxDimmedAlpha: CGFloat
    public let presentedCornerRadius: CGFloat
    public var contentWidth: CGFloat
    public var contentHeight: CGFloat?

    public init(duration: TimeInterval = 0.4, animationScale: CGFloat = 0.7, maxDimmedAlpha: CGFloat = 0.5, presentedCornerRadius: CGFloat = 12.0, contentWidth: CGFloat, contentHeight: CGFloat? = nil) {
        self.duration = duration
        self.animationScale = animationScale
        self.maxDimmedAlpha = maxDimmedAlpha
        self.presentedCornerRadius = presentedCornerRadius
        self.contentWidth = contentWidth
        self.contentHeight = contentHeight
    }
}
