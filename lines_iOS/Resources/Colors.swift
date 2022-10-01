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
    case blackGradient
    case gold
    case beige
    case beigeInactive
    case gray1E1E1E
    case gray222222
    case gray777777
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
        case .blackGradient:
            return UIColor(rgb: 0x485368)
        case .gold:
            return UIColor(rgb: 0xDABA8A)
        case .beige:
            return UIColor(rgb: 0xFFE5AC)
        case .beigeInactive:
            return UIColor(rgb: 0x7E7050)
        case .gray:
            return UIColor(rgb: 0x808080)
        case .gray1E1E1E:
            return UIColor(rgb: 0x1E1E1E)
        case .gray222222:
            return UIColor(rgb: 0x222222)
        case.gray777777:
            return UIColor(rgb: 0x777777)
        case .clear:
            return .clear
        case .highlight:
            return UIColor(rgb: 0xD69609)
        case .ferra:
            return UIColor(rgb: 0x795454)
        case .kakao:
            return UIColor(rgb: 0xFEE500)
        case .naver:
            return UIColor(rgb: 0x03C75A)
        case .apple:
            return UIColor(rgb: 0xFFFFFF)
        }
    }
}
