//
//  DismissableModalView.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/5/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

public struct DismissableModalView<Content: View>: View {
    public let title: String
    public let content: Content
    
    public init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    public var body: some View {
        NavigationView {
            content
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                .navigationBarTitle("\(title)", displayMode: .inline)
                .navigationBarItems(trailing:
                    Button(action: {
                        NotificationCenter.default.post(name: .dismissMenu, object: nil)
                    }) {
                        Text("Done").fontWeight(.bold)
                    }.padding([.leading, .top, .bottom], 8)
                )
                .background(Color(UIColor.systemGroupedBackground))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.freecellTheme)
    }
}

struct DismissableModalView_Previews: PreviewProvider {
    static var previews: some View {
        DismissableModalView(title: "Statistics") {
            StatisticsView()
        }
            .environment(\.horizontalSizeClass, .compact)
            .previewLayout(.fixed(width: 520, height: 640))
    }
}
