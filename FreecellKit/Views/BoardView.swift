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
    public enum DragState {
        case inactive, active(translation: CGSize)
    }
    
    @ObservedObject var boardDriver: BoardViewDriver
    @Environment(\.undoManager) var undoManager
    
    @GestureState var dragState: DragState = .inactive
    
    public init(boardDriver: BoardViewDriver) {
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
                            FreeCellView(freeCell: freeCell)
                                .frame(width: self.cardSize.width, height: self.cardSize.height)
                                .onTapGesture {
                                    self.boardDriver.itemTapped(freeCell)
                                }
                            .anchorPreference(key: CardLocationInfoKey.self, value: .bounds, transform: { bounds in
                                [CardLocationInfo(location: freeCell, type: .freecell, bounds: bounds)]
                            })
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
                                .anchorPreference(key: CardLocationInfoKey.self, value: .bounds, transform: { bounds in
                                    [CardLocationInfo(location: foundation, type: .foundation, bounds: bounds)]
                                })
                        }
                    }
                }
                
                HStack(spacing: 20.0) {
                    ForEach(boardDriver.columns) { column in
                        ColumnView(column: column)
                            .frame(width: self.cardSize.width, height: self.cardSize.height)
                            .onTapGesture {
                                self.boardDriver.itemTapped(column)
                            }
                            .anchorPreference(key: CardLocationInfoKey.self, value: .bounds, transform: { bounds in
                                [CardLocationInfo(location: column, type: .column, bounds: bounds)]
                            })
                    }
                }
            }.padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20))
            
        }
        .edgesIgnoringSafeArea(.all)
        .overlayPreferenceValue(CardLocationInfoKey.self) { preferences in
            return GeometryReader { geometry in
                ZStack {
                    ForEach(self.boardDriver.allCards) { card in
                        self.renderedCardView(card, using: geometry, cardLocations: preferences)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .onTapGesture {
            self.boardDriver.itemTapped(self)
        }
        .onAppear() {
            self.boardDriver.undoManager = self.undoManager
        }
    }
    
    func renderedCardView(_ card: Card, using geometry: GeometryProxy, cardLocations: [CardLocationInfo]) -> some View {
        var bounds = CGRect.zero
        var stackOffset = CGSize.zero
        
        let containingLocation = boardDriver.location(containing: card)
        if let p = cardLocations.filter({
            $0.location.id == containingLocation.id &&
            type(of: containingLocation) == type(of: $0.location)
        }).first {
            bounds = geometry[p.bounds]
            if p.type == .column, let column = containingLocation as? Column {
                stackOffset = self.stackOffset(for: card, orderIndex: column.orderIndex(for: card))
            }
        }
        
        #warning("Is there a way I can conditionally create this drag gesture and handlers, only in the case where my board driver is a modern board driver?")
        return CardView(card: card)
            .id(card)
            .frame(width: bounds.size.width, height: bounds.size.height)
            .overlay(
                CardRectangle(foregroundColor: boardDriver.cardOverlayColor(for: card), opacity: 0.3)
            )
            .scaleEffect(boardDriver.scale(for: card), anchor: .top)
            .animation(cardSpringAnimation)
            .onTapGesture {
                self.boardDriver.itemTapped(card)
            }
//            .offset(boardDriver.cardOffset(for: card, relativeTo: bounds, stackOffset: offset, dragState: dragState))
            .position(x: bounds.midX, y: bounds.midY + stackOffset.height)
            .animation(cardSpringAnimation)
            .simultaneousGesture(
                createDragGesture(for: card)
            )
    }
    
    func createDragGesture(for card: Card) -> some Gesture {
        let gesture = DragGesture()
            .updating(self.$dragState) { (value, state, _) in
                if case .inactive = state {
                    print("Drag was inactive, detach a stack")
                    self.boardDriver.dragStarted(from: card)
                }
                state = .active(translation: value.translation)
                    
                print("state: \(state)")
            }
            .onEnded { value in
                print("Ended: \(value)")
                self.boardDriver.dragEnded()
            }
        
        return boardDriver is ModernViewDriver ? gesture : nil
    }
   
    #warning("TODO: Dynamically size the cards by platform and figure out why Mac is assuming 1024x768")
    var cardSize: CGSize {
//        return CGSize(width: 125, height: 187)  // iPad Pro
        return CGSize(width: 107, height: 160)  // iPad Mini
    }
    
    var cardSpringAnimation: Animation {
        return Animation.spring(response: 0.08, dampingFraction: 0.95, blendDuration: 0.0)
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(boardDriver: BoardViewDriver())
            .previewDevice("iPad Pro 11")
            .previewLayout(.fixed(width: 1194, height: 834))
    }
}
