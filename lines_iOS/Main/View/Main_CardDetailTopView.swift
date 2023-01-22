//
//  Main_CardDetailTopView.swift
//  lines_iOS
//
//  Created by mun on 2022/09/11.
//

import UIKit

class Main_CardDetailTopView: TopView {
    internal var closeClosure: (() -> Void)?
    override func setUI() {
        let label = UILabel()
        self.addSubviews(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            label.heightAnchor.constraint(equalToConstant: 26)
        ])
        label.setTitle("기록한 문장",
                       font: Fonts.get(size: 22, type: .regular),
                       txtColor: .white)
        
        let button = UIButton()
        self.addSubviews(button)
        NSLayoutConstraint.activate([
            button.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 30),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
        button.setImage(UIImage(named: "LeftArrow"),
                        for: .normal)
        button.addAction(UIAction { [weak self] _ in
            self?.closeClosure?()
        }, for: .touchUpInside)
        
        let line = UIView()
        self.addSubviews(line)
        NSLayoutConstraint.activate([
            line.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            line.leftAnchor.constraint(equalTo: self.leftAnchor),
            line.rightAnchor.constraint(equalTo: self.rightAnchor),
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
        line.backgroundColor = Colors.white.value.withAlphaComponent(0.2)
    }
}
