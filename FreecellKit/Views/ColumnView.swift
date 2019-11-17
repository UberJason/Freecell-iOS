//
//  ColumnView.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/17/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

struct ColumnView: View {
    let column: Column
    
    public init(column: Column) {
        self.column = column
    }
    
    public var body: some View {
        CardView(card: Card.ace.ofSpades)
    }
}

struct ColumnView_Previews: PreviewProvider {
    static var previews: some View {
        ColumnView(column: Column(id: 0))
            .previewLayout(.fixed(width: 200, height: 262))
    }
}
