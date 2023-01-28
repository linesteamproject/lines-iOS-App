//
//  RecentRegisterBookListModel.swift
//  lines_iOS
//
//  Created by mun on 2023/01/28.
//

import Foundation

struct RecentRegisterBookListModel {
    var bookInfoList: [BookInfo]
    mutating func setImgUrl(isbn: String, urlStr: String) {
        guard let idx = bookInfoList.firstIndex(where: { $0.isbn.contains(isbn) })
        else { return }
        self.bookInfoList[idx].bookImgUrlStr = urlStr
    }
}
