//
//  ControlsView.swift
//  FreecellKit
//
//  Created by Jason Ji on 2/17/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

#if !os(macOS)
struct ControlsView: View {
    let timeString: String
    let moves: Int
    var boardDriver: BoardViewDriver
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(alignment: .leading, spacing: 0) {
                Text(timeString)
                Text("\(moves) \(movesText())")
            }
            .foregroundColor(.white)
            .font(.system(size: 15, weight: .semibold, design: .rounded))
            HStack(spacing: 8) {
                VStack {
                    Button(action: {
                        self.boardDriver.undo()
                    }) {
                        Image.undo
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                    }
                    
                    .disabled(boardDriver.gameState == .won)
                    .opacity(boardDriver.gameState == .won ? 0.5 : 1.0)
                    Text("Undo").foregroundColor(.white)
                }
                VStack {
                    Button(action: {
                        print("Settings")
                        NotificationCenter.default.post(name: .showMenu, object: nil)
                    }) {
                        Image.settings
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                    }
                    Text("Menu").foregroundColor(.white)
                }
            }.font(.system(size: 11, weight: .semibold, design: .rounded))
        }
    }
    
    func movesText() -> String {
        return moves == 1 ? "move" : "moves"
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView(timeString: "0:04", moves: 4, boardDriver: BoardViewDriver(controlStyle: .modern))
            .frame(width: 150, height: 300)
            .background(Color.green)
            .previewLayout(.fixed(width: 150, height: 300))
    }
}
#endif