//
//  UserAgreement_CellView.swift
//  lines_iOS
//
//  Created by mun on 2022/09/09.
//

import UIKit

class UserAgreement_CellView: UIView {
    private weak var button: UIButton!
    var isSelected: Bool = true {
        didSet { updateUI() }
    }
    
    
    init(title: String,
         subTitle: String = "",
         rightClosure: (() -> Void)?,
         checkClosure: ((Bool) -> Void)?) {
        super.init(frame: .zero)
        
        setCheckClosure(checkClosure)
        setTitle(title, subTitle)
        
        if let rightClosure = rightClosure {
            setRightClosure(rightClosure)
        }
        
        self.isSelected = true
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private func setCheckClosure(_ checkClosure: ((Bool) -> Void)?) {
        let button = UIButton()
        self.addSubviews(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
            button.leftAnchor.constraint(equalTo: self.leftAnchor),
            button.widthAnchor.constraint(equalToConstant: 24),
            button.heightAnchor.constraint(equalToConstant: 24),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -18)
        ])
        button.setImage(UIImage(named: "Checked"), for: .normal)
        button.isSelected = true
        button.addAction(UIAction { _ in
            self.isSelected = !self.isSelected
            checkClosure?(self.isSelected)
        }, for: .touchUpInside)
        self.button = button
    }
    
    private func updateUI() {
        button.isSelected = self.isSelected
        let imgName = button.isSelected ? "Checked" : "Unchecked"
        button.setImage(UIImage(named: imgName), for: .normal)
    }
    
    private func setTitle(_ title: String, _ subTitle: String) {
        let titleLabel = UILabel()
        let subTitleLabel = UILabel()
        self.addSubviews(titleLabel, subTitleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 19),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 34),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -19),
            
            subTitleLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            subTitleLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 4),
        ])
        titleLabel.setTitle(title,
                            font: Fonts.get(size: 16, type: .regular),
                            txtColor: .white)
        subTitleLabel.setTitle(subTitle,
                               font: Fonts.get(size: 16, type: .regular),
                               txtColor: .beige)
    }
    
    private func setRightClosure( _ rightClosure: (() -> Void)?) {
        let label = UILabel()
        let button = UIButton()
        self.addSubviews(label, button)
        NSLayoutConstraint.activate([
            label.rightAnchor.constraint(equalTo: self.rightAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: 53),
            label.heightAnchor.constraint(equalToConstant: 22),
            
            button.topAnchor.constraint(equalTo: label.topAnchor),
            button.rightAnchor.constraint(equalTo: label.rightAnchor),
            button.leftAnchor.constraint(equalTo: label.leftAnchor),
            button.bottomAnchor.constraint(equalTo: label.bottomAnchor)
        ])
        
        label.setTitle(font: Fonts.get(size: 14, type: .regular))
        label.setUnderline("내용 보기")
        button.addAction(UIAction { _ in
            rightClosure?()
        }, for: .touchUpInside)
    }
}

extension UILabel {
    func setUnderline(_ str: String) {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: str,
                                                           attributes: underlineAttribute)
        self.attributedText = underlineAttributedString
    }
}
