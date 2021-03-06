//
//  ColumnView.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/17/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

public struct ColumnView: View {
    let column: Column
    let tilingButtonVisible: Bool
    @Binding var isCollapsed: Bool
    
    public init(column: Column, tilingButtonVisible: Bool, isCollapsed: Binding<Bool>) {
        self.column = column
        self.tilingButtonVisible = tilingButtonVisible
        self._isCollapsed = isCollapsed
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            #if !targetEnvironment(macCatalyst)
            if tilingButtonVisible {
                TilingButton(isCollapsed: $isCollapsed)
                    .offset(x: 0, y: -32)
            }
            #endif
            EmptySpotView()
        }
        .accessibilityElement(children: .combine)
        .accessibility(identifier: column.id)
        .accessibility(hidden: column.topItem != nil)
    }
}

struct ColumnView_Previews: PreviewProvider {
    @State static var isCollapsed = false
    
    static var previews: some View {
        let column = Column()
        column.setupPush(Card.king.ofDiamonds)
        column.setupPush(Card.seven.ofSpades)
        column.setupPush(Card.four.ofHearts)
        column.setupPush(Card.ace.ofSpades)
        
        return ColumnView(column: column, tilingButtonVisible: true, isCollapsed: $isCollapsed)
            .frame(width: 125, height: 187)
            .frame(width: 200, height: 700)
            .background(Color.green)
            .previewLayout(.fixed(width: 200, height: 700))
    }
}
