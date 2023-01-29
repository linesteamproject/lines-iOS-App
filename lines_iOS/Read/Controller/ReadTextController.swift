//
//  CameraController.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation
import UIKit

enum ReadTextStep {
    case start
    case capture
    case crop
}

class ReadTextController: NSObject {
    static let shared = ReadTextController()
    internal var cardModel: CardModel? {
        didSet {
            let colorType = MakeCard_StickerBackColorType.allCases.first(where: {  cardModel?.colorImageName?.contains($0.name) ?? false }) ?? .black
            let bookModel = BookModel(title: cardModel?.bookName,
                                      name: cardModel?.authorName,
                                      isbn: cardModel?.bookIsbn)
            let fontRaw = cardModel?.font ?? 폰트.나눔명조.rawValue
            let txtAlign = cardModel?.textAlignment ?? 텍스트정렬.왼쪽.rawValue
            self.bookCardModel = BookCardModel(content: cardModel?.lineValue,
                                               book: bookModel,
                                               sizeType: cardModel?.ratioType ?? .one2one,
                                               colorType: colorType,
                                               font: 폰트(rawValue: fontRaw) ?? .나눔명조,
                                               textAlignment: 텍스트정렬(rawValue: txtAlign) ?? .왼쪽)
        }
    }
    
    internal func getCardModel(id: String?) -> CardModel? {
        return CardModel(id: id,
                         bookName: self.bookCardModel.book?.title,
                         authorName: self.bookCardModel.book?.name,
                         bookIsbn: self.bookCardModel.book?.isbn,
                         lineValue: self.bookCardModel.content,
                         colorImageName: self.bookCardModel.colorType.name,
                         ratioType: self.bookCardModel.sizeType,
                         font: self.bookCardModel.font.rawValue,
                         textAlignment: self.bookCardModel.textAlignment.rawValue)
    }
    internal var bookCardModel = BookCardModel(content: nil,
                                               book: BookModel(),
                                               sizeType: .one2one,
                                               colorType: .black,
                                               font: .나눔명조,
                                               textAlignment: .왼쪽)
    internal func setBookCardModel(_ cardModel: CardModel) {
        let colorType = MakeCard_StickerBackColorType.allCases.first(where: { $0.name == cardModel.colorImageName}) ?? .black
        let fontType = 폰트.allCases.first(where: { $0.rawValue == cardModel.font }) ?? .나눔명조
        let textAlignType = 텍스트정렬.allCases.first(where: { $0.rawValue == cardModel.textAlignment }) ?? .왼쪽
        self.bookCardModel = BookCardModel(content: cardModel.lineValue,
                                           book: BookModel(title: cardModel.bookName,
                                                           name: cardModel.authorName,
                                                           isbn: cardModel.bookIsbn),
                                           sizeType: cardModel.ratioType ?? MakeCard_StickerRatioType.one2one,
                                           colorType: colorType,
                                           font: fontType,
                                           textAlignment: textAlignType)
    }
    internal var searchModel = BookSearchModel(page: 1,
                                               searchStr: nil)
    internal var readTextStep = ReadTextStep.start
    internal var capturedImage: UIImage?
    internal var isEnded: Bool = false
    internal var sticker: UIImage? {
        didSet { RealmController.shared.write(self.getRealmModel()) }
    }
    
    internal var param: [String: Any?] {
        return bookCardModel.getParam()
    }
    internal func getPutParam(id: String) -> [String: Any?] {
        return bookCardModel.getPutParam(id: id)
    }
    
    func initialize() {
        readTextStep = ReadTextStep.start
        capturedImage = nil
        bookCardModel = BookCardModel(content: nil,
                                      book: BookModel(),
                                      sizeType: .one2one,
                                      colorType: .black,
                                      font: .나눔명조,
                                      textAlignment: .왼쪽)
    }
    
    func getRealmModel() -> CardModel_Realm {
        return CardModel_Realm(bookName: bookCardModel.book?.title,
                               authorName: bookCardModel.book?.name,
                               bookIsbn: bookCardModel.book?.isbn,
                               lineValue: bookCardModel.content,
                               color: bookCardModel.colorType.name,
                               ratioTypeRawValue: bookCardModel.sizeType.rawValue,
                               font: bookCardModel.font.rawValue,
                               textAlignment: bookCardModel.textAlignment.rawValue)
    }
}

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

struct BookSearchModel {
    var page = 1
    var searchStr: String?
    mutating func updateStr(_ str: String?) {
        self.searchStr = str
    }
}

struct BookModel {
    var title: String?
    var name: String?
    var isbn: String?
    mutating func setTitle(_ str: String?) {
        self.title = str
    }
    mutating func setName(_ str: String?) {
        self.name = str
    }
    mutating func setIsbn(_ str: String?) {
        self.isbn = str
    }
    internal func getParam() -> [String: String?] {
        return [
            "title": title,
            "name": name,
            "isbn": isbn
        ]
    }
    internal var info: String {
        var rtnVal = ""
        if let bookName = title {
            rtnVal += bookName + ","
        }
        if let authorName = name {
            rtnVal += authorName
        }
        return rtnVal
    }
}

enum 폰트: String, CaseIterable {
    case 나눔명조 = "NanumMyeongjo"
    case 본고딕 = "NotoSansKR"
    case 나눔스퀘어 = "NanumSquareNeo"
    case 고운돋움 = "GowunDodum"
    case 나눔손글씨 = "NanumURiDdarSonGeurSsi"
    
    var val: UIFont {
        switch self {
        case .나눔명조:
            return UIFont(name: "NanumMyeongjo-YetHangul", size: 16)!
        case .본고딕:
            return UIFont(name: "NotoSansNKo-Regular", size: 16)!
        case .나눔스퀘어:
            return UIFont(name: "NanumSquareNeoTTF-bRg", size: 16)!
        case .고운돋움:
            return UIFont(name: "GowunDodum-Regular", size: 16)!
        case .나눔손글씨:
            return UIFont(name: "NanumURiDdarSonGeurSsi", size: 16)!
        }
    }
}

enum 텍스트정렬: String, CaseIterable {
    case 왼쪽 = "TextAlignmentLeft"
    case 중앙 = "TextAlignmentCenter"
    case 오른쪽 = "TextAlignmentRight"
    var inactiveImgName: String {
        switch self {
        case .왼쪽:
            return "카드_텍스트정렬_왼쪽_비활성화"
        case .중앙:
            return "카드_텍스트정렬_중앙_비활성화"
        case .오른쪽:
            return "카드_텍스트정렬_오른쪽_비활성화"
        }
    }
    var activeImgName: String {
        switch self {
        case .왼쪽:
            return "카드_텍스트정렬_왼쪽_활성화"
        case .중앙:
            return "카드_텍스트정렬_중앙_활성화"
        case .오른쪽:
            return "카드_텍스트정렬_오른쪽_활성화"
        }
    }
    var textAlign: NSTextAlignment {
        switch self {
        case .왼쪽:
            return .left
        case .중앙:
            return .center
        case .오른쪽:
            return .right
        }
    }
}
