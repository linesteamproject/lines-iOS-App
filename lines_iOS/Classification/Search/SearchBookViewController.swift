//
//  SearchBookViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation
import UIKit

enum ButtonType: String, CaseIterable {
    case bookName = "책 이름"
    case author = "작가"
    case isbn = "ISBN"
    case barcode = "바코드"
}

//AFHandler.searchBook(by: KakaoBookSearcher.byName("메타버스의 시대"), done: nil)
class SearchBookViewController: ViewController {
    private weak var searchedTypeView: SearchedTypeView!
    private weak var searchedListView: SearchedListView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchedTypeView()
        setSearchedListView()
    }
    
    private func setSearchedTypeView() {
        let searchedTypeView = SearchedTypeView()
        self.view.addSubviews(searchedTypeView)
        NSLayoutConstraint.activate([
            searchedTypeView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchedTypeView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            searchedTypeView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            searchedTypeView.heightAnchor.constraint(equalToConstant: 120),
        ])
        searchedTypeView.typeClosure = { type in
            guard type == .barcode else {
                KakaoBookSearcher.type = type
                return
            }
            let vc = BarcodeViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        searchedTypeView.searchClosure = { str in
            guard let str = str else { return }
            
            let dic: [String: String]
            switch KakaoBookSearcher.type {
            case .bookName:
                dic = KakaoBookSearcher.byName(str)
            case .author:
                dic = KakaoBookSearcher.byAuthor(str)
            case .isbn:
                dic = KakaoBookSearcher.byISBN(str)
            default:
                dic = [:]
            }
            guard !dic.isEmpty else { return }
            
            AFHandler.searchBook(by: dic) {
                guard let documents = $0?.documents else { return }
                self.searchedListView.list =  documents.compactMap { ($0.title ?? "제목 없음") + "/" + ($0.authors?.first ?? "작자 미상")}
            }
        }
        self.searchedTypeView = searchedTypeView
    }
    
    private func setSearchedListView() {
        let searchedListView = SearchedListView()
        self.view.addSubviews(searchedListView)
        NSLayoutConstraint.activate([
            searchedListView.topAnchor.constraint(equalTo: self.searchedTypeView.bottomAnchor,
                                                  constant: 20),
            searchedListView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            searchedListView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            searchedListView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            searchedListView.heightAnchor.constraint(greaterThanOrEqualToConstant: 400),
        ])
        self.searchedListView = searchedListView
    }
    
    internal func searchByBarcode(_ str: String) {
        searchedTypeView.searchedTxt = str
        let dic = KakaoBookSearcher.byISBN(str)
        AFHandler.searchBook(by: dic) {
            guard let documents = $0?.documents else { return }
            self.searchedListView.list =  documents.compactMap { ($0.title ?? "제목 없음") + "/" + ($0.authors?.first ?? "작자 미상")}
        }
    }
}
