//
//  Instruction.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/17/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

struct Instruction: Identifiable {
    let id = UUID()
    let title: String
    let sections: [Content]
}

protocol Content {
    var id: UUID { get }
    var contentView: AnyView { get }
}

extension Content where Self: View {
    var contentView: AnyView { AnyView(self) }
}
