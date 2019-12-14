//
//  Column+Sample.swift
//  FreecellKitTests
//
//  Created by Jason Ji on 12/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
@testable import FreecellKit
import DeckKit

extension Column {
    static var sampleStackColumn: Column {
        return Column(id: 0, cards: [
            Card.four.ofSpades,
            Card.seven.ofClubs,
            Card.king.ofClubs,
            Card.eight.ofHearts,
            Card.queen.ofSpades,
            Card.jack.ofHearts,
            Card.ten.ofClubs,
            Card.nine.ofHearts
        ])
    }
}
