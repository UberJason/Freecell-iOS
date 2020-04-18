//
//  Image.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/17/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

struct ImageContent: View, Content {
    let id = UUID()
    let image: Image
    
    var body: some View {
        image.resizable().aspectRatio(contentMode: .fit)
    }
}
