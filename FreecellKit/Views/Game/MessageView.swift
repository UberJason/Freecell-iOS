//
//  MessageView.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/13/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

struct MessageView: View {
    let message: String
    
    var body: some View {
        HStack {
            Image(systemName: "xmark.circle")
            Text(message)
        }
        .font(.system(size: 13, weight: .bold))
        .foregroundColor(Color.white)
        .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
        .background(Color.messageViewBackground)
        .cornerRadius(16)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(message: "Invalid move.")
            .frame(width: 200, height: 100).background(Color.freecellBackground)
            .previewLayout(.fixed(width: 200, height: 100))
    }
}
