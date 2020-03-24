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
    @GestureState var dragState: DragState = .inactive
    @State var totalColumnWidth: CGFloat? = nil
    
    public init(boardDriver: BoardViewDriver) {
        self.boardDriver = boardDriver
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            BackgroundColorView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            GeometryReader { proxy in
                ZStack {
                    #warning("Spacing above columns should equal padding above freecells - right now it's 50 vs. 40")
                    VStack(spacing: 50.0) {
                        HStack {
                            HStack {
                                ForEach(self.boardDriver.freecells) { freeCell in
                                    FreeCellView(freeCell: freeCell)
                                        .frame(width: self.cardSize.width, height: self.cardSize.height)
                                        .onTapGesture {
                                            self.boardDriver.itemTapped(freeCell)
                                    }
                                    .anchorPreference(key: CellInfoKey.self, value: .bounds, transform: { bounds in
                                        [CellInfo(cellId: freeCell.id, bounds: bounds)]
                                    })
                                }
                            }
                            
                            Spacer()
                            #if !os(macOS)
                            ControlsView(timeString: self.boardDriver.moveTimeString, moves: self.boardDriver.moves, boardDriver: self.boardDriver)
                            Spacer()
                            #endif
                            
                            HStack {
                                ForEach(self.boardDriver.foundations) { foundation in
                                    FoundationView(foundation: foundation)
                                        .frame(width: self.cardSize.width, height: self.cardSize.height)
                                        .onTapGesture {
                                            self.boardDriver.itemTapped(foundation)
                                    }
                                    .anchorPreference(key: CellInfoKey.self, value: .bounds, transform: { bounds in
                                        [CellInfo(cellId: foundation.id, bounds: bounds)]
                                    })
                                }
                            }
                        }.frame(width: self.totalColumnWidth)
                        
                        HStack(spacing: 22.0) {
                            ForEach(self.boardDriver.columns) { column in
                                ColumnView(column: column, expandCollapseButtonVisible: self.tilingButtonVisible(for: column), isCollapsed: Binding(get: {
                                    self.boardDriver.columnIsCollapsed(column.id)
                                }, set: { (newValue) in
                                    self.boardDriver.setTilingState(for: column.id, isCollapsed: newValue)
                                }))
                                    .frame(width: self.cardSize.width, height: self.cardSize.height)
                                    .onTapGesture {
                                        self.boardDriver.itemTapped(column)
                                }
                                .anchorPreference(key: CellInfoKey.self, value: .bounds, transform: { bounds in
                                    [CellInfo(cellId: column.id, bounds: bounds)]
                                })
                            }
                        }
                        .anchorPreference(key: ColumnWidthKey.self, value: .bounds, transform: { bounds in ColumnWidth(bounds: bounds) })
                        .onPreferenceChange(ColumnWidthKey.self) { (preference) in
                            guard let bounds = preference.bounds else { return }
                            self.totalColumnWidth = proxy[bounds].width
                        }
                    }.padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20))
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
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
        .frame(minWidth: self.totalColumnWidth)
    }
    
    func renderedCardView(_ card: Card, using geometry: GeometryProxy, cells: [CellInfo]) -> some View {
        boardDriver.storeCellPositions(cells, using: geometry)
        
        var bounds = CGRect.zero
        var stackOffset = CGSize.zero
        
        let containingLocation = boardDriver.cell(containing: card)
        if let p = cells.filter({
            $0.cellId == containingLocation.id
        }).first {
            bounds = geometry[p.bounds]
            if let column = containingLocation as? Column {
                stackOffset = boardDriver.stackOffset(for: card, orderIndex: column.orderIndex(for: card), spacing: self.cardSpacing(for: column))
            }
        }
        
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
        
        return boardDriver.dragGestureAvailable ? gesture : nil
    }
    
    func tilingButtonVisible(for column: Column) -> Bool {
        return SpacingCalculator().stackRequiresCompression(column.items.count, cardHeight: cardSize.height)
    }
    
    func cardSpacing(for column: Column) -> CGFloat {
        let calculator = SpacingCalculator()
        guard calculator.stackRequiresCompression(column.items.count, cardHeight: cardSize.height) else { return defaultCardSpacing }
        
        let isCollapsed = boardDriver.columnIsCollapsed(column.id)
        let optimalSpacing = calculator.spacingThatFits(calculator.availableVerticalSpace(bottomPadding: 20), cardHeight: cardSize.height, numberOfCards: column.items.count)
        
        return isCollapsed ? optimalSpacing : SpacingConstants.defaultSpacing
    }
    
    var cardSize: CGSize {
        //        return CGSize(width: 125, height: 187)  // iPad Pro
        //        return CGSize(width: 107, height: 160)  // iPad Mini
        return CGSize(width: 100, height: 149)  // iPad Mini, reduced
    }
    
    var defaultCardSpacing: CGFloat { 40.0 }
    
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
        BoardView(boardDriver: BoardViewDriver(controlStyle: .modern))
//            .previewLayout(.fixed(width: 1400, height: 1200))
        //            .previewLayout(.fixed(width: 1194, height: 834))
                    .previewLayout(.fixed(width: 1024, height: 768))
    }
}
