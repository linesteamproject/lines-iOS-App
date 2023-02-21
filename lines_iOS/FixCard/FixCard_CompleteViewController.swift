//
//  FixCard_CompleteViewController.swift
//  lines_iOS
//
//  Created by mun on 2023/01/22.
//

import UIKit

class FixCard_CompleteViewController: ScrollViewController {
    private weak var nextTopAnchor: NSLayoutYAxisAnchor!
    private weak var stickerBackView: UIView!
    private weak var stickerView: MakeCard_StickerView!
    internal var cardModel: CardModel?
    override func setAdditionalUI() {
        guard let cardModel = cardModel else { return }
        
        self.navigationController?.isNavigationBarHidden = true
        nextTopAnchor = contentView.topAnchor
        
        setStickerBackView()
        setStickerView(cardModel.ratioType ?? .one2one)
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
            self?.navigationController?.popToRootViewController(animated: true)
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
            back.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width*4/3)
        ])
        back.backgroundColor = Colors.black.value
        self.stickerBackView = back
        self.nextTopAnchor = stickerBackView.bottomAnchor
    }
    
    private func setStickerView(_ type: MakeCard_StickerRatioType) {
        self.stickerView?.removeFromSuperview()
        
        let widthConstant = UIScreen.main.bounds.width-30
        switch type {
        case .one2one:
            setOne2One()
        case .three2Four:
            setThree2Four()
        }
        
        self.stickerView.color = MakeCard_StickerBackColorType.allCases.first(where: {
            $0.name == cardModel?.colorImageName
        }) ?? .black
        
        func setOne2One() {
            let stickerView = MakeCard_StickerOneToOneView(cardModel?.lineValue ?? "")
            self.stickerBackView.addSubviews(stickerView)
            NSLayoutConstraint.activate([
                stickerView.topAnchor.constraint(equalTo: stickerBackView.topAnchor,
                                                constant: 15),
                stickerView.leftAnchor.constraint(equalTo: stickerBackView.leftAnchor,
                                                 constant: 15),
                stickerView.rightAnchor.constraint(equalTo: stickerBackView.rightAnchor,
                                                   constant: -15),
                stickerView.heightAnchor.constraint(equalToConstant: widthConstant),
                stickerView.bottomAnchor.constraint(equalTo: stickerBackView.bottomAnchor,
                                                   constant: -15)
            ])
            stickerView.bookInfoStr = cardModel?.bookInfo
            stickerView.font = 폰트(rawValue: cardModel?.font ?? 폰트.나눔명조.rawValue) ?? .나눔명조
            stickerView.textAlignment = 텍스트정렬(rawValue: cardModel?.textAlignment ?? 텍스트정렬.중앙.rawValue) ?? .중앙
            self.stickerView = stickerView
        }
        
        func setThree2Four() {
            let stickerView = MakeCard_StickerThreeToFourView(cardModel?.lineValue ?? "")
            self.stickerBackView.addSubviews(stickerView)
            NSLayoutConstraint.activate([
                stickerView.topAnchor.constraint(equalTo: stickerBackView.topAnchor,
                                                constant: 15),
                stickerView.leftAnchor.constraint(equalTo: stickerBackView.leftAnchor,
                                                 constant: 15),
                stickerView.rightAnchor.constraint(equalTo: stickerBackView.rightAnchor,
                                                   constant: -15),
                stickerView.heightAnchor.constraint(equalToConstant: widthConstant*4/3),
                stickerView.bottomAnchor.constraint(equalTo: stickerBackView.bottomAnchor,
                                                   constant: -15)
            ])
            stickerView.bookInfoStr = cardModel?.bookInfo
            stickerView.font = 폰트(rawValue: cardModel?.font ?? 폰트.나눔명조.rawValue) ?? .나눔명조
            stickerView.textAlignment = 텍스트정렬(rawValue: cardModel?.textAlignment ?? 텍스트정렬.중앙.rawValue) ?? .중앙
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
        bottomView.leftBtnClosure = {
            let tbAlertView = TwoButtonAlertView()
            self.view.addSubviews(tbAlertView)
            NSLayoutConstraint.activate([
                tbAlertView.topAnchor.constraint(equalTo: self.view.topAnchor),
                tbAlertView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                tbAlertView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                tbAlertView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
            tbAlertView.title = "문장 기록 삭제하기"
            tbAlertView.subTitle = "기록한 문장을 정말 삭제하시겠어요? :("
            tbAlertView.closure = { [weak self] in
                guard let id = self?.cardModel?.id
                else { return }
                AFHandler.deleteCardData(id: id, done: {
                    guard $0 == true else { return }
                    
                    Toast.shared.message("삭제되었습니다.")
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
                        self?.navigationController?.popToRootViewController(animated: true)
                    })
                })
            }
        }
        
        bottomView.rightBtnClosure = { [weak self] in
            // 수정하기
            let pVC = Main_PopUpAlertViewController()
            pVC.modalPresentationStyle = .overFullScreen
            pVC.textFixClosure = { [weak self] in
                pVC.dismiss(animated: true) {
                    guard let cardModel = self?.cardModel else {
                        return
                    }

                    let vc = FixCardViewController()
                    ReadTextController.shared.setBookCardModel(cardModel)
                    vc.modalPresentationStyle = .fullScreen
                    vc.cardId = self?.cardModel?.id
                    DispatchQueue.main.async {
                        self?.navigationController?.pushViewController(vc,
                                                                       animated: true)
                    }
                }
            }
            pVC.templeteFixClosure = { [weak self] in
                pVC.dismiss(animated: true) {
                    guard let cardModel = self?.cardModel else {
                        return
                    }

                    let vc = FixCard_DetailViewController()
                    ReadTextController.shared.setBookCardModel(cardModel)
                    vc.modalPresentationStyle = .fullScreen
                    vc.cardId = self?.cardModel?.id
                    DispatchQueue.main.async {
                        self?.navigationController?.pushViewController(vc,
                                                                       animated: true)
                    }
                }
            }
            self?.present(pVC, animated: false)
        }
    }
}
