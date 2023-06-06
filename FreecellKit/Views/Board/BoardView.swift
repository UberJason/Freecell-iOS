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
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 40.0) {
                    HStack {
                        HStack {
                            ForEach(self.boardDriver.freecells) { freeCell in
                                FreeCellView(freeCell: freeCell)
                                    .frame(width: self.boardDriver.cardSize.width, height: self.boardDriver.cardSize.height)
                                    .onTapGesture {
                                        self.boardDriver.itemTapped(freeCell)
                                }
                                .anchorPreference(key: CellInfoKey.self, value: .bounds) { bounds in [CellInfo(cellId: freeCell.id, bounds: bounds)] }
                            }
                        }
                        
                        Spacer()

                        HStack {
                            ForEach(self.boardDriver.foundations) { foundation in
                                FoundationView(foundation: foundation)
                                    .frame(width: self.boardDriver.cardSize.width, height: self.boardDriver.cardSize.height)
                                    .onTapGesture {
                                        self.boardDriver.itemTapped(foundation)
                                }
                                .anchorPreference(key: CellInfoKey.self, value: .bounds) { bounds in [CellInfo(cellId: foundation.id, bounds: bounds)] }
                            }
                        }
                    }
                    .frame(width: self.totalColumnWidth)
                    .anchorPreference(key: TopStackBoundsKey.self, value: .bounds) { bounds in
                        let b = TopStackBounds(bounds: bounds)
                        return b
                    }
                    
                    HStack(spacing: 22.0) {
                        ForEach(self.boardDriver.columns) { column in
                            ColumnView(column: column, tilingButtonVisible: self.boardDriver.tilingButtonVisible(for: column), isCollapsed: Binding(get: {
                                self.boardDriver.columnIsCollapsed(column.id)
                            }, set: { (newValue) in
                                self.boardDriver.setTilingState(for: column.id, isCollapsed: newValue)
                            }))
                                .frame(width: self.boardDriver.cardSize.width, height: self.boardDriver.cardSize.height)
                                .onTapGesture {
                                    self.boardDriver.itemTapped(column)
                            }
                            .anchorPreference(key: CellInfoKey.self, value: .bounds) { bounds in [CellInfo(cellId: column.id, bounds: bounds)] }
                        }
                    }
                    .anchorPreference(key: ColumnStackWidthKey.self, value: .bounds) { bounds in ColumnStackWidth(bounds: bounds) }
                    .onPreferenceChange(ColumnStackWidthKey.self) { (preference) in
                        guard let bounds = preference.bounds else { return }
                        self.totalColumnWidth = proxy[bounds].width
                    }
                }.padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20))
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .drawingGroup()
        }
        .overlayPreferenceValue(CellInfoKey.self) { preferences in
            return GeometryReader { geometry in
                self.allRenderedCards(using: geometry, cells: preferences)
                    .drawingGroup()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            self.boardDriver.itemTapped(self)
        }
        .frame(minWidth: self.totalColumnWidth)
    }
    
    func allRenderedCards(using geometry: GeometryProxy, cells: [CellInfo]) -> some View {
        boardDriver.storeCellPositions(cells, using: geometry)
        return ZStack {
            ForEach(self.boardDriver.allCards) { card in
                self.renderedCardView(card, using: geometry, cells: cells)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    func renderedCardView(_ card: Card, using geometry: GeometryProxy, cells: [CellInfo]) -> some View {
        var bounds = CGRect.zero
        var stackOffset = CGSize.zero
        
        let containingLocation = boardDriver.cell(containing: card)
        if let p = cells.first(where: { $0.cellId == containingLocation.id }) {
            bounds = geometry[p.bounds]
            if let column = containingLocation as? Column {
                stackOffset = boardDriver.stackOffset(for: card, orderIndex: column.orderIndex(for: card), spacing: boardDriver.cardSpacing(for: column))
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
                print("updating drag for: \(card.displayTitle)")
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
    
    var cardSpringAnimation: Animation? {
        switch dragState {
        case .inactive:
            return .spring(response: 0.10, dampingFraction: 0.90, blendDuration: 0.0)
        case .active(_): return nil
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static func boardView() -> some View {
        let g = Game()
        let driver = BoardViewDriver(controlStyle: .modern, gameStateProvider: g)
        return ZStack {
            BackgroundColorView()
            BoardView(boardDriver: driver)
        }
    }
    
    static var previews: some View {
        Group {
            boardView()
                .environment(\.colorScheme, .dark)
                .previewLayout(.fixed(width: 1024, height: 768))
            
            boardView()
            .environment(\.colorScheme, .light)
            .previewLayout(.fixed(width: 1024, height: 768))
        }
    }
}
