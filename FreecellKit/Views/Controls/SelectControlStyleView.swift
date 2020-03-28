//
//  SelectControlStyleView.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/15/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

#if os(iOS)
struct SelectControlStyleView: View {
    @Binding var controlStyle: ControlStyle
    
    var body: some View {
        Form {
            Section(footer: Text(footerText)) {
                ForEach(ControlStyle.allCases, id: \.self) { style in
                    Button(action: {
                        self.controlStyle = style
                    }) {
                        CellRow(leading: Text(style.rawValue), trailing: self.image(for: style).foregroundColor(.freecellBackground))
                    }
                }
            }
        }
        .navigationBarTitle("Control Style", displayMode: .inline)
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
    
    func image(for style: ControlStyle) -> Image? {
        return style == controlStyle ? Image(systemName: "checkmark") : nil
    }
    
    var footerText: String {
        switch controlStyle {
        case .classic:
            return "In Classic mode, click to select a card or column. Click again on a destination to move. Only the bottom card will ever appear selected, but valid column moves will still be performed. No dragging is possible."
        case .modern:
            return "In Modern mode, drag a card or stack to the desired destination to move. Or, tap on a card or stack to move automatically to a valid location."
        }
    }
}

struct SelectControlStyleView_Previews: PreviewProvider {
    @State static var controlStyle = ControlStyle.modern
    static var previews: some View {
        SelectControlStyleView(controlStyle: $controlStyle)
            .environment(\.horizontalSizeClass, .compact)
            .previewLayout(.fixed(width: 520, height: 640))
    }
}
#endif
