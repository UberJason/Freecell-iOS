//
//  ExpandCollapseButton.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/22/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

struct ExpandCollapseButton: View {
    @Binding var isCollapsed: Bool
    
    public var body: some View {
        Button(action: {
            self.isCollapsed.toggle()
        }) {
            image()
                .foregroundColor(.white)
                .font(.system(size: 15))
                .frame(width: 22, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white, lineWidth: 1.5)
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
    }
}
