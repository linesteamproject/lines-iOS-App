//
//  MakeCard_TopView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/13.
//

import UIKit

class MakeCard_TopView: TopView {
    internal var closeClosure: (() -> Void)?
    override func setUI() {
        let label = UILabel()
        self.addSubviews(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        label.setTitle("문장 기록",
                       font: Fonts.get(size: 22, type: .regular),
                       txtColor: .white)
        
        let button = UIButton()
        self.addSubviews(button)
        NSLayoutConstraint.activate([
            button.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 20),
            button.heightAnchor.constraint(equalToConstant: 20)
        ])
        button.setImage(UIImage(named: "IconX"),
                        for: .normal)
        button.addAction(UIAction { [weak self] _ in
            self?.closeClosure?()
        }, for: .touchUpInside)
    }
}
