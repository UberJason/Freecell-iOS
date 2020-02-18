//
//  ControlsView.swift
//  FreecellKit
//
//  Created by Jason Ji on 2/17/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

struct ControlsView: View {
    var body: some View {
        VStack(spacing: 30) {
            VStack(alignment: .leading, spacing: 0) {
                Text("1:27")
                Text("84 moves")
            }.font(.system(size: 15, weight: .semibold))
            HStack(spacing: 8) {
                VStack {
                    Button(action: {
                        print("Undo")
                    }) {
                        Image(systemName: "arrow.uturn.left.circle")
                            .font(.system(size: 30))
                    }
                    Text("Undo")
                }
                VStack {
                    Button(action: {
                        print("Settings")
                    }) {
                        Image(systemName: "gear")
                        .font(.system(size: 30))
                    }
                    Text("Menu")
                }
            }.font(.system(size: 11, weight: .semibold))
        }.foregroundColor(.white)
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView()
            .frame(width: 150, height: 300)
            .background(Color.green)
            .previewLayout(.fixed(width: 150, height: 300))
    }
}
