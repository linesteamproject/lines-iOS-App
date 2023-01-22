//
//  MakeCard_KakaoBookSearcher.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation

class MakeCard_KakaoBookSearcher {
    static var type: MakeCard_SearchButtonType = .bookName
    class func byName(_ bookName: String) -> [String: Any] {
        return ["query":bookName,
                "target":"title",
                "page": ReadTextController.shared.searchModel.page]
    }
    class func byISBN(_ isbn: String) -> [String: Any] {
        return ["query":isbn,
                "target":"isbn",
                "page": ReadTextController.shared.searchModel.page]
    }
    class func byAuthor(_ person: String) -> [String: Any] {
        return ["query":person,
                "target":"person",
                "page": ReadTextController.shared.searchModel.page]
    }
}
