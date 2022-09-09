//
//  UserAgreement_TopView.swift
//  lines_iOS
//
//  Created by mun on 2022/09/09.
//

import UIKit

class UserAgreement_TopView: TopView {
    var rightButtonClosure: (() -> Void)?
    override func setUI() {
        let titleLabel = UILabel()
        self.addSubviews(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 26)
        ])
        titleLabel.setTitle("약관 동의",
                            font: Fonts.get(size: 22, type: .regular))
     
        let rightButton = UIButton()
        self.addSubviews(rightButton)
        NSLayoutConstraint.activate([
            rightButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rightButton.rightAnchor.constraint(equalTo: self.rightAnchor,
                                              constant: -25),
            rightButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            rightButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            rightButton.widthAnchor.constraint(equalToConstant: 20),
            rightButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        rightButton.setImage(UIImage(named: "IconX"), for: .normal)
        rightButton.addAction(UIAction { [weak self] _ in
            self?.rightButtonClosure?()
        }, for: .touchUpInside)
    }
}
