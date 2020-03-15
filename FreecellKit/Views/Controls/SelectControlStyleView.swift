//
//  SelectControlStyleView.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/15/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

struct SelectControlStyleView: View {
    @Binding var controlStyle: ControlStyle
    
    var body: some View {
        Form {
            Section(footer: Text("Footer goes here")) {
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
    
    func image(for style: ControlStyle) -> AnyView {
        return style == controlStyle ? AnyView(Image(systemName: "checkmark")) : AnyView(EmptyView())
    }
}

struct SelectControlStyleView_Previews: PreviewProvider {
    @State static var controlStyle = ControlStyle.classic
    static var previews: some View {
        SelectControlStyleView(controlStyle: $controlStyle)
            .environment(\.horizontalSizeClass, .compact)
            .previewLayout(.fixed(width: 520, height: 640))
    }
}
