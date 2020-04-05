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
    public let maxDimmedAlpha: CGFloat
    public let presentedCornerRadius: CGFloat
    public var contentWidth: CGFloat
    public var contentHeight: CGFloat?
    public let bottomInset: CGFloat
    public var viewsToHide: [UIView]?
    public var bottomInsetRespectsSafeArea: Bool

    public init(duration: TimeInterval = 0.4, maxDimmedAlpha: CGFloat = 0.5, presentedCornerRadius: CGFloat = 12.0, contentWidth: CGFloat, contentHeight: CGFloat? = nil, bottomInset: CGFloat = 0.0, viewsToHide: [UIView] = [], bottomInsetRespectsSafeArea: Bool = true) {
        self.duration = duration
        self.maxDimmedAlpha = maxDimmedAlpha
        self.presentedCornerRadius = presentedCornerRadius
        self.contentWidth = contentWidth
        self.contentHeight = contentHeight
        self.bottomInset = bottomInset
        self.viewsToHide = viewsToHide
        self.bottomInsetRespectsSafeArea = bottomInsetRespectsSafeArea
    }
}
