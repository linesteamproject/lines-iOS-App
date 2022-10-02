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
    private weak var emptyLabel: UILabel!
    private weak var bottomView: MarkCard_BottomView!
    private weak var topNextAnchor: NSLayoutYAxisAnchor!

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchedTypeView.endEditing(true)
    }
    
    override func setTopView() {
        let topView = MakeCard_TopView()
        self.view.addSubviews(topView)
        NSLayoutConstraint.activate([
            topView.topAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topView.leftAnchor
                    .constraint(equalTo: self.view.leftAnchor),
            topView.rightAnchor
                    .constraint(equalTo: self.view.rightAnchor),
            topView.heightAnchor
                    .constraint(equalToConstant: topViewHeight)
        ])
        topView.closeClosure = {
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
            tbAlertView.closure = { [weak self] in
                ReadTextController.shared.initialize()
                self?.navigationController?.popToRootViewController(animated: true)
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
            back.heightAnchor.constraint(equalToConstant: 55)
        ])
        back.backgroundColor = Colors.gray222222.value
        
        let label = UILabel()
        back.addSubviews(label)
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: back.bottomAnchor, constant: -6.5),
            label.centerXAnchor.constraint(equalTo: back.centerXAnchor)
        ])
        label.textAlignment = .center
        label.setTitle("📖 어떤 책에서 발견한 문장인가요?",
                       font: Fonts.get(size: 16, type: .regular),
                       txtColor: .beige)
        topNextAnchor = back.bottomAnchor
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
             self?.present(vc, animated: true)
        }, for: .touchUpInside)
        btn.isHidden = true
        searchedTypeView.typeClosure = { [weak self] type in
            MakeCard_KakaoBookSearcher.type = type
            btn.isHidden = !(type == .barcode)
            ReadTextController.shared.page = 1
            ReadTextController.shared.isEnded = false
            self?.searchedListView.isLoading = true
            self?.searchedListView.list.removeAll()
            self?.searchedListView.isLoading = false
        }
        
        searchedTypeView.searchClosure = { [weak self] in
            guard let str = ReadTextController.shared.searchedStr else { return }
            ReadTextController.shared.page = 1
            ReadTextController.shared.isEnded = false
            self?.searchedListView.list.removeAll()
            self?.getBookInfo(str)
        }
        searchedTypeView.delegate = self
        self.searchedTypeView = searchedTypeView
        self.topNextAnchor = searchedTypeView.bottomAnchor
    }
    
    internal func getBookInfo(_ str: String) {
        let dic: [String: Any]
        switch MakeCard_KakaoBookSearcher.type {
        case .bookName:
            dic = MakeCard_KakaoBookSearcher.byName(str)
        case .author:
            dic = MakeCard_KakaoBookSearcher.byAuthor(str)
        default:
            dic = MakeCard_KakaoBookSearcher.byISBN(str)
        }
        guard !dic.isEmpty else { return }
        
        DispatchQueue.global().async { [weak self] in
            AFHandler.searchBook(by: dic) {
                guard let status = $0,
                      let isEnded = status.meta?.isEnd,
                      let documents = status.documents,
                        !documents.isEmpty
                else {
                    self?.emptyLabel.isHidden = false
                    return
                    
                }
                self?.emptyLabel.isHidden = true
                ReadTextController.shared.isEnded = isEnded
                self?.searchedListView.list.append(contentsOf: documents)
                self?.searchedListView.isLoading = false
            }
        }
    }
    
    private func setSearchedListView() {
        let searchedListView = MakeCard_SearchedListView()
        let label = UILabel()
        self.contentView.addSubviews(searchedListView, label)
        NSLayoutConstraint.activate([
            searchedListView.topAnchor.constraint(equalTo: topNextAnchor),
            searchedListView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                    constant: -34 + -34 + -90),
            searchedListView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            searchedListView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            searchedListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                                    constant: -34 + -34 + -90),
            
            label.centerXAnchor.constraint(equalTo: searchedListView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: searchedListView.centerYAnchor)
        ])
        label.setTitle("검색결과가 없습니다",
                       font: Fonts.get(size: 14, type: .regular),
                       txtColor: .gray777777)
        label.isHidden = true
        self.emptyLabel = label
        searchedListView.delegate = self
        searchedListView.pageClosure = { [weak self] in
            guard !ReadTextController.shared.isEnded else { return }
            ReadTextController.shared.page += 1
            
            guard let str = ReadTextController.shared.searchedStr else { return }
            self?.getBookInfo(str)
        }
        self.searchedListView = searchedListView
        topNextAnchor = searchedListView.bottomAnchor
    }

    private func setBottomView() {
        let bottomView = MarkCard_BottomView(leftButtonTitle: "이전 단계")
        self.view.addSubviews(bottomView)
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -34 + -34),
            bottomView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 90)
        ])
        bottomView.leftBtnClosure = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        bottomView.rightBtnClosure = { [weak self] in
            guard !ReadTextController.shared.bookInfo.isEmpty else { return }
            
            let vc = MakeCard_CompleteViewController()
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        bottomView.isRightActive = false
        self.bottomView = bottomView
    }
}

extension MakeCard_SearchBookViewController: ButtonDelegate {
    func touched(_ obj: Any?) {
        if let obj = obj as? BookDocu {
            ReadTextController.shared.bookName = obj.bookName
            ReadTextController.shared.authorName = obj.authorsStr
            ReadTextController.shared.bookIsbn = obj.isbn
            bottomView.isRightActive = true
        }
    }
}

extension MakeCard_SearchBookViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
