//
//  BoardView.swift
//  Freecell
//
//  Created by Jason Ji on 11/22/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

public struct BoardView: View {
    @ObservedObject var boardDriver: BoardDriver
    
    public init(boardDriver: BoardDriver) {
        self.boardDriver = boardDriver
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            BackgroundColorView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        
            VStack(spacing: 60.0) {
                HStack {
                    HStack {
                        ForEach(boardDriver.freecells) { freeCell in
                            FreeCellView(freeCell: freeCell, selected: self.$boardDriver.selectedCard, onTapHandler: self.boardDriver.itemTapped(_:))
                                .frame(width: self.cardSize.width, height: self.cardSize.height)
                                .onTapGesture {
                                    self.boardDriver.itemTapped(freeCell)
                                }
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        ForEach(boardDriver.foundations) { foundation in
                            FoundationView(foundation: foundation)
                                .frame(width: self.cardSize.width, height: self.cardSize.height)
                                .onTapGesture {
                                    self.boardDriver.itemTapped(foundation)
                                }
                        }
                    }
                }
                
                HStack(spacing: 20.0) {
                    ForEach(boardDriver.columns) { column in
                        ColumnView(column: column, selected: self.$boardDriver.selectedCard, onTapHandler: self.boardDriver.itemTapped(_:))
                            .frame(width: self.cardSize.width, height: self.cardSize.height)
                            .onTapGesture {
                                self.boardDriver.itemTapped(column)
                            }
                    }
                }
            }.padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20))
            
        }
        .edgesIgnoringSafeArea(.all)
        .overlayPreferenceValue(CardFrameInfoKey.self) { preferences in
            return GeometryReader { geometry in
                ZStack {
                    self.createBorder(using: geometry, preferences: preferences)
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .onTapGesture {
            self.boardDriver.itemTapped(self)
        }
    }
    
    func createBorder(using geometry: GeometryProxy, preferences: [CardFrameInfo]) -> some View {
        var bounds = CGRect.zero
        var offset = CGSize.zero
        /************************************/
        for p in preferences {
            print("\(p.card.displayTitle):")
            print("Bounds: \(geometry[p.bounds])")
            print("Offset: \(p.offset)")
        }
       /************************************/
        if let p = preferences.last {
            bounds = geometry[p.bounds]
            offset = p.offset
        }
        return CardRectangle(foregroundColor: .blue, opacity: 0.2)
            .frame(width: bounds.size.width, height: bounds.size.height)
            .offset(x: bounds.minX, y: bounds.minY + offset.height)
            .animation(.easeInOut(duration: 1.0))
    }
    
    #warning("TODO: Dynamically size the cards by platform and figure out why Mac is assuming 1024x768")
    var cardSize: CGSize {
//        return CGSize(width: 125, height: 187)  // iPad Pro
        return CGSize(width: 107, height: 160)  // iPad Mini
    }
}

struct CardFrameInfo {
    let card: Card
    let offset: CGSize
    let bounds: Anchor<CGRect>
}

struct CardFrameInfoKey: PreferenceKey {
    static var defaultValue: [CardFrameInfo] = []
    
    static func reduce(value: inout [CardFrameInfo], nextValue: () -> [CardFrameInfo]) {
        value.append(contentsOf: nextValue())
    }
}


struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(boardDriver: BoardDriver())
            .previewDevice("iPad Pro 11")
            .previewLayout(.fixed(width: 1194, height: 834))
    }
}
