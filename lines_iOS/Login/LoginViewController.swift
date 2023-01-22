//
//  LoginViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/08/05.
//

import UIKit
import AuthenticationServices

struct JoinModel {
    let id: String = ""
    let oauthId: String
    let oauthType: LoginType
    
    var param: [String: String] {
        return [
            "id": id,
            "oauthId": oauthId,
            "oauthType": oauthType.type
        ]
    }
}

class LoginViewController: ViewController {
    internal var isShouldSkipHidden = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [Colors.black.value.withAlphaComponent(0.7516).cgColor,
                           Colors.blackGradient.value.cgColor]
        
        // gradient를 layer 전체에 적용해주기 위해 범위를 0.0 ~ 1.0으로 설정
        gradient.locations = [0.0, 1.0]
        
        // gradient 방향을 x축과는 상관없이 y축의 변화만 줌
        gradient.startPoint = CGPoint(x: 0, y: 0.7)
        gradient.endPoint = CGPoint(x: 0, y: 1.0)
        
        gradient.frame = self.view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setUI() {
        let imgView = UIImageView(image: UIImage(named: "LoginLogo"))
        self.view.addSubviews(imgView)
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                        constant: 138),
            imgView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imgView.heightAnchor.constraint(equalToConstant: 36),
        ])
        let loginButtonView = LoginButtonView(isShouldSkipHidden)
        self.view.addSubviews(loginButtonView)
        NSLayoutConstraint.activate([
            loginButtonView.leftAnchor.constraint(equalTo: self.view.leftAnchor,
                                                  constant: 20),
            loginButtonView.rightAnchor.constraint(equalTo: self.view.rightAnchor,
                                                   constant: -20),
            loginButtonView.topAnchor.constraint(equalTo: imgView.bottomAnchor,
                                                constant: 63),
            loginButtonView.heightAnchor.constraint(lessThanOrEqualToConstant: 251)
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
                    self?.goToAgreementVC(JoinModel(oauthId: kakaoUser.userId,
                                                    oauthType: LoginType.kakao))
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
                    self?.goToAgreementVC(JoinModel(oauthId: userIdentifier,
                                                    oauthType: LoginType.naver))
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
                self?.goToMainVC()
                return
            }
        }
    }
    
    private func goToAgreementVC(_ model: JoinModel?) {
        guard let model = model else { return }
        DispatchQueue.global().async { [weak self] in
            AFHandler.login(model) { value in
                //TODO: Error가 났을 경우?
                guard let accessToken = value?.accessToken,
                      let refreshToken = value?.refreshToken,
                      let isCreadted = value?.isCreated
                else { return }
                
                UserData.accessToken = accessToken
                UserData.refreshToken = refreshToken
                
                if isCreadted {
                    let vc = UserAgreementViewController()
                    if self?.isShouldSkipHidden == true {
                        vc.isShouldSkipHidden = self?.isShouldSkipHidden ?? false
                    }
                    vc.modalPresentationStyle = .fullScreen
                    vc.joinModel = model
                    DispatchQueue.main.async { [weak self] in
                        self?.present(vc, animated: true)
                    }
                } else {
                    self?.goToMainVC()
                }
            }
        }
    }
    
    private func goToMainVC() {
        let vc = MainViewController()
        vc.modalPresentationStyle = .fullScreen
        getAppDelegate()?.setRootViewController(vc)
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
            self.goToAgreementVC(JoinModel(oauthId: userIdentifier,
                                           oauthType: LoginType.apple))
        default:
            break
        }
    }
        
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        self.showOneButtonAlertView(title: "로그인 에러",
//                                    height: 250, btnTitle: "확인", btnColor: .beige)
    }
}
