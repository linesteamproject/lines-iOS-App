//
//  BookModel.swift
//  lines_iOS
//
//  Created by mun on 2023/02/21.
//

import Foundation

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
