//
//  FixCard_SaveButtonView.swift
//  lines_iOS
//
//  Created by mun on 2023/01/22.
//

import UIKit

class FixCard_SaveButtonView: UIView {
    internal var saveButtonClosure: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func setUI() {
        self.backgroundColor = Colors.black.value
        
        let btn = UIButton()
        self.addSubviews(btn)
        NSLayoutConstraint.activate([
            btn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            btn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            btn.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            btn.heightAnchor.constraint(equalToConstant: 50)
        ])
        btn.backgroundColor = Colors.beige.value
        btn.layer.cornerRadius = 8
        btn.setTitle("저장하기",
                      font: Fonts.get(size: 18, type: .bold),
                      txtColor: .black)
        btn.addAction(UIAction { [weak self] _ in
            self?.saveButtonClosure?()
        }, for: .touchUpInside)
    }
}
