//
//  Main_PopUpAlertViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/12/12.
//

import UIKit

class Main_PopUpAlertViewController: PopUpViewController {
    private weak var alertView: UIView!
    
    internal var textFixClosure: (() -> Void)?
    internal var templeteFixClosure: (() -> Void)?
    
    override func setAdditionalUI() {
        setAlertView()
        setAlertContentView()
        
        self.closeClosure = { [weak self] in
            UIView.animate(withDuration: 0.5, animations: {
                self?.alertView.transform = CGAffineTransform.identity
            }, completion: { _ in
                self?.dismiss(animated: false)
            })
        }
    }
    
    private func setAlertView() {
        let alertView = UIView()
        back.addSubviews(alertView)
        NSLayoutConstraint.activate([
            alertView.bottomAnchor.constraint(equalTo: back.bottomAnchor, constant: 231),
            alertView.leftAnchor.constraint(equalTo: back.leftAnchor),
            alertView.rightAnchor.constraint(equalTo: back.rightAnchor),
            alertView.heightAnchor.constraint(equalToConstant: 231)
        ])
        alertView.backgroundColor = Colors.white.value
        alertView.layer.cornerRadius = 10
        alertView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner,
                                                     .layerMaxXMinYCorner)

        self.alertView = alertView
    }
    
    private func setAlertContentView() {
        let titleLabel = UILabel()
        let rightButton = UIButton()
        let textFixButton = UIButton()
        let line = UIView()
        let templeteFixButton = UIButton()
        self.alertView.addSubviews(titleLabel, rightButton,
                                   textFixButton, line, templeteFixButton)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            rightButton.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),
            rightButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            rightButton.widthAnchor.constraint(equalToConstant: 30),
            rightButton.heightAnchor.constraint(equalToConstant: 30),
            
            textFixButton.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 70),
            textFixButton.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 20),
            textFixButton.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -20),
            textFixButton.heightAnchor.constraint(equalToConstant: 60),
            
            line.topAnchor.constraint(equalTo: textFixButton.bottomAnchor),
            line.leftAnchor.constraint(equalTo: textFixButton.leftAnchor),
            line.rightAnchor.constraint(equalTo: textFixButton.rightAnchor),
            line.heightAnchor.constraint(equalToConstant: 1),
            
            templeteFixButton.topAnchor.constraint(equalTo: line.bottomAnchor),
            templeteFixButton.leftAnchor.constraint(equalTo: line.leftAnchor),
            templeteFixButton.rightAnchor.constraint(equalTo: line.rightAnchor),
            templeteFixButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        titleLabel.setTitle("무엇을 수정하시겠어요?", font: Fonts.get(size: 22, type: .regular),
                            txtColor: .black)
        rightButton.setImage(UIImage(named: "IconX")?.withTintColor(Colors.black.value),
                             for: .normal)
        rightButton.addAction(UIAction { [weak self] _ in
            self?.closeClosure?()
        }, for: .touchUpInside)
        textFixButton.setTitle("문장 텍스트 수정하기",
                               font: Fonts.get(size: 18, type: .bold),
                               txtColor: .black)
        textFixButton.contentHorizontalAlignment = .left
        textFixButton.addAction(UIAction { [weak self] _ in
            self?.textFixClosure?()
        }, for: .touchUpInside)
        line.backgroundColor = Colors.black.value.withAlphaComponent(0.2)
        templeteFixButton.setTitle("문장 탬플릿 수정하기",
                                   font: Fonts.get(size: 18, type: .bold),
                                   txtColor: .black)
        templeteFixButton.contentHorizontalAlignment = .left
        templeteFixButton.addAction(UIAction { [weak self] _ in
            self?.templeteFixClosure?()
        }, for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5) {
            self.alertView.transform = CGAffineTransform(translationX: 0,
                                                    y: -231)
        }
    }
}
