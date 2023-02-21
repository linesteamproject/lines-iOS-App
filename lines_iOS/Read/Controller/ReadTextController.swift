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
