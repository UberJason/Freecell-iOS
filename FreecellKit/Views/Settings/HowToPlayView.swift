//
//  HowToPlayView.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/15/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

extension View {
    func frame(size: CGSize, alignment: Alignment = .center) -> some View {
        return frame(width: size.width, height: size.height, alignment: alignment)
    }
}

struct Instruction: Identifiable {
    let id = UUID()
    let title: String
    let sections: [Content]
}

protocol Content {
    var id: UUID { get }
    var contentView: AnyView { get }
}

struct Paragraph: Content {
    let id = UUID()
    let content: String
    
    var contentView: AnyView {
        AnyView(Text(content))
    }
}

struct MiniBoard: Content {
    let id = UUID()
    let cornerRadius: CGFloat = 4.0
    let cardSize = CGSize(width: 55, height: 80)
    let board = BoardParser().parse(fromFile: "AUI+Screenshots", bundle: Bundle.freecellKit)!
    
    var contentView: AnyView {
        AnyView(
            boardView
        )
    }
    
    var boardView: some View {
        VStack {
            HStack {
                miniFreecells
                Spacer()
                miniFoundations
            }
            miniColumns
        }
        .padding(8)
        .background(Color.freecellBackground)
        .cornerRadius(8)
    }
    
    var miniFreecells: some View {
        FreecellsContent(cornerRadius: cornerRadius, cardSize: cardSize)
    }
    
    var miniFoundations: some View {
        VStack {
            HStack(spacing: 2) {
                ForEach(0..<4) { _ in
                    EmptySpotView(cornerRadius: self.cornerRadius).frame(size: self.cardSize)
                }
            }
            Text("Foundations").font(.system(.body)).foregroundColor(.white).bold()
        }
    }
    
    var miniColumns: some View {
        VStack {
            ColumnViewContent(
                cardSize: cardSize,
                titleSize: 16,
                tabPadding: 2.0,
                cornerRadius: cornerRadius,
                columnSpacing: 8,
                stackSpacing: 25,
                highlightAvailableCard: false,
                columns: board.columns
            )
            Text("Columns").font(.system(.body)).foregroundColor(.white).bold()
        }
    }
}

struct FreecellsContent: Content, View {
    let id = UUID()
    let cornerRadius: CGFloat
    let cardSize: CGSize

    var body: some View {
        miniFreecells
    }
    
    var contentView: AnyView {
        AnyView(self)
    }
    
    var miniFreecells: some View {
        VStack {
            HStack(spacing: 2) {
                ForEach(0..<4) { _ in
                    EmptySpotView(cornerRadius: self.cornerRadius).frame(size: self.cardSize)
                }
            }
            Text("Freecells").font(.system(.body)).foregroundColor(.white).bold()
        }
    }
}

struct ColumnViewContent: Content, View {
    let id = UUID()
    let cardSize: CGSize
    let titleSize: CGFloat
    let tabPadding: CGFloat
    let cornerRadius: CGFloat
    let columnSpacing: CGFloat
    let stackSpacing: CGFloat
    let highlightAvailableCard: Bool
    let columns: [Column]
    
