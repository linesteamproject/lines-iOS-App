//
//  SearchBookStatus.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation

struct SearchBookStatus: Codable {
    let meta: BookMeta?
    let documents: [BookDocu]?
}

// MARK: - Document
struct BookDocu: Codable {
    let authors: [String]?
    let contents, datetime, isbn: String?
    let price: Int?
    let publisher: String?
    let salePrice: Int?
    let status: String?
    let thumbnail: String?
    let title: String?
    let translators: [String]?
    let url: String?
    var authorsStr: String {
        get {
            var rtnVal = ""
            guard let authors = authors else {
                rtnVal += ", 작자미상"
                return rtnVal
            }
            rtnVal += ", "
            authors.forEach {
                rtnVal += $0 + ","
            }
            rtnVal.removeLast()
            return rtnVal
        }
    }
    var bookName: String {
        return self.title ?? "제목없음"
    }
    enum CodingKeys: String, CodingKey {
        case authors, contents, datetime, isbn, price, publisher
        case salePrice = "sale_price"
        case status, thumbnail, title, translators, url
    }
}

// MARK: - Meta
struct BookMeta: Codable {
    let isEnd: Bool?
    let pageableCount, totalCount: Int?

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
