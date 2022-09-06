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
    let backImageName: String?
    let ratioType: MakeCard_StickerRatioType?
}

class CardModel_Realm: Object {
    @Persisted var bookName: String?
    @Persisted var authorName: String?
    @Persisted var lineValue: String?
    @Persisted var backImageName: String?
    @Persisted var ratioTypeRawValue: Int?
    
    convenience init(bookName: String?,
                     authorName: String?,
                     lineValue: String?,
                     backImageName: String?,
                     ratioTypeRawValue: Int?) {
        self.init()
        self.bookName = bookName
        self.authorName = authorName
        self.lineValue = lineValue
        self.backImageName = backImageName
        self.ratioTypeRawValue = ratioTypeRawValue
    }
    
    func getCardModel() -> CardModel {
        return CardModel(bookName: self.bookName,
                         authorName: self.authorName,
                         lineValue: self.lineValue,
                         backImageName: backImageName,
                         ratioType: MakeCard_StickerRatioType(rawValue: self.ratioTypeRawValue ?? 0))
    }
}
