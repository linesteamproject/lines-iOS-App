//
//  Fonts.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import UIKit

enum FontType {
    case light
    case medium
    case bold
}
class Fonts {
    class func get(size: CGFloat, type: FontType) -> UIFont {
        switch type {
        case .light:
            return UIFont(name: "AppleSDGothicNeoL", size: size) ?? .systemFont(ofSize: size)
        case .medium:
            return UIFont(name: "AppleSDGothicNeoM", size: size) ?? .systemFont(ofSize: size,
                                                                                weight: .medium)
        case .bold:
            return UIFont(name: "AppleSDGothicNeoB", size: size) ?? .boldSystemFont(ofSize: size)
        }
    }
}
