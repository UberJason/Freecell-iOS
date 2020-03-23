//
//  BoardProvider.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/15/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation

protocol BoardProvider: AnyObject, StackOffsetting {
    var board: Board { get }
    func registerMove()
    func rollbackFailedMove(with error: Error)
    func performUpdate()
}
