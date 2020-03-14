//
//  YouWinView.swift
//  FreecellKit
//
//  Created by Jason Ji on 2/23/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

struct YouWinView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("You Win!").font(.system(size: 50, weight: .bold, design: .rounded))
            Button(action: {
                NotificationCenter.default.post(name: .newGame, object: nil)
            }) {
                Text("New Game")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.freecellBackground)
                    .padding([.top, .bottom], 8.0)
                    .padding([.leading, .trailing], 12.0)
                    .background(
                        RoundedRectangle(cornerRadius: 20.0)
                    )
            }
            
        }
        .foregroundColor(.white)
    }
}

struct YouWinView_Previews: PreviewProvider {
    static var previews: some View {
        YouWinView()
    }
}
