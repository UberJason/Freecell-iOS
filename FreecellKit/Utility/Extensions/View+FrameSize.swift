//
//  View+FrameSize.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/17/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

extension View {
    func frame(size: CGSize, alignment: Alignment = .center) -> some View {
        return frame(width: size.width, height: size.height, alignment: alignment)
    }
}
