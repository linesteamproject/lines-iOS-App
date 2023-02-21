//
//  BookCardModel.swift
//  lines_iOS
//
//  Created by mun on 2023/02/21.
//

import Foundation

struct BookCardModel {
    var content: String?
    var book: BookModel?
    var sizeType: MakeCard_StickerRatioType = .one2one
    var colorType: MakeCard_StickerBackColorType = .black
    var font: 폰트
    var textAlignment: 텍스트정렬
    internal func getParam() -> [String: Any?] {
        return [
          "content": content,
          "book": book?.getParam(),
          "ratio": sizeType.typeStr,
          "background": colorType.name,
          "font": font.rawValue,
          "textAlignment": textAlignment.rawValue
        ]
    }
    internal func getPutParam(id: String) -> [String: Any?] {
        return [
            "id": Int(id),
            "background": colorType.name,
            "font": font.rawValue,
            "textAlignment": textAlignment.rawValue,
            "content": content,
            "ratio": sizeType.typeStr
        ]
    }
    mutating func updateContent(_ str: String?) {
        guard let str = str else {
            self.content = str
            return
        }
        guard str.count > 130 else {
            self.content = str
            return
        }
        
        let startIndex = str.index(str.startIndex, offsetBy: 0) // 사용자지정 시작인덱스
        let endIndex = str.index(str.startIndex, offsetBy: 130) // 사용자지정 끝인덱스
        let slicedStr = str[startIndex ..< endIndex]
        self.content = String(slicedStr)
    }
    mutating func updateSizeType(_ type: MakeCard_StickerRatioType) {
        self.sizeType = type
    }
    mutating func updateColorType(_ type: MakeCard_StickerBackColorType) {
        self.colorType = type
    }
    mutating func updateFontType(_ font: 폰트) {
        self.font = font
    }
    mutating func updateTextAlignmentType(_ txtAlign: 텍스트정렬) {
        self.textAlignment = txtAlign
    }
}