    init(cardSize: CGSize, titleSize: CGFloat, tabPadding: CGFloat = 5.0, cornerRadius: CGFloat = 8.0, columnSpacing: CGFloat, stackSpacing: CGFloat, highlightAvailableCard: Bool = true, columns: [Column]) {
        self.cardSize = cardSize
        self.titleSize = titleSize
        self.tabPadding = tabPadding
        self.cornerRadius = cornerRadius
        self.columnSpacing = columnSpacing
        self.stackSpacing = stackSpacing
        self.highlightAvailableCard = highlightAvailableCard
        self.columns = columns
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: columnSpacing) {
            ForEach(columns) { column in
                ZStack(alignment: .top) {
                    EmptySpotView(cornerRadius: self.cornerRadius)
                        .frame(width: self.cardSize.width, height: self.cardSize.height)
                    ForEach(column.stack) { card in
                        CardView(card: card, titleSize: self.titleSize, tabPadding: self.tabPadding, cornerRadius: self.cornerRadius)
                            .frame(width: self.cardSize.width, height: self.cardSize.height)
                            .overlay(
                                CardRectangle(foregroundColor: self.foregroundColor(for: card, in: column), cornerRadius: self.cornerRadius, opacity: 0.3)
                        )
                            .offset(x: 0, y: self.stackSpacing*CGFloat(column.orderIndex(for: card)))
                            .padding(.bottom, self.stackSpacing*CGFloat(column.orderIndex(for: card)))
                    }
                }
            }
        }.padding([.top, .bottom], 8)
    }
    
    func foregroundColor(for card: Card, in column: Column) -> Color {
        guard highlightAvailableCard else { return .clear }
        return card == column.stack.last ? .yellow : .clear
    }
    
    var contentView: AnyView { AnyView(self) }
}

struct CenteringWrapper<T: View>: Content {
    let id: UUID = UUID()
    let content: T
    
    var contentView: AnyView {
        AnyView(
            ZStack {
                Rectangle().foregroundColor(.clear)
                content
            }
        )
    }
}

struct FreecellAndColumnContent: Content {
    let id = UUID()
    let cardSize: CGSize
    let titleSize: CGFloat
    let tabPadding: CGFloat
    let cornerRadius: CGFloat
    let columnSpacing: CGFloat
    let stackSpacing: CGFloat
    
    init(cardSize: CGSize, titleSize: CGFloat, tabPadding: CGFloat = 5.0, cornerRadius: CGFloat = 8.0, columnSpacing: CGFloat, stackSpacing: CGFloat) {
        self.cardSize = cardSize
        self.titleSize = titleSize
        self.tabPadding = tabPadding
        self.cornerRadius = cornerRadius
        self.columnSpacing = columnSpacing
        self.stackSpacing = stackSpacing
    }
    
    var contentView: AnyView {
        AnyView(
            VStack(alignment: .leading) {
                FreecellsContent(cornerRadius: cornerRadius, cardSize: cardSize)
                ColumnViewContent(
                    cardSize: cardSize,
                    titleSize: titleSize,
                    tabPadding: tabPadding,
                    cornerRadius: cornerRadius,
                    columnSpacing: columnSpacing,
                    stackSpacing: stackSpacing,
                    highlightAvailableCard: false,
                    columns: [
                        Column(text: "[❤️6, ❤️J, ♣️10, ♦️9, ♠️8, ❤️7]")!,
                        Column(text: "[♠️4, ♠️Q]")!
                    ]
                )
            }
            .padding(8)
            .background(Color.freecellBackground)
            .cornerRadius(8)
        )
    }
}

struct ImageContent: Content {
    let id = UUID()
    let image: Image
    var contentView: AnyView {
        AnyView(image)
    }
}

struct ImageCarousel: Content {
    let id = UUID()
    let images: [ImageContent]
    
    var contentView: AnyView {
        AnyView(
            ScrollView {
                HStack {
                    ForEach(images, id: \.id) { image in
                        image.contentView
                    }
                }
            }
        )
    }
}

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
            MiniBoard()
        ]),
        Instruction(title: "Basic Moves", sections: [
            Paragraph(content: "Within a column, only the bottom card in the stack (the one fully exposed at the bottom) can be moved. That card can be moved onto another column if and only if the receiving card is one higher in rank and has the opposite color suit. In the example below, only the ♣️3, ❤️4 and ♣️J are available to move, and the ♣️3 can only be placed onto the ❤️4 - not the ♣️4."),
            CenteringWrapper(content: ColumnViewContent(
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
            FreecellAndColumnContent(
                cardSize: CGSize(width: 80, height: 116),
                titleSize: 20,
                columnSpacing: 22,
                stackSpacing: 38
            ),
            Paragraph(content: "This version of Freecell will automatically compute whether most stack movements are valid and will move the entire stack automatically if so. But more complex stack movements might still be possible, even if Freecell can't see them - so look carefully! Also, when using the Classic control scheme, performing a stack movement will show the full animation of cards moving up and down from Freecells.")
        ])
    ]
}

