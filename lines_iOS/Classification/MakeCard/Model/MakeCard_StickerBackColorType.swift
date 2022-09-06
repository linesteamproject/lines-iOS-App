//
//  StickerBackType.swift
//  lines_iOS
//
//  Created by mun on 2022/08/23.
//

import UIKit

enum MakeCard_StickerBackColorType: Int, CaseIterable {
    case black = 0x000000
    case pink = 0xe19da5
    case gold = 0xa99114
    case blue = 0x27687e
    case green = 0x085d28
    var color: UIColor {
        return UIColor(rgb: self.rawValue)
    }
    var name: String {
        switch self {
        case .black:
            return "Black"
        case .pink:
            return "Pink"
        case .gold:
            return "Gold"
        case .blue:
            return "Blue"
        case .green:
            return "Green"
        }
    }
}
