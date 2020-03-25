//
//  ControlStyle.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/15/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation

public enum ControlStyle: String, CaseIterable {
    case modern = "Modern", classic = "Classic"
    
    static var `default`: ControlStyle {
        #if os(iOS)
        return .modern
        #else
        return .classic
        #endif
    }
}
