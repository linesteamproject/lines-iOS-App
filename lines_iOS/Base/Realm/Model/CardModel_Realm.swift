//
//  CardModel.swift
//  lines_iOS
//
//  Created by mun on 2022/09/01.
//

import RealmSwift

struct CardModel {
    let id: String?
    let bookName: String?
    let authorName: String?
    let bookIsbn: String?
    let lineValue: String?
    let colorImageName: String?
    let ratioType: MakeCard_StickerRatioType?
    let font: String?
    let textAlignment: String?
    var bookInfo: String {
        var rtnVal = ""
        if let bookName = bookName {
            rtnVal += bookName + ","
        }
        if let authorName = authorName {
            rtnVal += authorName
        }
        return rtnVal
    }
    
    var param: [String: Any?] {
        return [
            "content": self.lineValue,
            "isbn": self.bookIsbn,
            "ratio": self.ratioType?.typeStr,
            "background": self.colorImageName,
            "book": [
                "title": self.bookName,
                "name": self.authorName,
                "isbn": self.bookIsbn
            ],
            "font": self.font,
            "textAlignment": self.textAlignment
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
    @Persisted var font: String?
    @Persisted var textAlignment: String?
    convenience init(bookName: String?,
                     authorName: String?,
                     bookIsbn: String?,
                     lineValue: String?,
                     color: String?,
                     ratioTypeRawValue: Int?,
                     font: String?,
                     textAlignment: String?) {
        self.init()
        self.bookName = bookName
        self.authorName = authorName
        self.bookIsbn = bookIsbn
        self.lineValue = lineValue
        self.color = color
        self.ratioTypeRawValue = ratioTypeRawValue
        self.font = font
        self.textAlignment = textAlignment
    }
    
    func getCardModel() -> CardModel {
        return CardModel(id: "",
                         bookName: self.bookName,
                         authorName: self.authorName,
                         bookIsbn: self.bookIsbn,
                         lineValue: self.lineValue,
                         colorImageName: color,
                         ratioType: MakeCard_StickerRatioType(rawValue:
                                                                self.ratioTypeRawValue ?? 0),
                         font: self.font,
                         textAlignment: self.textAlignment)
    }
}
