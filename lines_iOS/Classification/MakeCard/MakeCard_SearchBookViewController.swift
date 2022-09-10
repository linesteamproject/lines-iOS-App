//
//  SearchBookViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation
import UIKit

class MakeCard_SearchBookViewController: ScrollViewController {
    override var topViewHeight: CGFloat {
        get { return 56 }
        set { }
    }
    private weak var searchedTypeView: MakeCard_SearchedTypeView!
    private weak var searchedListView: MakeCard_SearchedListView!
    private weak var topNextAnchor: NSLayoutYAxisAnchor!
    override func setTopView() {
        let topView = MakeCard_TopView()
        self.view.addSubviews(topView)
        NSLayoutConstraint.activate([
            topView.topAnchor
                    .constraint(equalTo: self.view.topAnchor,
                                constant: 35),
            topView.leftAnchor
                    .constraint(equalTo: self.view.leftAnchor),
            topView.rightAnchor
                    .constraint(equalTo: self.view.rightAnchor),
            topView.heightAnchor
                    .constraint(equalToConstant: topViewHeight)
        ])
        topView.closeClosure = { [weak self] in
            setTwoButtonAlertView()
        }
        self.topView = topView
        
        func setTwoButtonAlertView() {
            let tbAlertView = TwoButtonAlertView()
            self.view.addSubviews(tbAlertView)
            NSLayoutConstraint.activate([
                tbAlertView.topAnchor.constraint(equalTo: self.view.topAnchor),
                tbAlertView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                tbAlertView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                tbAlertView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
            tbAlertView.title = "문장 기록 나가기"
            tbAlertView.subTitle = "문장 기록 페이지에서 나가시겠습니까?\n진행중이던 내용이 모두 버려집니다."
            tbAlertView.closure = {
                ReadTextController.shared.initialize()
                dismissViewControllerUntil(vcID: MainViewController.id)
            }
        }
    }
    
    override func setAdditionalUI() {
        setAskView()
        setSearchedTypeView()
        setSearchedListView()
        setBottomView()
    }
    
    private func setAskView() {
        let back = UIView()
        self.contentView.addSubviews(back)
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: contentView.topAnchor),
            back.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            back.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            back.heightAnchor.constraint(equalToConstant: 87)
        ])
        self.topNextAnchor = back.bottomAnchor
        
        let imageView = UIImageView(image: UIImage(named: "WhereDidYouFind"))
        back.addSubviews(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            imageView.leftAnchor.constraint(equalTo: back.leftAnchor,
                                            constant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 27)
        ])
        imageView.contentMode = .scaleAspectFit
    }
    
    private func setSearchedTypeView() {
        let searchedTypeView = MakeCard_SearchedTypeView()
        self.contentView.addSubviews(searchedTypeView)
        NSLayoutConstraint.activate([
            searchedTypeView.topAnchor
                            .constraint(equalTo: topNextAnchor),
            searchedTypeView.leftAnchor
                            .constraint(equalTo: contentView.leftAnchor),
            searchedTypeView.rightAnchor
                            .constraint(equalTo: contentView.rightAnchor),
            searchedTypeView.heightAnchor
                            .constraint(equalToConstant: 146),
        ])
        
        let btn = MakeCard_BarcodeSearchButton()
        searchedTypeView.addSubviews(btn)
        NSLayoutConstraint.activate([
            btn.bottomAnchor.constraint(equalTo: searchedTypeView.bottomAnchor,
                                        constant: -19),
            btn.leftAnchor.constraint(equalTo: searchedTypeView.leftAnchor,
                                     constant: 20),
            btn.rightAnchor.constraint(equalTo: searchedTypeView.rightAnchor,
                                      constant: -20),
            btn.heightAnchor.constraint(equalToConstant: 50)
        ])
        btn.addAction(UIAction { [weak self] _ in
            let vc = MakeCard_BarcodeViewController()
             vc.modalPresentationStyle = .overFullScreen
             self?.present(vc, animated: false)
        }, for: .touchUpInside)
        btn.isHidden = true
        searchedTypeView.typeClosure = { type in
            MakeCard_KakaoBookSearcher.type = type
            btn.isHidden = !(type == .barcode)
        }
        
        searchedTypeView.searchClosure = { [weak self] str in
            guard let str = str else { return }
            
            self?.getBookInfo(str)
        }
        self.searchedTypeView = searchedTypeView
        self.topNextAnchor = searchedTypeView.bottomAnchor
    }
    
    internal func getBookInfo(_ str: String) {
        let dic: [String: String]
        switch MakeCard_KakaoBookSearcher.type {
        case .bookName:
            dic = MakeCard_KakaoBookSearcher.byName(str)
        case .author:
            dic = MakeCard_KakaoBookSearcher.byAuthor(str)
        default:
            dic = MakeCard_KakaoBookSearcher.byISBN(str)
        }
        guard !dic.isEmpty else { return }
        
        AFHandler.searchBook(by: dic) {
            guard let documents = $0?.documents else { return }
            self.searchedListView.list = documents
        }
    }
    
    private func setSearchedListView() {
        let searchedListView = MakeCard_SearchedListView()
        self.contentView.addSubviews(searchedListView)
        NSLayoutConstraint.activate([
            searchedListView.topAnchor.constraint(equalTo: topNextAnchor),
            searchedListView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                    constant: -34 + -34 + -90),
            searchedListView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            searchedListView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            searchedListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                                    constant: -34 + -34 + -90)
        ])
        searchedListView.delegate = self
        self.searchedListView = searchedListView
        topNextAnchor = searchedListView.bottomAnchor
    }

    private func setBottomView() {
        let bottomView = MarkCard_BottomView()
        self.view.addSubviews(bottomView)
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -34 + -34),
            bottomView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 90)
        ])
        bottomView.leftBtnClosure = { [weak self] in
            ReadTextController.shared.initialize()
            let vc = CameraViewController()
            vc.type = .camera
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(vc, animated: true)
            }
        }
        
        bottomView.rightBtnClosure = { [weak self] in
            guard ReadTextController.shared.bookInfo != nil else { return }
            
            let vc = MakeCard_CompleteViewController()
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(vc, animated: true)
            }
        }
    }
}

extension MakeCard_SearchBookViewController: ButtonDelegate {
    func touched(_ obj: Any?) {
        if let obj = obj as? BookDocu {
            ReadTextController.shared.bookName = obj.bookName
            ReadTextController.shared.authorName = obj.authorsStr
        }
        
    }
}
