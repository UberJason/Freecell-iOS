//
//  Result+SuccessVoid.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/23/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation

extension Result where Success == Void {
    static var success: Result {
        return .success(())
    }
}
