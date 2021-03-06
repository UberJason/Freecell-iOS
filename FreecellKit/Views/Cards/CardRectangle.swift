//
//  CardRectangle.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/22/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI

struct CardRectangle: View {
    let foregroundColor: Color
    let cornerRadius: CGFloat
    let opacity: Double
    
    init(foregroundColor: Color = .cardBackground, cornerRadius: CGFloat = 8.0, opacity: Double = 1.0) {
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.opacity = opacity
    }
    
    var body: some View {
        Rectangle()
            .foregroundColor(foregroundColor)
            .opacity(opacity)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

struct CardRectangle_Previews: PreviewProvider {
    static var previews: some View {
        CardRectangle()
            .frame(width: 125, height: 187)
            .frame(width: 200, height: 300)
            .background(Color.green)
            .previewLayout(.fixed(width: 200, height: 300))
    }
}
    
