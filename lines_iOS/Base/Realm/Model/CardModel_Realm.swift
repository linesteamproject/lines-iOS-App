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
    let bookIsbn: String?
    let lineValue: String?
    let colorImageName: String?
    let ratioType: MakeCard_StickerRatioType?
    
    var param: [String: String?] {
        return [
            "content": self.lineValue,
            "isbn": self.bookIsbn,
            "ratio": self.ratioType?.typeStr,
            "background": self.colorImageName
        ]
    }
}

class CardModel_Realm: Object {
    @Persisted var bookName: String?
    @Persisted var authorName: String?
    @Persisted var bookIsbn: String?
    @Persisted var lineValue: String?
    @Persisted var color: String?
    @Persisted var ratioTypeRawValue: Int?
    
    convenience init(bookName: String?,
                     authorName: String?,
                     bookIsbn: String?,
                     lineValue: String?,
                     color: String?,
                     ratioTypeRawValue: Int?) {
        self.init()
        self.bookName = bookName
        self.authorName = authorName
        self.bookIsbn = bookIsbn
        self.lineValue = lineValue
        self.color = color
        self.ratioTypeRawValue = ratioTypeRawValue
    }
    
    func getCardModel() -> CardModel {
        return CardModel(bookName: self.bookName,
                         authorName: self.authorName,
                         bookIsbn: self.bookIsbn,
                         lineValue: self.lineValue,
                         colorImageName: color,
                         ratioType: MakeCard_StickerRatioType(rawValue: self.ratioTypeRawValue ?? 0))
    }
}
