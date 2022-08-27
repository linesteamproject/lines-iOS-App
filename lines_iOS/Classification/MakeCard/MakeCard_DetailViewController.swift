//
//  MakeCard_DetailViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/08/14.
//

import UIKit

enum StickerViewType {
    case one2one
    case three2Four
    var title: String {
        switch self {
        case .one2one:
            return "정방형"
        case .three2Four:
            return "세로형"
        }
    }
    var imgName: String {
        switch self {
        case .one2one:
            return "One2One"
        case .three2Four:
            return "Three2Four"
        }
    }
}
class MakeCard_DetailViewController: ScrollViewController {
    override var topViewHeight: CGFloat {
        get { return 56 }
        set { }
    }
    private weak var stickerBackView: UIView!
    private weak var stickerView: MakeCard_StickerView!
    
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
            tbAlertView.closure = {
                dismissViewControllerUntil(vcID: MainViewController.id)
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
            back.heightAnchor.constraint(equalToConstant: 384)
        ])
        back.backgroundColor = Colors.gray222222.value
        self.stickerBackView = back
    }
    
    private func setStickerView(_ type: StickerViewType) {
        self.stickerView?.removeFromSuperview()
        
        switch type {
        case .one2one:
            setOne2One()
        case .three2Four:
            setThree2Four()
        }
        
        func setOne2One() {
            let stickerView = MakeCard_StickerOneToOneView(ReadTextController.shared.readText)
            self.stickerBackView.addSubviews(stickerView)
            NSLayoutConstraint.activate([
                stickerView.topAnchor.constraint(equalTo: stickerBackView.topAnchor,
                                                constant: 15),
                stickerView.centerXAnchor.constraint(equalTo: stickerBackView.centerXAnchor),
                stickerView.widthAnchor.constraint(equalToConstant: 354),
                stickerView.heightAnchor.constraint(equalToConstant: 354),
                stickerView.bottomAnchor.constraint(equalTo: stickerBackView.bottomAnchor,
                                                   constant: -15)
            ])
            self.stickerView = stickerView
        }
        
        func setThree2Four() {
            let stickerView = MakeCard_StickerThreeToFourView(ReadTextController.shared.readText)
            self.stickerBackView.addSubviews(stickerView)
            NSLayoutConstraint.activate([
                stickerView.topAnchor.constraint(equalTo: stickerBackView.topAnchor,
                                                constant: 15),
                stickerView.centerXAnchor.constraint(equalTo: stickerBackView.centerXAnchor),
                stickerView.widthAnchor.constraint(equalToConstant: 354 / 4 * 3),
                stickerView.heightAnchor.constraint(equalToConstant: 354),
                stickerView.bottomAnchor.constraint(equalTo: stickerBackView.bottomAnchor,
                                                   constant: -15)
            ])
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
            stickerSetView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        stickerSetView.leftBtnClosure = { [weak self] in
            self?.setStickerView(.one2one)
        }
        stickerSetView.rightBtnClosure = { [weak self] in
            self?.setStickerView(.three2Four)
        }
        stickerSetView.colorBtnClosure = { [weak self] type in
            self?.stickerView.backgroundColor = type?.color
        }
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
            
        }
    }
}
