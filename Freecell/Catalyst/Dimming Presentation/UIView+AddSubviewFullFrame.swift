//
//  UIView+AddSubviewFullFrame.swift
//  Freecell
//
//  Created by Jason Ji on 4/5/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import UIKit

public extension UIView {
    func addSubviewFullFrame(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
