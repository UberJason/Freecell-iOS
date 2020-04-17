//
//  Paragraph.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/17/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

struct Paragraph: View, Content {
    let id = UUID()
    let content: String
    
    var body: some View {
        Text(content)
    }
}
