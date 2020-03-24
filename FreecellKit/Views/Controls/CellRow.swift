//
//  CellRow.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/13/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

struct CellRow<Leading: View, Trailing: View>: View {
    let leading: Leading
    let trailing: Trailing
    
    init(leading: Leading, trailing: Trailing) {
        self.leading = leading
        self.trailing = trailing
    }
    
    var body: some View {
        HStack {
            leading
            Spacer()
            trailing
        }
    }
}

struct CellRow_Previews: PreviewProvider {
    static var previews: some View {
        CellRow(leading: Text("Leading"), trailing: Text("Trailing"))
            .previewDevice("iPad mini")
            .previewLayout(.fixed(width: 500, height: 44))
    }
}
