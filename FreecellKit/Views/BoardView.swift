//
//  BoardView.swift
//  Freecell
//
//  Created by Jason Ji on 11/22/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

extension HorizontalAlignment {
    private enum MyLeadingAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.center]
        }
    }
    private enum MyTrailingAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.center]
        }
    }
    
    static let myLeadingAlignment = HorizontalAlignment(MyLeadingAlignment.self)
    static let myTrailingAlignment = HorizontalAlignment(MyTrailingAlignment.self)
}

public struct BoardView: View, StackOffsetting {
    public enum DragState {
        case inactive, active(translation: CGSize)
    }
    
    @ObservedObject var boardDriver: BoardViewDriver
    @GestureState var dragState: DragState = .inactive
    
    public init(boardDriver: BoardViewDriver) {
        self.boardDriver = boardDriver
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            BackgroundColorView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(alignment: .myTrailingAlignment) {
                VStack(alignment: .myLeadingAlignment, spacing: 40.0) {
                    HStack {
                        HStack {
                            ForEach(boardDriver.freecells) { freeCell in
                                FreeCellView(freeCell: freeCell)
                                    .frame(width: self.cardSize.width, height: self.cardSize.height)
                                    .onTapGesture {
                                        self.boardDriver.itemTapped(freeCell)
                                }
                                .anchorPreference(key: CellInfoKey.self, value: .bounds, transform: { bounds in
                                    [CellInfo(cellId: freeCell.id, bounds: bounds)]
                                })
                            }
                        }.alignmentGuide(.myLeadingAlignment, computeValue: { d in d[HorizontalAlignment.leading] })
                        
                        Spacer()
                        #if !os(macOS)
                        ControlsView(timeString: boardDriver.moveTimeString, moves: boardDriver.moves).environmentObject(boardDriver)
                        Spacer()
                        #endif
                        
                        HStack {
                            ForEach(boardDriver.foundations) { foundation in
                                FoundationView(foundation: foundation)
                                    .frame(width: self.cardSize.width, height: self.cardSize.height)
                                    .onTapGesture {
                                        self.boardDriver.itemTapped(foundation)
                                }
                                .anchorPreference(key: CellInfoKey.self, value: .bounds, transform: { bounds in
                                    [CellInfo(cellId: foundation.id, bounds: bounds)]
                                })
                            }
                        }.alignmentGuide(.myTrailingAlignment, computeValue: { d in d[HorizontalAlignment.trailing] })
                    }
                    
                    HStack(spacing: 22.0) {
                        ForEach(boardDriver.columns) { column in
                            ColumnView(column: column)
                                .frame(width: self.cardSize.width, height: self.cardSize.height)
                                .onTapGesture {
                                    self.boardDriver.itemTapped(column)
                            }
                            .anchorPreference(key: CellInfoKey.self, value: .bounds, transform: { bounds in
                                [CellInfo(cellId: column.id, bounds: bounds)]
                            })
                        }
                    }.alignmentGuide(.myLeadingAlignment, computeValue: { d in d[HorizontalAlignment.leading] })
                    .alignmentGuide(.myTrailingAlignment, computeValue: { d in d[HorizontalAlignment.trailing] })
                }.padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20))
            }
            #warning("This padding looks really bad on macOS with resizable window - look into proper alignment guide instead")
            
        }
        .edgesIgnoringSafeArea(.all)
        .overlayPreferenceValue(CellInfoKey.self) { preferences in
            return GeometryReader { geometry in
                ZStack {
                    ForEach(self.boardDriver.allCards) { card in
                        self.renderedCardView(card, using: geometry, cells: preferences)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .onTapGesture {
            self.boardDriver.itemTapped(self)
        }
    }
    
    func renderedCardView(_ card: Card, using geometry: GeometryProxy, cells: [CellInfo]) -> some View {
        if let boardDriver = boardDriver as? ModernViewDriver {
            boardDriver.storeCellPositions(cells, using: geometry)
        }
        
        var bounds = CGRect.zero
        var stackOffset = CGSize.zero
        
        let containingLocation = boardDriver.cell(containing: card)
        if let p = cells.filter({
            $0.cellId == containingLocation.id
        }).first {
            bounds = geometry[p.bounds]
            if let column = containingLocation as? Column {
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
        .position(x: bounds.midX, y: bounds.midY + stackOffset.height)
        .offset(boardDriver.cardOffset(for: card, relativeTo: bounds, dragState: dragState))
        .animation(cardSpringAnimation)
        .simultaneousGesture(
            createDragGesture(for: card)
        )
            .zIndex(boardDriver.zIndex(for: card))
    }
    
    func createDragGesture(for card: Card) -> some Gesture {
        let gesture = DragGesture()
            .updating(self.$dragState) { (value, state, _) in
                if case .inactive = state {
                    self.boardDriver.dragStarted(from: card)
                }
                state = .active(translation: value.translation)
        }
        .onEnded { value in
            self.boardDriver.dragEnded(with: value.translation)
        }
        
        return boardDriver is ModernViewDriver ? gesture : nil
    }
    
    var cardSize: CGSize {
        //        return CGSize(width: 125, height: 187)  // iPad Pro
        //        return CGSize(width: 107, height: 160)  // iPad Mini
        return CGSize(width: 100, height: 149)  // iPad Mini, reduced
    }
    
    var cardSpringAnimation: Animation? {
        switch dragState {
        case .inactive:
            //        return Animation.spring(response: 0.08, dampingFraction: 0.95, blendDuration: 0.0)
            return .spring(response: 0.10, dampingFraction: 0.90, blendDuration: 0.0)
        case .active(_): return nil
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(boardDriver: ClassicViewDriver())
            .previewLayout(.fixed(width: 1194, height: 834))
        //            .previewLayout(.fixed(width: 1024, height: 768))
    }
}
