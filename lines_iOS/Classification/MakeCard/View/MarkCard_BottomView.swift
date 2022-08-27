//
//  MarkCard_BottomView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/13.
//

import UIKit

class MarkCard_BottomView: UIView {
    var leftBtnClosure: (() -> Void)?
    var rightBtnClosure: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func setUI() {
        let left = CancelButton()
        let right = OkButton()
        self.addSubviews(left, right)
        NSLayoutConstraint.activate([
            left.topAnchor.constraint(equalTo: self.topAnchor,
                                      constant: 20),
            left.leftAnchor.constraint(equalTo: self.leftAnchor,
                                      constant: 20),
            left.widthAnchor.constraint(greaterThanOrEqualToConstant: 162),
            left.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                         constant: -20),
            right.topAnchor.constraint(equalTo: left.topAnchor),
            right.leftAnchor.constraint(equalTo: left.rightAnchor,
                                        constant: 11),
            right.widthAnchor.constraint(equalTo: left.widthAnchor),
            right.rightAnchor.constraint(equalTo: self.rightAnchor,
                                         constant: -20),
            right.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                          constant: -20),
        ])
        left.setTitle("사진 다시 찍기",
                      font: Fonts.get(size: 18, type: .bold),
                      txtColor: Colors.beige)
        right.setTitle("다음 단계",
                       font: Fonts.get(size: 18, type: .bold),
                       txtColor: .black,
                       backColor: Colors.beige)
        
        left.addAction(UIAction { [weak self] _ in
            self?.leftBtnClosure?()
        }, for: .touchUpInside)
        right.addAction(UIAction { [weak self] _ in
            self?.rightBtnClosure?()
        }, for: .touchUpInside)
    }
}

class CancelButton: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = Colors.beige.value.cgColor
    }
}

class OkButton: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 10
    }
}
