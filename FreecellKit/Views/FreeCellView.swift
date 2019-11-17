//
//  FreeCellView.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/17/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

public struct FreeCellView: View {
    let freeCell: FreeCell
    
    public init(freeCell: FreeCell) {
        self.freeCell = freeCell
    }
    
    public var body: some View {
        viewToShow
    }
    
    var viewToShow: AnyView {
        if let card = freeCell.item {
            return AnyView(CardView(card: card))
        }
        else {
            return AnyView(EmptySpotView())
        }
    }
}

struct FreeCellView_Previews: PreviewProvider {
    static var previews: some View {
        let emptyFreeCell = FreeCell(id: 0)
        let occupiedFreeCell: FreeCell = {
            let f = FreeCell(id: 1)
            try! f.push(Card.ace.ofSpades)
            return f
        }()
        
        return Group {
            FreeCellView(freeCell: emptyFreeCell)
                .frame(width: 125, height: 187)
                .frame(width: 200, height: 262)
                .background(Color.green)
                .previewLayout(.fixed(width: 200, height: 262))
            FreeCellView(freeCell: occupiedFreeCell)
                .frame(width: 125, height: 187)
                .frame(width: 200, height: 262)
                .background(Color.green)
                .previewLayout(.fixed(width: 200, height: 262))
        }
    }
}
