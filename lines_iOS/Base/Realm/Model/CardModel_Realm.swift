//
//  CardModel.swift
//  lines_iOS
//
//  Created by mun on 2022/09/01.
//

import RealmSwift
struct CardModel {
    let bookName: String?
    let authorName: String?
    let lineValue: String?
    let backColor: MakeCard_StickerBackColorType?
    let ratioType: MakeCard_StickerRatioType?
    let imageData: Data?
}

class CardModel_Realm: Object {
    @Persisted var bookName: String?
    @Persisted var authorName: String?
    @Persisted var lineValue: String?
    @Persisted var backColorRawValue: Int?
    @Persisted var ratioTypeRawValue: Int?
    @Persisted var imageData: Data?
    
    convenience init(bookName: String?,
                     authorName: String?,
                     lineValue: String?,
                     backColorRawValue: Int?,
                     ratioTypeRawValue: Int?,
                     imageData: Data?) {
        self.init()
        self.bookName = bookName
        self.authorName = authorName
        self.lineValue = lineValue
        self.backColorRawValue = backColorRawValue
        self.ratioTypeRawValue = ratioTypeRawValue
        self.imageData = imageData
    }
    
    func getCardModel() -> CardModel {
        return CardModel(bookName: self.bookName,
                         authorName: self.authorName,
                         lineValue: self.lineValue,
                         backColor: MakeCard_StickerBackColorType(rawValue: self.backColorRawValue ?? 0),
                         ratioType: MakeCard_StickerRatioType(rawValue: self.ratioTypeRawValue ?? 0),
                         imageData: self.imageData)
    }
}
