//
//  BackgroundColorView.swift
//  FreecellKit
//
//  Created by Jason Ji on 12/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI

struct BackgroundColorView: View {
    let color: Color
    
    init(color: Color = Color.freecellBackground) {
        self.color = color
    }
    
    var body: some View {
        Spacer().background(color)
    }
}
