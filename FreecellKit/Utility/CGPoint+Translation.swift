//
//  CGPoint+Translation.swift
//  FreecellKit
//
//  Created by Jason Ji on 1/29/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import CoreGraphics

public extension CGPoint {
    func position(byAdding translation: CGSize) -> CGPoint {
        return CGPoint(x: x + translation.width, y: y + translation.height)
    }
    
    func distance(from otherPoint: CGPoint) -> CGFloat {
        let xDistance = x - otherPoint.x, yDistance = y - otherPoint.y
        
        return sqrt(xDistance*xDistance + yDistance*yDistance)
    }
}
