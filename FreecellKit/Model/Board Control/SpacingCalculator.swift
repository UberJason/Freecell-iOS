//
//  SpacingCalculator.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/24/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

#if os(iOS)
import UIKit

struct SpacingCalculator {
    // verticalOffset = padding + cardHeight + spacing = 40 + 145 + 50 = 235
    func stackRequiresCompression(_ numberOfCards: Int, cardHeight: CGFloat) -> Bool {
        let height = self.height(forStackCount: numberOfCards, cardHeight: cardHeight, spacing: SpacingConstants.defaultSpacing)
        let availableVerticalSpace = self.availableVerticalSpace()
        
        return height > availableVerticalSpace
    }
    
    func availableVerticalSpace(in bounds: CGRect = UIScreen.main.bounds, offsetBy verticalOffset: CGFloat = SpacingConstants.verticalOffset, bottomPadding: CGFloat = SpacingConstants.bottomPadding) -> CGFloat {
        return bounds.height - verticalOffset - bottomPadding
    }

    func height(forStackCount numberOfCards: Int, cardHeight: CGFloat, spacing: CGFloat) -> CGFloat {
        return cardHeight + CGFloat(numberOfCards - 1)*spacing
    }

    func spacingThatFits(_ availableVerticalSpace: CGFloat, cardHeight: CGFloat, numberOfCards: Int) -> CGFloat {
        return (availableVerticalSpace - cardHeight) / CGFloat(numberOfCards - 1)
    }
}
#endif

struct SpacingConstants {
    static let defaultSpacing: CGFloat = 40
    static let verticalOffset: CGFloat = 235
    static let bottomPadding: CGFloat = -40
}
