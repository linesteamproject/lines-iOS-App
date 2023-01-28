//
//  RecentRegisterBookListViewModel.swift
//  lines_iOS
//
//  Created by mun on 2023/01/28.
//

import Foundation

class RecentRegisterBookListViewModel {
    private var listModel: RecentRegisterBookListModel
    init(_ listModel: RecentRegisterBookListModel) {
        self.listModel = listModel
    }
    internal func getBookInfoDatas() -> [BookInfo] {
        return listModel.bookInfoList
    }
    
    internal func loadBookData(_ done: (() -> Void)?) {
        var crntCount: Int = 0
        listModel.bookInfoList.compactMap {
            $0.isbn.components(separatedBy: " ").last
        }.forEach { isbn in
            let dic = MakeCard_KakaoBookSearcher.byISBN(isbn)
            
            DispatchQueue.global().async { [weak self] in
                AFHandler.searchBook(by: dic) {
                    defer {
                        crntCount+=1;
                        if crntCount == self?.listModel.bookInfoList.count {
                            done?()
                        }
                    }
                    
                    guard let thumbnailUrlStr = $0?.documents?.first?.thumbnail
                    else { return }
                    
                    self?.listModel.setImgUrl(isbn: isbn,
                                              urlStr: thumbnailUrlStr)
                }
            }
        }
    }
}
