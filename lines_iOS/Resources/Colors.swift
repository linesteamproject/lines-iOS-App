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
    case gold
    case beige
    case gray222222
    case gray
    case clear
    case highlight
    case ferra
    case kakao
    case naver
    case apple
    var value: UIColor {
        switch self {
        case .white:
            return UIColor(rgb: 0xFFFFFF)
        case .black:
            return UIColor(rgb: 0x000000)
        case .gold:
            return UIColor(rgb: 0xDABA8A)
        case .beige:
            return UIColor(rgb: 0xFFE5AC)
        case .gray:
            return UIColor(rgb: 0x808080)
        case .gray222222:
            return UIColor(rgb: 0x222222)
        case .clear:
            return .clear
        case .highlight:
            return UIColor(rgb: 0xD69609)
        case .ferra:
            return UIColor(rgb: 0x795454)
        case .kakao:
            return UIColor(rgb: 0xF5DF5A)
        case .naver:
            return UIColor(rgb: 0x5EC43C)
        case .apple:
            return UIColor(rgb: 0xFFFFFF)
        }
    }
}
