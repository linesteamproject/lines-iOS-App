//
//  LoginButtonView.swift
//  lines_iOS
//
//  Created by mun on 2022/09/01.
//

import Foundation
import UIKit

class LoginButtonView: UIView {
    internal var btnClosure: ((LoginType) -> Void)?
    init(_ isShouldSkipHidden: Bool) {
        super.init(frame: .zero)
        setUI(isShouldSkipHidden)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func setUI(_ isShouldSkipHidden: Bool) {
        var nxTopAnchhor: NSLayoutYAxisAnchor = self.topAnchor
        var nxTopConstant: CGFloat = 0
        LoginType.allCases.forEach { type in
            let loginBtn = LoginButton()
            self.addSubviews(loginBtn)
            NSLayoutConstraint.activate([
                loginBtn.topAnchor.constraint(equalTo: nxTopAnchhor,
                                              constant: nxTopConstant),
                loginBtn.leftAnchor.constraint(equalTo: self.leftAnchor),
                loginBtn.rightAnchor.constraint(equalTo: self.rightAnchor),
                loginBtn.heightAnchor.constraint(equalToConstant: 50),
            ])
            loginBtn.type = type
            loginBtn.addAction(UIAction { [weak self] _ in
                self?.btnClosure?(type)
            }, for: .touchUpInside)
            
            guard type != .skip else {
                loginBtn.bottomAnchor
                        .constraint(equalTo: self.bottomAnchor).isActive = true
                loginBtn.isHidden = isShouldSkipHidden
                return
            }
            nxTopAnchhor = loginBtn.bottomAnchor
            nxTopConstant = 12
        }
    }
}
