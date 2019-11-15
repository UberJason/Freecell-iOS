//
//  FreecellError.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/14/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation

enum FreecellError: Error {
    case cellOccupied
    case invalidSuitForFoundation
    case invalidRankForFoundation
}
