//
//  Instruction.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/17/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

public struct Instruction: Identifiable {
    public let id = UUID()
    public let title: String
    public let sections: [Content]
    
    init(title: String, sections: [Content]) {
        self.title = title
        self.sections = sections
    }
}

public protocol Content {
    var id: UUID { get }
    var contentView: AnyView { get }
}

public extension Content where Self: View {
    var contentView: AnyView { AnyView(self) }
}
