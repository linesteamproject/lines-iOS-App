//
//  Main_CardDetailViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/09/11.
//

import UIKit

class Main_CardDetailViewController: ScrollViewController {
    private weak var nextTopAnchor: NSLayoutYAxisAnchor!
    private weak var stickerBackView: UIView!
    private weak var stickerView: MakeCard_StickerView!
    override func setAdditionalUI() {
        self.navigationController?.isNavigationBarHidden = true
        nextTopAnchor = contentView.topAnchor
        
        setStickerBackView()
        setStickerView(ReadTextController.shared.sizeType)
        setShareButtons()
        setBottomView()
    }
    
    override func setTopView() {
        let topView = Main_CardDetailTopView()
        self.view.addSubviews(topView)
        NSLayoutConstraint.activate([
            topView.topAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topView.leftAnchor
                    .constraint(equalTo: self.view.leftAnchor),
            topView.rightAnchor
                    .constraint(equalTo: self.view.rightAnchor),
            topView.heightAnchor
                    .constraint(greaterThanOrEqualToConstant: 56)
        ])
        topView.closeClosure = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        self.topView = topView
    }
    
    private func setStickerBackView() {
        let back = UIView()
        self.contentView.addSubviews(back)
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: nextTopAnchor, constant: 30),
            back.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            back.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            back.heightAnchor.constraint(equalToConstant: 375)
        ])
        back.backgroundColor = Colors.black.value
        self.stickerBackView = back
        self.nextTopAnchor = stickerBackView.bottomAnchor
    }
    
    private func setStickerView(_ type: MakeCard_StickerRatioType) {
        self.stickerView?.removeFromSuperview()
        
        switch type {
        case .one2one:
            setOne2One()
        case .three2Four:
            setThree2Four()
        }
        
        self.stickerView.color = ReadTextController.shared.colorType
        
        func setOne2One() {
            let stickerView = MakeCard_StickerOneToOneView(ReadTextController.shared.readText)
            self.stickerBackView.addSubviews(stickerView)
            NSLayoutConstraint.activate([
                stickerView.topAnchor.constraint(equalTo: stickerBackView.topAnchor,
                                                constant: 15),
                stickerView.centerXAnchor.constraint(equalTo: stickerBackView.centerXAnchor),
                stickerView.widthAnchor.constraint(equalToConstant: 345),
                stickerView.heightAnchor.constraint(equalToConstant: 345),
                stickerView.bottomAnchor.constraint(equalTo: stickerBackView.bottomAnchor,
                                                   constant: -15)
            ])
            stickerView.bookInfoStr = ReadTextController.shared.bookInfo
            self.stickerView = stickerView
        }
        
        func setThree2Four() {
            let stickerView = MakeCard_StickerThreeToFourView(ReadTextController.shared.readText)
            self.stickerBackView.addSubviews(stickerView)
            NSLayoutConstraint.activate([
                stickerView.topAnchor.constraint(equalTo: stickerBackView.topAnchor,
                                                constant: 15),
                stickerView.centerXAnchor.constraint(equalTo: stickerBackView.centerXAnchor),
                stickerView.widthAnchor.constraint(equalToConstant: 345 / 4 * 3),
                stickerView.heightAnchor.constraint(equalToConstant: 345),
                stickerView.bottomAnchor.constraint(equalTo: stickerBackView.bottomAnchor,
                                                   constant: -15)
            ])
            stickerView.bookInfoStr = ReadTextController.shared.bookInfo
            self.stickerView = stickerView
        }
    }
    
    private func setShareButtons() {
        let shareBtnsView = MakeCard_ShareButtonsView()
        self.contentView.addSubviews(shareBtnsView)
        NSLayoutConstraint.activate([
            shareBtnsView.topAnchor
                        .constraint(equalTo: nextTopAnchor,
                                    constant: 45),
            shareBtnsView.centerXAnchor
                        .constraint(equalTo: self.view.centerXAnchor),
            shareBtnsView.widthAnchor.constraint(equalToConstant: 234),
            shareBtnsView.heightAnchor.constraint(greaterThanOrEqualToConstant: 83)
        ])
        shareBtnsView.shareInstaClosure = {
            self.showLoadingView()
//            ShareController.shared.shareOnInstagram(self.stickerView)
            ShareController.shared.postImageToInstagram(self.stickerView) {
                self.hiddenLoadingView()
            }
        }
        shareBtnsView.downloadClosure = { [weak self] in
            ShareController.shared.downloadImage(self?.stickerView) {
                guard !$0 else {
                    DispatchQueue.main.async {
                        Toast.shared.message("이미지 저장 완료!")
                    }
                    return
                }
                DispatchQueue.main.async {
                    setTwoButtonAlertView()
                }
            }
            
            func setTwoButtonAlertView() {
                guard let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String else { return }
                let alert = UIAlertController(title: "접근 권한",
                                              message: appName + "의 앨범에 접근할 수 없어요.\n설정화면으로 이동할까요?",
                                              preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in }
                alert.addAction(cancelAction)
                let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
                alert.addAction(okAction)
                self?.present(alert, animated: true)
            }
        }
        shareBtnsView.shareAnotherClosure = { [weak self] in
            guard let selfView = self?.view,
                  let shareImg = ShareController.shared.makeImage(self?.stickerView)
            else { return }
            let shareObject: [UIImage] = [shareImg]
            
            let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = selfView
            activityViewController.excludedActivityTypes = [.airDrop, .message, .mail, .postToFacebook]
            DispatchQueue.main.async {
                self?.present(activityViewController, animated: true)
            }
        }
        self.nextTopAnchor = shareBtnsView.bottomAnchor
    }
    
    private func setBottomView() {
        let bottomView = MarkCard_BottomView(leftButtonTitle: "삭제하기",
                                             rightButtonTitle: "수정하기")
        self.contentView.addSubviews(bottomView)
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -34),
            bottomView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 90),
            bottomView.topAnchor.constraint(equalTo: nextTopAnchor, constant: 71)
        ])
        bottomView.leftBtnClosure = { [weak self] in
            // 삭제하기
        }
        bottomView.rightBtnClosure = { [weak self] in
            // 수정하기
            let pVC = Main_PopUpAlertViewController()
            pVC.modalPresentationStyle = .overFullScreen
            self?.present(pVC, animated: false)
        }
    }
}
