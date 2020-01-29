//
//  CGRect+Center.swift
//  FreecellKit
//
//  Created by Jason Ji on 1/28/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation

public extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
