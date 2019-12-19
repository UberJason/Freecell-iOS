//
//  BoardView.swift
//  Freecell
//
//  Created by Jason Ji on 11/22/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

public struct BoardView: View, StackOffsetting {
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
                            FreeCellView(freeCell: freeCell, selected: self.$boardDriver.selectedCard, hidden: self.$boardDriver.hiddenCard, onTapHandler: self.boardDriver.itemTapped(_:))
                                .frame(width: self.cardSize.width, height: self.cardSize.height)
                                .onTapGesture {
                                    self.boardDriver.itemTapped(freeCell)
                                }
                            .anchorPreference(key: CardLocationInfoKey.self, value: .bounds, transform: { [CardLocationInfo(location: freeCell, type: .freecell, bounds: $0)] })
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        ForEach(boardDriver.foundations) { foundation in
                            FoundationView(foundation: foundation, hidden: self.$boardDriver.hiddenCard)
                                .frame(width: self.cardSize.width, height: self.cardSize.height)
                                .onTapGesture {
                                    self.boardDriver.itemTapped(foundation)
                                }
                                .anchorPreference(key: CardLocationInfoKey.self, value: .bounds, transform: { [CardLocationInfo(location: foundation, type: .foundation, bounds: $0)] })
                        }
                    }
                }
                
                HStack(spacing: 20.0) {
                    ForEach(boardDriver.columns) { column in
                        ColumnView(column: column, selected: self.$boardDriver.selectedCard, hidden: self.$boardDriver.hiddenCard, onTapHandler: self.boardDriver.itemTapped(_:))
                            .frame(width: self.cardSize.width, height: self.cardSize.height)
                            .onTapGesture {
                                self.boardDriver.itemTapped(column)
                            }
                            .anchorPreference(key: CardLocationInfoKey.self, value: .bounds, transform: { [CardLocationInfo(location: column, type: .column, bounds: $0)] })
                    }
                }
            }.padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20))
            
        }
        .edgesIgnoringSafeArea(.all)
        .overlayPreferenceValue(CardLocationInfoKey.self) { preferences in
            return GeometryReader { geometry in
                ZStack {
                    self.renderInFlightCard(using: geometry, cardLocations: preferences)
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .onTapGesture {
            self.boardDriver.itemTapped(self)
        }
    }
    
    func renderInFlightCard(using geometry: GeometryProxy, cardLocations: [CardLocationInfo]) -> some View {
        var bounds = CGRect.zero
        var offset = CGSize.zero

        guard let inFlightMove = boardDriver.inFlightMove else {
            return AnyView(
                CardRectangle().frame(width: bounds.size.width, height: bounds.size.height)
            )
        }
        
        print("renderInFlightCard - \(inFlightMove.card) at \(inFlightMove.location)")
        
        let containingLocation = inFlightMove.location
        if let p = cardLocations.filter({
            $0.location.id == containingLocation.id &&
            type(of: containingLocation) == type(of: $0.location)
        }).first {
            bounds = geometry[p.bounds]
            if p.type == .column, let column = containingLocation as? Column {
                offset = self.offset(for: inFlightMove.card, orderIndex: column.orderIndex(for: inFlightMove.card))
            }
        }

        return AnyView(
            CardView(card: inFlightMove.card)
                .id(inFlightMove.card)
//            .overlay(
//                CardRectangle(foregroundColor: Color.blue, opacity: 0.2)
//            )
            .frame(width: bounds.size.width, height: bounds.size.height)
            .offset(x: bounds.minX, y: bounds.minY + offset.height)
//                .animation(Animation.spring().speed(4.0))
                .animation(.easeOut(duration: Double(self.boardDriver.animationTimeMilliseconds)/1000.0))
        )
    }
    
    #warning("TODO: Dynamically size the cards by platform and figure out why Mac is assuming 1024x768")
    var cardSize: CGSize {
//        return CGSize(width: 125, height: 187)  // iPad Pro
        return CGSize(width: 107, height: 160)  // iPad Mini
    }
}

struct CardLocationInfo {
    let location: CardLocation
    let type: CardLocationType
    let bounds: Anchor<CGRect>
}

struct CardLocationInfoKey: PreferenceKey {
    static var defaultValue: [CardLocationInfo] = []
    
    static func reduce(value: inout [CardLocationInfo], nextValue: () -> [CardLocationInfo]) {
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
