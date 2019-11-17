//
//  EmptySpotView.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/17/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI

struct EmptySpotView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 125, height: 187) // w x h = 1 x 1.5
                .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 0.5)
            )
                .clipShape(RoundedRectangle(cornerRadius: 8))

            
            Text("!")
                .font(.system(size: 30, weight: .semibold, design: .default))
          
        }
    }
}

struct EmptySpotView_Previews: PreviewProvider {
    static var previews: some View {
        EmptySpotView()
            .previewLayout(.fixed(width: 200, height: 262))
    }
}
