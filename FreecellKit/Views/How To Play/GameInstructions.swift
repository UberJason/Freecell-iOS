//
//  GameInstructions.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/17/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import CoreGraphics

struct GameInstructions {
    let instructions = [
        Instruction(title: "Introduction", sections: [
            Paragraph(content: "Freecell is a variant of Solitaire. The cards start out stacked randomly in eight columns, and the goal is to have them all sorted by rank and suit - four stacks, one for each suit, from Ace to King.")
        ]),
        Instruction(title: "Board Layout", sections: [
            Paragraph(content: "There are three different types of card piles in Freecell."),
            Paragraph(content: "• Columns: the eight Columns make up the majority of the board, and all of the cards start out in a column."),
            Paragraph(content: "• Foundations: the four cells in the upper-right corner of the board are called the Foundations, where you want to move the cards. Foundations are ordered by rank and sorted by suit, so you must place cards into its matching Foundation in order from Ace to King."),
            Paragraph(content: "• Freecells: the four cells in the upper-left corner of the board are called the FreeCells. These represent a free spot that you can place a card."),
            CenteringBackgroundWrapper(content: MiniBoard().contentView)
        ]),
        Instruction(title: "Basic Moves", sections: [
            Paragraph(content: "Within a column, only the bottom card in the stack (the one fully exposed at the bottom) can be moved. That card can be moved onto another column if and only if the receiving card is one higher in rank and has the opposite color suit. In the example below, only the ♣️3, ❤️4 and ♣️J are available to move, and the ♣️3 can only be placed onto the ❤️4 - not the ♣️4."),
            CenteringBackgroundWrapper(content: ColumnsContent(
                cardSize: CGSize(width: 80, height: 116),
                titleSize: 20,
                columnSpacing: 22,
                stackSpacing: 38,
                columns: [
                    Column(text: "[♠️J, ❤️9, ♠️4, ♣️3]")!,
                    Column(text: "[♦️K, ♠️7, ♦️10, ❤️4]")!,
                    Column(text: "[♠️2, ♦️4, ♦️5, ♣️4]")!
                ]
            )),
            Paragraph(content: "The card at the bottom of a column may also be moved into an open Freecell if one is available, or onto its matching Foundation if it would be the next card in the sequence. Note that cards placed into a Foundation cannot be removed, and cards can only be moved from a Freecell back onto a column if that column can receive the card (the column's bottom card is one rank higher and the opposite color)."),
            Paragraph(content: "If a Column is empty, it acts as a Freecell - any card can be placed there.")
        ]),
        Instruction(title: "Moving Stacks", sections: [
            Paragraph(content: "Though the basic rules only allow moving one card at a time, empty Freecells and empty Columns allow you to move stacks of cards. In Figure 2 below, with four open Freecells, you can move the ❤️7 to a Freecell, then the ♠️8, then the ♦️9, and finally the ♣️10. This opens up the ❤️J to be moved directly onto the ♠️Q, after which you can move the ♣️10 back down onto the ❤️J, then the ♦️9, the ♠️8, and the ❤️7."),
            CenteringBackgroundWrapper(content: FreecellAndColumnContent(
                cardSize: CGSize(width: 80, height: 116),
                titleSize: 20,
                columnSpacing: 22,
                stackSpacing: 38
            )),
            Paragraph(content: "This version of Freecell will automatically compute whether most stack movements are valid and will move the entire stack automatically if so. But more complex stack movements might still be possible, even if Freecell can't see them - so look carefully! Also, when using the Classic control scheme, performing a stack movement will show the full animation of cards moving up and down from Freecells.")
        ])
    ]
}
