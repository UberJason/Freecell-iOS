//
//  UIImage+Freecell.swift
//  Freecell
//
//  Created by Jason Ji on 4/4/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import UIKit
import FreecellKit

extension UIImage {
    convenience init?(identifier: Symbol.Identifier) {
        self.init(systemName: identifier.rawValue)
    }
}

extension Symbol.Identifier {
    static let statistics = Symbol.Identifier(rawValue: "doc.plaintext")
}

extension UIImage {
    static var undo: UIImage {
        return UIImage(identifier: .undo)!
    }
    
    static var restart: UIImage {
        return UIImage(identifier: .restart)!
    }
    
    static var newGame: UIImage {
        return UIImage(identifier: .newGame)!
    }
    
    static var statistics: UIImage {
        return UIImage(identifier: .statistics)!
    }
}
