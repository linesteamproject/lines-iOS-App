//
//  LoginViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/08/05.
//

import UIKit
import AuthenticationServices

struct JoinModel {
    let id: String
    let oauthId: String
    let oauthType: LoginType
}

class LoginViewController: ViewController {
    internal var isShouldSkipHidden = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        let loginButtonView = LoginButtonView(isShouldSkipHidden)
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
                KakaoLoginController.shared.login { [weak self] in
                    guard let kakaoUser = $0 else {
                        self?.showOneButtonAlertView(title: "로그인 실패", height: 70, btnTitle: "확인",
                                                     btnColor: .beige)
                        return
                    }
                    
                    let subTitle = "user identifier: " + (kakaoUser.userId) + "\n"
                    + "email: " + (kakaoUser.email) + "\n"
                    + "nickName: " + (kakaoUser.nick) + "\n"
                    self?.showOneButtonAlertView(title: "로그인 성공", subTitle: subTitle,
                                                 height: 240,
                                                 btnTitle: "확인", btnColor: .beige, done: {
                        self?.goToAgreementVC(JoinModel(id: "",
                                                        oauthId: kakaoUser.userId,
                                                        oauthType: LoginType.kakao))
                    })
                }
            case .naver:
                NaverLoginController.shared.login()
                NaverLoginController.shared.naverLoginClosure = { [weak self] res in
                    guard let res = res, let userIdentifier = res.id else {
                        self?.showOneButtonAlertView(title: "로그인 실패", height: 70, btnTitle: "확인",
                                                     btnColor: .beige)
                        return
                    }
                    
                    let subTitle = "user identifier: " + (res.id ?? "") + "\n"
                    + "email: " + (res.email ?? "") + "\n"
                    + "nickName: " + (res.nickname ?? "") + "\n"
                    + "name: " + (res.name ?? "") + "\n"
                    self?.showOneButtonAlertView(title: "로그인 성공", subTitle: subTitle,
                                                 height: 240,
                                                 btnTitle: "확인", btnColor: .beige, done: {
                        self?.goToAgreementVC(JoinModel(id: "",
                                                        oauthId: userIdentifier,
                                                        oauthType: LoginType.naver))
                    })
                }
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
                self?.goToAgreementVC(nil)
                return
            }
        }
    }
    
    private func goToAgreementVC(_ model: JoinModel?) {
        // 로그인
        let vc = UserAgreementViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.joinModel = model
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
                self.goToAgreementVC(JoinModel(id: "",
                                               oauthId: userIdentifier,
                                               oauthType: LoginType.apple))
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
