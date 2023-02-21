//
//  BookSearchModel.swift
//  lines_iOS
//
//  Created by mun on 2023/02/21.
//

import Foundation

struct BookSearchModel {
    var page = 1
    var searchStr: String?
    mutating func updateStr(_ str: String?) {
        self.searchStr = str
    }
}
