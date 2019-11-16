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
        ZStack(alignment: .top) {
            WindowView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        
            VStack(spacing: 80.0) {
                HStack {
                    HStack {
                        ForEach(board.freecells) { _ in
                            CardRect()
                        }
                    }
                    Spacer()
                    HStack {
                        ForEach(board.foundations) { _ in
                            CardRect()
                        }
                    }
                }
                
                HStack(spacing: 20.0) {
                    ForEach(board.columns) { column in
                        ZStack {
                            ForEach(0..<column.cards.count) { i in
                                CardRect()
                                    .offset(x: 0, y: 30*CGFloat(i))
                            }
                        }
                    }
                }
            }.padding(EdgeInsets(top: 80, leading: 20, bottom: 40, trailing: 20))
            
        }.edgesIgnoringSafeArea(.all)
    }
}

struct WindowView: View {
    var body: some View {
        Spacer().background(Color.green)
    }
}

struct CardRect: View {
    var body: some View {
        Rectangle()
            .frame(width: 125, height: 187)
            .foregroundColor(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 0.25)
        )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
//            .shadow(color: .black, radius: 0.2, x: 0, y: 0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPad Pro 11")
            .previewLayout(.fixed(width: 1194, height: 834))
    }
}
