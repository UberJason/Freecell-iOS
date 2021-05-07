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
    var gameManager: GameStateProvider
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 0) {
                Text(timeString)
                Text("\(moves) \(movesText())")
            }
            .foregroundColor(.white)
            .font(.system(size: 15, weight: .semibold, design: .rounded))
            #if !targetEnvironment(macCatalyst)
            HStack(alignment: .bottom, spacing: 0) {
                Button(action: {
                    self.gameManager.undo()
                }) {
                    VStack {
                        Image.undo
                            .frame(height: 37)
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                        Text("Undo").foregroundColor(.white)
                    }
                    .disabled(gameManager.gameState == .won)
                    .opacity(gameManager.gameState == .won ? 0.5 : 1.0)
                    
                }
                .padding(.all, 4)
                .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .hoverEffect(.automatic)
                
                Button(action: {
                    NotificationCenter.default.post(name: .showMenu, object: nil)
                }) {
                    VStack {
                        Image.settings
                            .frame(height: 37)
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                        Text("Menu").foregroundColor(.white)
                    }
                    
                }
                .padding(.all, 4)
                .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .hoverEffect(.automatic)
            }.font(.system(size: 11, weight: .semibold, design: .rounded))
            #endif
        }
    }
    
    func movesText() -> String {
        return moves == 1 ? "move" : "moves"
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView(timeString: "0:04", moves: 4, gameManager: Game())
            .frame(width: 150, height: 300)
            .background(Color.green)
            .previewLayout(.fixed(width: 150, height: 300))
    }
}
#endif
