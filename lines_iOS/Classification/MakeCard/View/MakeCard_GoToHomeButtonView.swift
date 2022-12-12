//
//  MakeCard_GoToHomeButtonView.swift
//  lines_iOS
//
//  Created by MunYong HEO on 2022/08/29.
//

import UIKit

class MakeCard_GoToHomeButtonView: UIView {
    internal var goToHomeClosure: (() -> Void)?
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
        btn.setTitle("홈으로 이동",
                      font: Fonts.get(size: 18, type: .bold),
                      txtColor: .black)
        btn.addAction(UIAction { [weak self] _ in
            self?.goToHomeClosure?()
        }, for: .touchUpInside)
    }
}
