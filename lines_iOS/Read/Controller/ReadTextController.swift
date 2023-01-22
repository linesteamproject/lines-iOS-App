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
    internal var bookCardModel = BookCardModel(content: nil,
                                               book: BookModel(),
                                               sizeType: .one2one,
                                               colorType: .black,
                                               font: .나눔명조,
                                               textAlignment: .왼쪽)
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
          "textAlignment": textAlignment.rawValue,
          "memberId": 0
        ]
    }
    
    mutating func updateContent(_ str: String?) {
        guard let str = str else {
            self.content = str
            return
        }
        guard str.count > 110 else {
            self.content = str
            return
        }
        
        let startIndex = str.index(str.startIndex, offsetBy: 0) // 사용자지정 시작인덱스
        let endIndex = str.index(str.startIndex, offsetBy: 110) // 사용자지정 끝인덱스
        let slicedStr = str[startIndex ..< endIndex]
        self.content = String(slicedStr)
    }
    mutating func updateSizeType(_ type: MakeCard_StickerRatioType) {
        self.sizeType = type
    }
    mutating func updateColorType(_ type: MakeCard_StickerBackColorType) {
        self.colorType = type
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

enum 폰트: String {
    case 나눔명조 = "NanumMyeongjo"
    case 본고딕 = "NotoSansKR"
    case 나눔스퀘어 = "NanumSquareNeo"
    case 고운돋움 = "GowunDodum"
    case 나눔손글씨 = "NanumURiDdarSonGeurSsi"
}

enum 텍스트정렬: String {
    case 왼쪽 = "TextAlignmentLeft"
    case 중앙 = "TextAlignmentCenter"
    case 오른쪽 = "TextAlignmentRight"
}
