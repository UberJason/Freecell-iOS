//
//  TilingButton.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/22/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI
#if os(iOS)
struct TilingButton: View {
    @Binding var isCollapsed: Bool
    
    public var body: some View {
        Button(action: {
            self.isCollapsed.toggle()
        }) {
            image()
                .foregroundColor(.freecellBackground)
                .font(.system(size: 15, weight: .semibold))
                .frame(width: 20, height: 26)
                .background(
                    RoundedRectangle(cornerRadius: 4).fill(Color.cardBackground)
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

struct TilingButton_Previews: PreviewProvider {
    @State static var isCollapsed = false
    static var previews: some View {
        TilingButton(isCollapsed: $isCollapsed)
            .frame(width: 100, height: 100)
            .background(Color.freecellBackground)
            .previewLayout(.fixed(width: 100, height: 100))
    }
}
#endif
