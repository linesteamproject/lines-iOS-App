//
//  Extensions+Value.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import UIKit

extension CGFloat {
    static func random() -> Double {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