struct HowToPlayView: View {
    let instructions: [Instruction]
    
    var body: some View {
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
            .navigationBarTitle("How To Play")
        }
    }
}

struct HowToPlayView_Previews: PreviewProvider {
    static let instructions1 = [
        Instruction(title: "Basic Moves", sections: [
            Paragraph(content: "Within a column, only the bottom card in the stack (the one fully exposed at the bottom) can be moved. That card can be moved onto another column if and only if the receiving card is one higher in rank and has the opposite color suit. In figure 1 below, only the ♣️3, ❤️4 and ♣️J are available to move, and the ♣️3 can only be placed onto the ❤️4 - not the ♣️4."),
            ColumnViewContent(
                cardSize: CGSize(width: 80, height: 116),
                titleSize: 20,
                columnSpacing: 22,
                stackSpacing: 38,
                columns: [
                    Column(text: "[♠️J, ❤️9, ♠️4, ♣️3]")!,
                    Column(text: "[♦️K, ♠️7, ♦️10, ❤️4]")!,
                    Column(text: "[♠️2, ♦️4, ♦️5, ♣️4]")!
                ]
            ),
            Paragraph(content: "The card at the bottom of a column may also be moved into an open Freecell if one is available, or onto its matching Foundation if it would be the next card in the sequence. Note that cards placed into a Foundation cannot be removed, and cards can only be moved from a Freecell back onto a column if that column can receive the card (the column's bottom card is one rank higher and the opposite color)."),
            Paragraph(content: "If a Column is empty, it acts as a Freecell - any card can be placed there.")
        ])
    ]
    
    static let instructions2 = [
        Instruction(title: "Board Layout", sections: [
            Paragraph(content: "There are three different types of card piles in Freecell."),
            Paragraph(content: "• Columns: the eight Columns make up the majority of the board, and all of the cards start out in a column."),
            Paragraph(content: "• Foundations: the four cells in the upper-right corner of the board are called the Foundations, where you want to move the cards. Foundations are ordered by rank and sorted by suit, so you must place cards into its matching Foundation in order from Ace to King."),
            Paragraph(content: "• Freecells: the four cells in the upper-left corner of the board are called the FreeCells. These represent a free spot that you can place a card."),
            MiniBoard()
        ])
    ]
    
    static let instructions3 = [
        Instruction(title: "Moving Stacks", sections: [
            Paragraph(content: "Though the basic rules only allow moving one card at a time, empty Freecells and empty Columns allow you to move stacks of cards. In Figure 2 below, with four open Freecells, you can move the ❤️7 to a Freecell, then the ♠️8, then the ♦️9, and finally the ♣️10. This opens up the ❤️J to be moved directly onto the ♠️Q, after which you can move the ♣️10 back down onto the ❤️J, then the ♦️9, the ♠️8, and the ❤️7."),
            FreecellAndColumnContent(
                cardSize: CGSize(width: 80, height: 116),
                titleSize: 20,
                columnSpacing: 22,
                stackSpacing: 38
            ),
            Paragraph(content: "This version of Freecell will automatically compute whether most stack movements are valid and will move the entire stack automatically if so. But more complex stack movements might still be possible, even if Freecell can't see them - so look carefully! Also, when using the Classic control scheme, performing a stack movement will show the full animation of cards moving up and down from Freecells.")
        ])
    ]
    static var previews: some View {
        Group {
//            HowToPlayView(instructions: instructions1)
//                .previewLayout(.fixed(width: 520, height: 640))
//            HowToPlayView(instructions: instructions2)
            FreecellAndColumnContent(
                cardSize: CGSize(width: 80, height: 116),
                titleSize: 20,
                columnSpacing: 22,
                stackSpacing: 38
            ).contentView
                .previewLayout(.fixed(width: 520, height: 640))
        }
    }
}
