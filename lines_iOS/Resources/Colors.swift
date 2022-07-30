//
//  Colors.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation
import UIKit

enum Colors {
    case white
    case black
    var value: UIColor {
        switch self {
        case .white:
            return UIColor(rgb: 0xFFFFFF)
        case .black:
            return UIColor(rgb: 0x000000)
        }
    }
}
