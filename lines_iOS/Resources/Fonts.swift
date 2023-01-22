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
    class func get(size: CGFloat, font: 폰트) -> UIFont {
        switch font {
        case .나눔명조:
            return UIFont(name: "NanumMyeongjo-YetHangul", size: size)!
        case .본고딕:
            return UIFont(name: "NotoSansNKo-Regular", size: size)!
        case .나눔스퀘어:
            return UIFont(name: "NanumSquareNeoTTF-bRg", size: size)!
        case .고운돋움:
            return UIFont(name: "GowunDodum-Regular", size: size)!
        case .나눔손글씨:
            return UIFont(name: "NanumURiDdarSonGeurSsi", size: size)!
        }
    }
}
