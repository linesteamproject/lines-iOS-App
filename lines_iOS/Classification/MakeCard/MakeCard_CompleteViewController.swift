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
        setStickerView(ReadTextController.shared.sizeType)
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
        titleLabel.setTitle("????????? ???????????????!",
                            font: Fonts.get(size: 22, type: .bold),
                            txtColor: .white)
        subTitleLabel.setTitle("????????? ???????????? ?????? ????????? ??????????????????.",
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
        
        self.stickerView.color = ReadTextController.shared.colorType
        
        func setOne2One() {
            let stickerView = MakeCard_StickerOneToOneView(ReadTextController.shared.slicedText)
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
            if FirstLaunchChecker.isNotLogin {
                ReadTextController.shared.sticker = ShareController.shared.makeImage(stickerView)
            } else {
                DispatchQueue.global().async {
                    AFHandler.saveCardData(done: {
                        print($0)
                    })
                }
            }
            self.stickerView = stickerView
        }
        
        func setThree2Four() {
            let stickerView = MakeCard_StickerThreeToFourView(ReadTextController.shared.slicedText)
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
            if FirstLaunchChecker.isNotLogin {
                ReadTextController.shared.sticker = ShareController.shared.makeImage(stickerView)
            } else {
                DispatchQueue.global().async {
                    AFHandler.saveCardData(done: {
                        print($0)
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
            ShareController.shared.postImageToInstagram(self.stickerView) {
                self.hiddenLoadingView()
            }
        }
        shareBtnsView.downloadClosure = { [weak self] in
            ShareController.shared.downloadImage(self?.stickerView) {
                guard !$0 else {
                    DispatchQueue.main.async {
                        Toast.shared.message("????????? ?????? ??????!")
                    }
                    return
                }
                DispatchQueue.main.async {
                    setTwoButtonAlertView()
                }
            }
            
            func setTwoButtonAlertView() {
                guard let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String else { return }
                let alert = UIAlertController(title: "?????? ??????",
                                              message: appName + "??? ????????? ????????? ??? ?????????.\n?????????????????? ????????????????",
                                              preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "??????", style: .cancel) { _ in }
                alert.addAction(cancelAction)
                let okAction = UIAlertAction(title: "??????", style: .default) { _ in
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
//            let vc = MainViewController()
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true)
        }
    }
}

