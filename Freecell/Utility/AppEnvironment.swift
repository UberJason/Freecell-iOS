//
//  AppEnvironment.swift
//  Freecell
//
//  Created by Jason Ji on 4/13/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation

public struct AppEnvironment {
    static var isUITest: Bool {
        return CommandLine.arguments.contains("-uiTesting")
    }
    static var usePreconfiguredBoard: Bool {
        return CommandLine.arguments.contains("-usePreconfiguredBoard")
    }
}
