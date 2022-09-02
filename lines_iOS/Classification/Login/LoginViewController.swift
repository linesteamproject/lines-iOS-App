//
//  LoginViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/08/05.
//

import UIKit
import AuthenticationServices

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
                KakaoLoginController.login { [weak self] in
                    guard $0 else { return }
                    self?.goToMainVC()
                }
            case .naver:
                return
            case .apple:
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
                        
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.presentationContextProvider = self
                authorizationController.performRequests()
                return
            case .skip:
                self?.goToMainVC()
                return
            }
        }
    }
    
    private func goToMainVC() {
        let vc = MainViewController()
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [weak self] in
            self?.present(vc, animated: true)
        }
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential: // Apple ID
            // 계정 정보 가져오기
            let userIdentifier = appleIDCredential.user
            let givenName = appleIDCredential.fullName?.givenName ?? "Not Given Name"
            let familyName = appleIDCredential.fullName?.familyName ?? "Not Family Name"
            let email = appleIDCredential.email ?? "Not Email"
            
            let userInfoStr = "UserIdentifier: " + userIdentifier + "\n"
            + "FamilyName: " + familyName + "\n"
            + "GivenName: " + givenName + "\n"
            + "Email: " + email
            self.showOneButtonAlertView(title: "로그인 성공", subTitle: userInfoStr,
                                        height: 250, btnTitle: "확인", btnColor: .beige,
                               done: {
                self.goToMainVC()
            })
        default:
            break
        }
    }
        
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.showOneButtonAlertView(title: "로그인 에러", subTitle: error.localizedDescription,
                                    height: 250, btnTitle: "확인", btnColor: .beige)
    }
}
