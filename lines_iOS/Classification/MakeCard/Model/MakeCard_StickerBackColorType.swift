//
//  StickerBackType.swift
//  lines_iOS
//
//  Created by mun on 2022/08/23.
//

import UIKit

enum MakeCard_StickerBackColorType: Int, CaseIterable {
    case grey = 0x3d3d3d
    case pink = 0xe19da5
    case yellow = 0xa99114
    case blue = 0x27687e
    case green = 0x085d28
    var color: UIColor {
        return UIColor(rgb: self.rawValue)
    }
}
