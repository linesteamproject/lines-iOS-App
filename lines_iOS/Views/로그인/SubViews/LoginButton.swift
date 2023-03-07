//
//  LoginButton.swift
//  lines_iOS
//
//  Created by mun on 2022/09/01.
//

import UIKit

class LoginButton: UIButton {
    private weak var loginTitleLabel: UILabel!
    internal var type: LoginType? {
        didSet {
            self.setImage(type?.img, for: .normal)
//            self.loginTitleLabel.setTitle(type?.title)
//            if type == .skip {
//                self.loginTitleLabel.setTitle(type?.title, txtColor: .beige)
//            }
//            self.backgroundColor = (type?.color ?? .clear).value
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.masksToBounds = true
//        self.layer.cornerRadius = 25
    }
    private func setUI() {
        let loginTitleLabel = UILabel()
        self.addSubviews(loginTitleLabel)
        NSLayoutConstraint.activate([
            loginTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loginTitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        loginTitleLabel.setTitle(font: Fonts.get(size: 18,
                                                 type: .bold),
                                 txtColor: .black)
        self.loginTitleLabel = loginTitleLabel
    }
}
