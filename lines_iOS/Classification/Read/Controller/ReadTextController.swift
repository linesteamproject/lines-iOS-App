//
//  CameraController.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation
import UIKit

class ReadTextController: NSObject {
    static let shared = ReadTextController()
    internal var cardModel: CardModel? {
        didSet {
            self.readText = cardModel?.lineValue
            self.sizeType = cardModel?.ratioType ?? .one2one
            self.colorType = MakeCard_StickerBackColorType.allCases.first(where: {  cardModel?.colorImageName?.contains($0.name) ?? false }) ?? .black
            self.bookName = cardModel?.bookName
            self.authorName = cardModel?.authorName
        }
    }
    internal var capturedImage: UIImage?
    internal var readText: String? {
        didSet {
            guard let readText = readText,
                  readText.count > 110
            else { return }
            
            let startIndex = readText.index(readText.startIndex, offsetBy: 0)// 사용자지정 시작인덱스
            let endIndex = readText.index(readText.startIndex, offsetBy: 110)// 사용자지정 끝인덱스
            let sliced_str = readText[startIndex ..< endIndex]
            print("munyong > \(sliced_str)")
            self.readText = String(sliced_str)
        }
    }
    internal var sizeType: MakeCard_StickerRatioType = .one2one
    internal var colorType: MakeCard_StickerBackColorType = .black
    internal var bookName: String?
    internal var authorName: String?
    internal var bookIsbn: String?
    internal var searchedStr: String?
    internal var page: Int = 1
    internal var bookInfo: String {
        var rtnVal = ""
        if let bookName = bookName {
            rtnVal += bookName + ","
        }
        if let authorName = authorName {
            rtnVal += authorName
        }
        return rtnVal
    }
    
    internal var sticker: UIImage? {
        didSet { RealmController.shared.write(self.getRealmModel()) }
    }
    
    internal var param: [String: String?] {
        return [
            "content": self.readText,
            "isbn": self.bookIsbn,
            "ratio": self.sizeType.typeStr,
            "background": self.colorType.name
        ]
    }
    
    func initialize() {
        capturedImage = nil
        readText = nil
        bookName = nil
        authorName = nil
        bookIsbn = nil
    }
    func getRealmModel() -> CardModel_Realm {
        return CardModel_Realm(bookName: self.bookName,
                               authorName: self.authorName,
                               bookIsbn: self.bookIsbn,
                               lineValue: self.readText,
                               color: colorType.name,
                               ratioTypeRawValue: self.sizeType.rawValue)
    }
}
