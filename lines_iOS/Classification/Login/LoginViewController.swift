//
//  LoginViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/08/05.
//

import UIKit

class LoginViewController: ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        let loginButtonView = LoginButtonView()
        self.view.addSubviews(loginButtonView)
        NSLayoutConstraint.activate([
            loginButtonView.leftAnchor.constraint(equalTo: self.view.leftAnchor,
                                                  constant: 20),
            loginButtonView.rightAnchor.constraint(equalTo: self.view.rightAnchor,
                                                   constant: -20),
            loginButtonView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loginButtonView.heightAnchor.constraint(equalToConstant: 260)
        ])
        loginButtonView.btnClosure = { [weak self] type in
            switch type {
            case .kakao:
                KakaoLoginController.login {
                    print($0)
                }
                return
            case .naver:
                return
            case .apple:
                return
            case .skip:
                return
            }
        }
    }
}
