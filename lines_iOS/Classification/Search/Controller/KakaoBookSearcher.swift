//
//  KakaoBookSearcher.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation

class KakaoBookSearcher {
    static var type: ButtonType = .bookName
    class func byName(_ bookName: String) -> [String: String] {
        return ["query":bookName,
                "target":"title"]
    }
    class func byISBN(_ isbn: String) -> [String: String] {
        return ["query":isbn,
                "target":isbn]
    }
    class func byAuthor(_ person: String) -> [String: String] {
        return ["query":person,
                "target":person]
    }
}
