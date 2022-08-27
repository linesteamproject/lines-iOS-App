//
//  MakeCardViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/08/13.
//

import UIKit

class MakeCardViewController: ScrollViewController {
    override var topViewHeight: CGFloat {
        get { return 56 }
        set { }
    }
    
    private weak var nextTopAnchor: NSLayoutYAxisAnchor!
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
        tbAlertView.closure = { 
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
        self.nextTopAnchor = noticeView.bottomAnchor
    }
    
    private func setContentView() {
        let cardContentView = MakeCard_ContentView(ReadTextController.shared.readText)
        self.contentView.addSubviews(cardContentView)
        NSLayoutConstraint.activate([
            cardContentView.topAnchor.constraint(equalTo: nextTopAnchor),
            cardContentView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            cardContentView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            cardContentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 274),
        ])
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
    
    private func setBottomView() {
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
            let vc = MakeCard_DetailViewController()
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: false)
        }
    }
}
