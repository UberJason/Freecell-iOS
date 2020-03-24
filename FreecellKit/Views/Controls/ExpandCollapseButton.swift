//
//  ExpandCollapseButton.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/22/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI
#if os(iOS)
struct ExpandCollapseButton: View {
    @Binding var isCollapsed: Bool
    
    public var body: some View {
        Button(action: {
            self.isCollapsed.toggle()
        }) {
            image()
                .foregroundColor(.freecellBackground)
                .font(.system(size: 15, weight: .semibold))
                .frame(width: 22, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 4).fill(Color.white)
                )
        }
    }
    
    func image() -> some View {
        if isCollapsed {
            return Image.expand
        }
        else {
            return Image.collapse
        }
    }
}

struct ExpandCollapseButton_Previews: PreviewProvider {
    @State static var isCollapsed = false
    static var previews: some View {
        ExpandCollapseButton(isCollapsed: $isCollapsed)
            .frame(width: 100, height: 100)
            .background(Color.freecellBackground)
            .previewLayout(.fixed(width: 100, height: 100))
    }
}
#endif
