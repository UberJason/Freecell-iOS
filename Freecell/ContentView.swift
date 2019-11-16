//
//  ContentView.swift
//  Freecell
//
//  Created by Jason Ji on 11/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import FreecellKit

struct ContentView: View {
    let board = Board()
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    ForEach(board.freecells) { _ in
                        Rectangle()
                            .frame(width: 50, height: 100)
                            .background(Color.white)
                    }
                    Spacer()
                    ForEach(board.foundations) { _ in
                        Rectangle()
                            .frame(width: 50, height: 100)
                            .background(Color.white)
                    }
                }
            }
        }
        .background(Color.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPad Pro 11")
            .previewLayout(.fixed(width: 1024, height: 768))
    }
}
