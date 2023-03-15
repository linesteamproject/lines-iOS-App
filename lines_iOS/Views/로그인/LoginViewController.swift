//
//  LoginViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/08/05.
//

import UIKit
import SnapKit
import RxSwift
import AuthenticationServices

class LoginViewController: ViewController {
    internal var isShouldSkipHidden = false
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGradient()
    }
    
    private func setUI() {
        let imgView = UIImageView(image: UIImage(named: "LoginLogo"))
        self.view.addSubview(imgView)
        imgView.snp.makeConstraints({ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(138)
            make.centerX.equalTo(self.view)
            make.height.equalTo(36)
        })
        
        let loginButtonView = LoginButtonView(isShouldSkipHidden)
        self.view.addSubview(loginButtonView)
        loginButtonView.snp.makeConstraints({ make in
            make.left.right.equalTo(self.view).inset(20)
            make.top.equalTo(imgView.snp.bottom).offset(63)
            make.height.lessThanOrEqualTo(251)
        })
        
        loginButtonView.btnClosure = { [unowned self] type in
            switch type {
            case .kakao:
                KakaoLoginService().login()
                    .subscribe(onNext:{ (oauthToken) in
                        //do something
                        _ = oauthToken
                        
                        KakaoLoginService().getUserInfo()
                            .observe(on: MainScheduler.instance)
                            .subscribe(onNext: { vm in
                                self.goToAgreementVC(vm.getJoinViewModel())
                            }).disposed(by: self.disposeBag)
                    }, onError: {error in
                        print(error)
                    }).disposed(by: disposeBag)
            case .naver:
                let service = NaverLoginService()
                service.login()
                service.naverLoginClosure = { [weak self] res in
                    guard let res = res, let userIdentifier = res.id
                    else { return }
                    
                    let subTitle = "user identifier: " + (res.id ?? "") + "\n"
                    + "email: " + (res.email ?? "") + "\n"
                    + "nickName: " + (res.nickname ?? "") + "\n"
                    + "name: " + (res.name ?? "") + "\n"
                    self?.goToAgreementVC(JoinViewModel(
                        id: "",
                        oauthId: userIdentifier,
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
                self.goToMainVC()
                return
            }
        }
    }
    
    private func goToAgreementVC(_ viewModel: JoinViewModel?) {
        guard let viewModel = viewModel else { return }
        
        NetworkService()
            .login(viewModel)
            .take(1)
            .subscribe(onNext: { [weak self] vm in
                if vm.isCreated() {
                    let vc = UserAgreementViewController()
                    if self?.isShouldSkipHidden == true {
                        vc.isShouldSkipHidden = self?.isShouldSkipHidden ?? false
                    }
                    vc.modalPresentationStyle = .fullScreen
                    vc.joinViewModel = viewModel
                    DispatchQueue.main.async { [weak self] in
                        self?.present(vc, animated: true)
                    }
                } else {
                    self?.goToMainVC()
                }
            }, onError: { _ in
                
            }).disposed(by: disposeBag)
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

extension LoginViewController {
    private func setGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [Colors.black.value.withAlphaComponent(0.7516).cgColor,
                           Colors.blackGradient.value.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0.7)
        gradient.endPoint = CGPoint(x: 0, y: 1.0)
        
        gradient.frame = self.view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
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
            self.goToAgreementVC(JoinViewModel(
                id: "",
                oauthId: userIdentifier,
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
