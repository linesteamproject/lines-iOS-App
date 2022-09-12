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
    case regular
}
class Fonts {
    class func get(size: CGFloat, type: FontType) -> UIFont {
        switch type {
        case .light:
            return UIFont(name: "AppleSDGothicNeoL00", size: size)!
        case .medium:
            return UIFont(name: "AppleSDGothicNeoM00", size: size)!
        case.regular:
            return UIFont(name: "AppleSDGothicNeoM00", size: size)!
        case .bold:
            return UIFont(name: "AppleSDGothicNeoB00", size: size)!
        }
    }
    class func getNanum(size: CGFloat) -> UIFont {
        return UIFont(name: "NanumMyeongjo-YetHangul", size: size)!
    }
}
