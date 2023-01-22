//
//  FixCard_DetailViewController.swift
//  lines_iOS
//
//  Created by mun on 2023/01/22.
//

import UIKit

class FixCard_DetailViewController: ScrollViewController {
    override var topViewHeight: CGFloat {
        get { return 56 }
        set { }
    }
    private weak var stickerBackView: UIView!
    private weak var stickerView: MakeCard_StickerView!
    
    internal var cardId: String?
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
        setStickerBackView()
        setStickerView(.one2one)
        setStickerSetView()
        setBottomView()
    }
    
    private func setStickerBackView() {
        let back = UIView()
        self.contentView.addSubviews(back)
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            back.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            back.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            back.heightAnchor.constraint(equalToConstant: 375)
        ])
        back.backgroundColor = Colors.gray222222.value
        self.stickerBackView = back
    }
    
    private func setStickerView(_ type: MakeCard_StickerRatioType) {
        self.stickerView?.removeFromSuperview()
        
        switch type {
        case .one2one:
            setOne2One()
        case .three2Four:
            setThree2Four()
        }
        ReadTextController.shared.bookCardModel.updateSizeType(type)
        
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
            stickerView.color = ReadTextController.shared.bookCardModel.colorType
            stickerView.font = ReadTextController.shared.bookCardModel.font
            stickerView.bookInfoStr = ReadTextController.shared.bookCardModel.book?.info
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
            stickerView.color = ReadTextController.shared.bookCardModel.colorType
            stickerView.font = ReadTextController.shared.bookCardModel.font
            stickerView.bookInfoStr = ReadTextController.shared.bookCardModel.book?.info
            self.stickerView = stickerView
        }
    }
    
    private func setStickerSetView() {
        let stickerSetView = MakeCard_StickerSetView()
        self.contentView.addSubviews(stickerSetView)
        NSLayoutConstraint.activate([
            stickerSetView.topAnchor.constraint(equalTo: stickerBackView.bottomAnchor),
            stickerSetView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            stickerSetView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            stickerSetView.heightAnchor.constraint(greaterThanOrEqualToConstant: 160),
            stickerSetView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                   constant: -139)
        ])
        
        stickerSetView.leftBtnClosure = { [weak self] in
            self?.setStickerView(.one2one)
        }
        stickerSetView.rightBtnClosure = { [weak self] in
            self?.setStickerView(.three2Four)
        }
        stickerSetView.fontBtnClosure = { [weak self] font in
            self?.stickerView.font = font
            ReadTextController.shared.bookCardModel.updateFontType(font)
        }
        stickerSetView.colorBtnClosure = { [weak self] type in
            guard let type = type else { return }
            self?.stickerView.color = type
            ReadTextController.shared.bookCardModel.updateColorType(type)
        }
        
        stickerSetView.selectedRatio = ReadTextController.shared.bookCardModel.sizeType
        stickerSetView.selectedFont = ReadTextController.shared.bookCardModel.font
        stickerSetView.selectedColor = ReadTextController.shared.bookCardModel.colorType
    }
    
    private func setBottomView() {
        let bottomView = FixCard_SaveButtonView()
        self.view.addSubviews(bottomView)
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -34 + -34),
            bottomView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 90)
        ])
        bottomView.saveButtonClosure = { [weak self] in
            guard let cardId = self?.cardId else { return }
            
            DispatchQueue.global().async { [weak self] in
                AFHandler.putCardData(id: cardId) { _ in
//                    guard let cardResponse = $0 else { return }
                    
                    let vc = FixCard_CompleteViewController()
                    vc.cardModel = ReadTextController.shared.getCardModel(id: cardId)
                    vc.modalPresentationStyle = .fullScreen
                    DispatchQueue.main.async {
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
}
