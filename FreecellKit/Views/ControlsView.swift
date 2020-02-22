//
//  ControlsView.swift
//  FreecellKit
//
//  Created by Jason Ji on 2/17/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

struct ControlsView: View {
    let timeString: String
    let moves: Int
    @EnvironmentObject var boardDriver: BoardViewDriver
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(alignment: .leading, spacing: 0) {
                Text(timeString)
                Text("\(moves) \(movesText())")
            }.font(.system(size: 15, weight: .semibold))
            HStack(spacing: 8) {
                VStack {
                    Button(action: {
                        self.boardDriver.undo()
                    }) {
                        Image(systemName: "arrow.uturn.left.circle")
                            .font(.system(size: 30))
                    }
                    Text("Undo")
                }
                VStack {
                    Button(action: {
                        print("Settings")
                    }) {
                        Image(systemName: "gear")
                        .font(.system(size: 30))
                    }
                    Text("Menu")
                }
            }.font(.system(size: 11, weight: .semibold))
        }.foregroundColor(.white)
    }
    
    func movesText() -> String {
        return moves == 1 ? "move" : "moves"
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView(timeString: "0:04", moves: 4)
            .frame(width: 150, height: 300)
            .background(Color.green)
            .previewLayout(.fixed(width: 150, height: 300))
    }
}