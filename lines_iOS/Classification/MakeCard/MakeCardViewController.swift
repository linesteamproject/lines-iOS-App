//
//  MakeCardViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/08/13.
//

import UIKit

class MakeCardViewController: ScrollViewController {
    internal weak var cardContentView: MakeCard_ContentView!
    private weak var bottomView: MarkCard_BottomView!
    override var topViewHeight: CGFloat {
        get { return 56 }
        set { }
    }
    internal var noticeStr: String = "인식한 문장을 확인해 주세요.\n줄바꿈, 오타 등을 직접 수정해 주세요."
    internal weak var nextTopAnchor: NSLayoutYAxisAnchor!
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
            self?.setTwoButtonAlertView()
        }
        self.topView = topView
    }
    
    private func setTwoButtonAlertView() {
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
    
    override func setAdditionalUI() {
        self.nextTopAnchor = self.contentView.topAnchor
        setNoticeView()
        setContentView()
        setContentNoticeView()
        setBottomView()
    }
    
    private func setNoticeView() {
        let noticeView = MakeCard_NoticeView(ReadTextController.shared.capturedImage)
        self.contentView.addSubviews(noticeView)
        NSLayoutConstraint.activate([
            noticeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            noticeView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            noticeView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            noticeView.heightAnchor.constraint(equalToConstant: 117)
        ])
        noticeView.showImgClosure = { [weak self] image in
            guard let view = self?.view else { return }
            
            let alert = ImageAlertView()
            view.addSubviews(alert)
            NSLayoutConstraint.activate([
                alert.topAnchor.constraint(equalTo: view.topAnchor),
                alert.leftAnchor.constraint(equalTo: view.leftAnchor),
                alert.rightAnchor.constraint(equalTo: view.rightAnchor),
                alert.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            alert.image = ReadTextController.shared.capturedImage
        }
        
        noticeView.noticeStr = self.noticeStr
        self.nextTopAnchor = noticeView.bottomAnchor
    }
    
    internal func setContentView() {
        let cardContentView = MakeCard_ContentView(ReadTextController.shared.readText)
        self.contentView.addSubviews(cardContentView)
        NSLayoutConstraint.activate([
            cardContentView.topAnchor.constraint(equalTo: nextTopAnchor),
            cardContentView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            cardContentView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            cardContentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 274),
        ])
        cardContentView.isTxtViewEmptyClosure = { [weak self] isEmptyContent in
            self?.bottomView.isRightActive = !isEmptyContent
        }
        self.cardContentView = cardContentView
        self.nextTopAnchor = cardContentView.bottomAnchor
    }
    
    private func setContentNoticeView() {
        let contentNoticeView = MainCard_ContentNoticeView()
        self.contentView.addSubviews(contentNoticeView)
        NSLayoutConstraint.activate([
            contentNoticeView.topAnchor.constraint(equalTo: nextTopAnchor),
            contentNoticeView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            contentNoticeView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            contentNoticeView.heightAnchor.constraint(equalToConstant: 92),
            contentNoticeView.bottomAnchor
                            .constraint(lessThanOrEqualTo: self.contentView
                                                                .bottomAnchor,
                                        constant: -225)
        ])
        self.nextTopAnchor = contentNoticeView.bottomAnchor
    }
    
    internal func setBottomView() {
        let bottomView = MarkCard_BottomView()
        self.contentView.addSubviews(bottomView)
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -34),
            bottomView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 90)
        ])
        bottomView.leftBtnClosure = { [weak self] in
            ReadTextController.shared.initialize()
            let vc = CameraViewController()
            vc.type = .camera
            vc.modalPresentationStyle = .fullScreen
            ReadTextController.shared.capturedImage = nil
            DispatchQueue.main.async {
                self?.present(vc, animated: true)
            }
        }
        bottomView.rightBtnClosure = { [weak self] in
            ReadTextController.shared.readText = self?.cardContentView.txtView.text ?? ""
            let vc = MakeCard_DetailViewController()
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: false)
        }
        
        if let readTxt = ReadTextController.shared.readText,
           !readTxt.isEmpty {
            bottomView.isRightActive = true
        } else {
            bottomView.isRightActive = false
        }
        self.bottomView = bottomView
    }
}
