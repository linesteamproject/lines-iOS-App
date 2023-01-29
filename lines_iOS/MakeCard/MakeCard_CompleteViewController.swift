//
//  MakeCard_CompleteViewController.swift
//  lines_iOS
//
//  Created by MunYong HEO on 2022/08/29.
//

import UIKit

class MakeCard_CompleteViewController: ScrollViewController {
    override var topViewHeight: CGFloat {
        get { return 56 }
        set { }
    }
    private weak var stickerBackView: UIView!
    private weak var stickerView: MakeCard_StickerView!
    private weak var nextTopAnchor: NSLayoutYAxisAnchor!
    
    private var cardId: Int?
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
        topView.closeClosure = { [weak self] in
            ReadTextController.shared.initialize()
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
        self.topView = topView
    }
    
    override func setAdditionalUI() {
        setTitleView()
        setStickerBackView()
        setStickerView(ReadTextController.shared.bookCardModel.sizeType)
        setShareButtons()
        setBottomView()
    }
    
    private func setTitleView() {
        let titleLabel = UILabel()
        let subTitleLabel = UILabel()
        self.contentView.addSubviews(titleLabel, subTitleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 42),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subTitleLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor)
        ])
        titleLabel.setTitle("문장을 기록했어요!",
                            font: Fonts.get(size: 22, type: .bold),
                            txtColor: .white)
        subTitleLabel.setTitle("소중한 사람들과 함께 영감을 공유해보세요.",
                               font: Fonts.get(size: 14, type: .regular),
                               txtColor: .white)
        self.nextTopAnchor = subTitleLabel.bottomAnchor
    }
    
    private func setStickerBackView() {
        let back = UIView()
        self.contentView.addSubviews(back)
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: nextTopAnchor, constant: 30),
            back.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            back.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
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
        
        self.stickerView.color = ReadTextController.shared.bookCardModel.colorType
        
        func setOne2One() {
            let stickerView = MakeCard_StickerOneToOneView(ReadTextController.shared.bookCardModel.content)
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
            stickerView.bookInfoStr = ReadTextController.shared.bookCardModel.book?.info
            stickerView.font = ReadTextController.shared.bookCardModel.font
            stickerView.textAlignment = ReadTextController.shared.bookCardModel.textAlignment
            if FirstLaunchChecker.isNotLogin {
                ReadTextController.shared.sticker = ShareController.shared.makeImage(stickerView)
            } else {
                DispatchQueue.global().async { [weak self] in
                    AFHandler.saveCardData(done: {
                        guard let cardResponse = $0 else { return }
                        self?.cardId = cardResponse.id
                    })
                }
            }
            self.stickerView = stickerView
        }
        
        func setThree2Four() {
            let stickerView = MakeCard_StickerThreeToFourView(ReadTextController.shared.bookCardModel.content)
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
            stickerView.bookInfoStr = ReadTextController.shared.bookCardModel.book?.info
            stickerView.font = ReadTextController.shared.bookCardModel.font
            stickerView.textAlignment = ReadTextController.shared.bookCardModel.textAlignment
            if FirstLaunchChecker.isNotLogin {
                ReadTextController.shared.sticker = ShareController.shared.makeImage(stickerView)
            } else {
                DispatchQueue.global().async { [weak self] in
                    AFHandler.saveCardData(done: {
                        guard let cardResponse = $0 else { return }
                        self?.cardId = cardResponse.id
                    })
                }
            }
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
                        .constraint(equalTo: self.contentView.centerXAnchor),
            shareBtnsView.widthAnchor.constraint(equalToConstant: 234),
            shareBtnsView.heightAnchor.constraint(greaterThanOrEqualToConstant: 83),
            shareBtnsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -141)
        ])
        shareBtnsView.shareInstaClosure = {
            self.showLoadingView()
//            ShareController.shared.shareOnInstagram(self.stickerView)
            
            DispatchQueue.global().async { [weak self] in
                let cardId = String(self?.cardId ?? 0)
                AFHandler.shareCardLog(id: cardId) {
                    print($0)
                }
            }
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
            DispatchQueue.global().async { [weak self] in
                let cardId = String(self?.cardId ?? 0)
                AFHandler.shareCardLog(id: cardId) {
                    print($0)
                }
            }
            
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
        let bottomBtnView = MakeCard_GoToHomeButtonView()
        self.view.addSubviews(bottomBtnView)
        NSLayoutConstraint.activate([
            bottomBtnView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -34 + -31),
            bottomBtnView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bottomBtnView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bottomBtnView.heightAnchor.constraint(equalToConstant: 90)
        ])
        bottomBtnView.goToHomeClosure = { [weak self] in
            ReadTextController.shared.initialize()
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

