//
//  LoginViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/08/05.
//

import UIKit

class LoginViewController: ViewController {
    private let loginController = LoginController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        let loginButtonView = LoginButtonView()
        self.view.addSubviews(loginButtonView)
        NSLayoutConstraint.activate([
            loginButtonView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            loginButtonView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            loginButtonView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loginButtonView.heightAnchor.constraint(equalToConstant: 260)
        ])
        loginButtonView.btnClosure = { [weak self] type in
            switch type {
            case .kakao:
                KakaoLoginController.loginByKakao()
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
