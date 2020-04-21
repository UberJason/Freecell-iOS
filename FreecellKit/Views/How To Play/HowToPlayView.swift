//
//  HowToPlayView.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/15/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

public struct HowToPlayView: View {
    public let instructions: [Instruction]
    
    public init(instructions: [Instruction]) {
        self.instructions = instructions
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(instructions) { instruction in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(instruction.title).font(.system(.title)).fontWeight(.bold)
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(instruction.sections, id: \.id) { section in
                                section.contentView.fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
            }.padding()
            .navigationBarTitle("How To Play", displayMode: .inline)
        }
    }
}

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
            FreecellAndColumnContent(
                cardSize: CGSize(width: 80, height: 116),
                titleSize: 20,
                columnSpacing: 22,
                stackSpacing: 38
            ).contentView
                .previewLayout(.fixed(width: 520, height: 640))
    }
}
