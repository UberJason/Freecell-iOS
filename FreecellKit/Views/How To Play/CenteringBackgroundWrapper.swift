//
//  CenteringBackgroundWrapper.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/17/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

struct CenteringBackgroundWrapper<T: View>: Content {
    let id: UUID = UUID()
    let content: T
    
    var contentView: AnyView {
        AnyView(
            ZStack {
                Rectangle().foregroundColor(.freecellBackground).cornerRadius(8)
                content
            }
        )
    }
}
