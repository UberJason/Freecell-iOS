//
//  CustomDebugStrings.swift
//  FreecellKit
//
//  Created by Jason Ji on 12/18/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

extension FreeCell: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "[\(item?.displayTitle ?? " ")]"
    }
}

extension Foundation: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "[\(topItem?.displayTitle ?? " ")]"
    }
}

extension CardStack: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "[ " + items.map({ $0.displayTitle }).joined(separator: ", ") + "]"
    }
}

extension Board: CustomDebugStringConvertible {
    public var debugDescription: String {
        return  """
                
                Freecells: \(freecells[0].debugDescription) \(freecells[1].debugDescription) \(freecells[2].debugDescription) \(freecells[3].debugDescription)
                Foundations: \(foundations[0].debugDescription) \(foundations[1].debugDescription) \(foundations[2].debugDescription) \(foundations[3].debugDescription)
                Columns:
                \(columns.map({ $0.debugDescription }).joined(separator: "\n"))
                
                """
    }
    
    
}

let debugDateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "h:mm:ss.ssss"
    return f
}()
