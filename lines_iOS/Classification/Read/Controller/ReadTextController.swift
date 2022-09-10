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
            self.colorType = MakeCard_StickerBackColorType.allCases.first(where: {  cardModel?.backImageName?.contains($0.name) ?? false }) ?? .black
            self.bookName = cardModel?.bookName
            self.authorName = cardModel?.authorName
        }
    }
    internal var capturedImage: UIImage?
    internal var readText: String?
    internal var sizeType: MakeCard_StickerRatioType = .one2one
    internal var colorType: MakeCard_StickerBackColorType = .black
    internal var bookName: String?
    internal var authorName: String?
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
    func initialize() {
        capturedImage = nil
        readText = nil
    }
    func getRealmModel() -> CardModel_Realm {
        return CardModel_Realm(bookName: self.bookName,
                               authorName: self.authorName,
                               lineValue: self.readText,
                               backImageName: sizeType.imgName + colorType.name,
                               ratioTypeRawValue: self.sizeType.rawValue)
    }
}
