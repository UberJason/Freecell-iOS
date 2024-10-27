//
//  Card+Id.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/25/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

extension Card: @retroactive Identifiable {
    public var id: String { return displayTitle }
}
