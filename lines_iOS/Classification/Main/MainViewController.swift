//
//  MainViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation
import UIKit
import MessageUI
class MainViewController: ScrollViewController {
    private weak var headerView: Main_HeaderView!
    private weak var menuView: Main_MenuView!
    private weak var back: UIView!
    private weak var overlappedButtonsView: Main_OverlappedButtonsView!
    private weak var overlappedButtonsViewHeightConstraint: NSLayoutConstraint!
    private weak var floatingButton: UIButton!
    private weak var mainListView: Main_ListView!
    
    internal var justNowLogin = false
    override var topViewHeight: CGFloat {
        get { return 56 }
        set { }
    }
    override func setAdditionalUI() {
        setFloatingButton()
        setHeaderView()
        setContentView()
        setOverlappedButtonsView()
        setMenuView()
        
        guard justNowLogin else { return }
        
        RealmController.shared.queue.async {
            RealmController.shared.getBookCards { cards in
                cards.forEach { card in
                    DispatchQueue.global().async { [weak self] in
                        guard let card = card else { return }
                        AFHandler.saveRealmCardData(card) {
                            //TODO: ERROR
                            guard let value = $0 else { return }
                            self?.getCardsFromServer {
                                self?.justNowLogin = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setContentView()
        
        if FirstLaunchChecker.isNotLogin {
            RealmController.shared.queue.async {
                RealmController.shared.getBookCards { cards in
                    DispatchQueue.main.async {
                        self.mainListView?.datas = cards
                        FirstLaunchChecker.isDataSaved = cards.count > 0
                    }
                }
            }
        } else if !justNowLogin {
            getCardsFromServer()
        }
        
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
    
    private func getCardsFromServer(_ done: (() -> Void)? = nil) {
        DispatchQueue.global().async {
            AFHandler.getCardDatas {
                guard let value = $0 else { done?(); return }
                var cards = [CardModel]()
                value.content.forEach { content in
                    let ratio = MakeCard_StickerRatioType.allCases.first(where: { $0.typeStr == content.ratio }) ?? .one2one
                    cards.append(CardModel(bookName: content.bookResponse?.name,
                                           authorName: content.bookResponse?.title,
                                           bookIsbn: content.bookResponse?.isbn,
                                           lineValue: content.content,
                                           colorImageName: content.background,
                                           ratioType: ratio))
                }
                
                done?()
                DispatchQueue.main.async {
                    self.mainListView?.datas = cards.reversed()
                }
            }
        }
    }
    
    override func setTopView() {
        let topView = Main_TopView()
        self.view.addSubviews(topView)
        NSLayoutConstraint.activate([
            topView.topAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topView.leftAnchor
                    .constraint(equalTo: self.view.leftAnchor),
            topView.rightAnchor
                    .constraint(equalTo: self.view.rightAnchor),
            topView.heightAnchor
                    .constraint(equalToConstant: topViewHeight)
        ])
        topView.alpha = 0.0
        self.topView = topView
        
        let mainMenuButton = Main_MenuButton()
        self.view.addSubviews(mainMenuButton)
        NSLayoutConstraint.activate([
            mainMenuButton.widthAnchor
                .constraint(equalToConstant: 47),
            mainMenuButton.heightAnchor
                .constraint(equalToConstant: 36),
            mainMenuButton.leftAnchor
                .constraint(equalTo: topView.leftAnchor,
                            constant: 20),
            mainMenuButton.centerYAnchor
                .constraint(equalTo: topView.centerYAnchor)
        ])
        mainMenuButton.closure = { [weak self] in
            self?.showMenuView()
        }
    }
    
    private func setHeaderView() {
        let headerView = Main_HeaderView()
        self.contentView.addSubviews(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor
                .constraint(equalTo: contentView.topAnchor),
            headerView.leftAnchor
                .constraint(equalTo: contentView.leftAnchor),
            headerView.rightAnchor
                .constraint(equalTo: contentView.rightAnchor),
            headerView.heightAnchor
                .constraint(equalToConstant: 166)
        ])
        self.headerView = headerView
    }

    private func setContentView() {
        self.mainListView?.removeFromSuperview()
        self.mainListView?.backgroundColor = .clear
        scrollView.bounces = true
        
        let viewWidth = UIScreen.main.bounds.width - 40
        let mainListView = Main_ListView(width: viewWidth)
        self.contentView.addSubviews(mainListView)
        NSLayoutConstraint.activate([
            mainListView.topAnchor
                .constraint(equalTo: self.headerView.bottomAnchor),
            mainListView.leftAnchor
                .constraint(equalTo: contentView.leftAnchor,
                            constant: 20),
            mainListView.rightAnchor
                .constraint(equalTo: contentView.rightAnchor,
                            constant: -20),
            mainListView.bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor),
            mainListView.heightAnchor
                .constraint(greaterThanOrEqualToConstant: 10)
        ])
        mainListView.cardTouchedClosure = { [weak self] cardModel in
            ReadTextController.shared.cardModel = cardModel
            let vc = Main_CardDetailViewController()
            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.mainListView = mainListView
    }
    
    private func setBackgroundView() {
        let back = UIView()
        self.view.addSubviews(back)
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: self.view.topAnchor),
            back.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            back.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            back.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        back.isHidden = true
        self.back = back
        setGestureRecognizer()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let crntVal = (scrollView.contentOffset.y - Double(39)) / Double(100)
        let alphaVal = crntVal < 0 ? 0 : (crntVal > 1 ? 1 : crntVal)

        self.topView.alpha = alphaVal
    }
    
    private func setMenuView() {
        let menuView = Main_MenuView()
        self.view.addSubviews(menuView)
        
        let widthConst = UIScreen.main.bounds.width
        NSLayoutConstraint.activate([
            menuView.topAnchor.constraint(equalTo: self.topView.topAnchor),
            menuView.widthAnchor.constraint(equalToConstant: widthConst),
            menuView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            menuView.rightAnchor.constraint(equalTo: self.view.rightAnchor,
                                            constant: -widthConst)
        ])
        menuView.cellBtnClosure = { [weak self] type in
            switch type {
            case .userAgreement:
                let webVc = UserAgreementWebViewController()
                webVc.urlStr = UserAgreementType.service.urlStr
                DispatchQueue.main.async {
                    self?.present(webVc, animated: true)
                }
            case .privacyWay:
                let webVc = UserAgreementWebViewController()
                webVc.urlStr = UserAgreementType.privacyInfo.urlStr
                DispatchQueue.main.async {
                    self?.present(webVc, animated: true)
                }
            case .feedback:
                self?.sendEmail()
                break
            case .logout:
                AFHandler.logout {
                    guard $0 else { return }
                    
                    UserData.accessToken = ""
                    UserData.refreshToken = ""
                    
                    let vc = LoginViewController()
                    vc.modalPresentationStyle = .fullScreen
                    getAppDelegate()?.setRootViewController(vc)
                }
                break
            case .readyToBe:
                break
            }
        }
        menuView.closeClosure = { [weak self] in
            self?.hiddenMenuView()
        }
        self.view.bringSubviewToFront(menuView)
        self.menuView = menuView
    }
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self
            
            let bodyString = """
                                 이곳에 내용을 작성해주세요.
                                 
                                 
                                 -------------------
                                 
                                 Device OS : \(UIDevice.current.systemVersion)
                                 
                                 -------------------
                                 """
            
            composeViewController.setToRecipients(["gjansdyd@gmail.com"])
            composeViewController.setSubject("<Lines> 문의 및 의견")
            composeViewController.setMessageBody(bodyString, isHTML: false)
            
            self.present(composeViewController, animated: true, completion: nil)
        } else {
            print("메일 보내기 실패")
            let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
            let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
                // 앱스토어로 이동하기(Mail)
                if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
            
            sendMailErrorAlert.addAction(goAppStoreAction)
            sendMailErrorAlert.addAction(cancleAction)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
    
    private func showMenuView() {
        UIView.animate(withDuration: 0.3,
                       delay: 0.2,
                       options: .curveEaseInOut,
                       animations: {
            self.menuView.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
        }, completion: { _ in
            self.menuView.backgroundColor = Colors.white.value.withAlphaComponent(0.1)
            self.view.layoutIfNeeded()
        })
    }
    
    private func hiddenMenuView() {
        UIView.animate(withDuration: 0.3,
                       delay: 0.2,
                       options: .curveEaseInOut,
                       animations: {
            self.menuView.transform = CGAffineTransform.identity
            self.menuView.backgroundColor = .clear
        }, completion: { _ in
            self.view.layoutIfNeeded()
        })
    }
}

extension MainViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    private func setGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddenButtonsView))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
}
extension MainViewController {
    private func setFloatingButton() {
        let btn = UIButton()
        self.view.addSubviews(btn)
        NSLayoutConstraint.activate([
            btn.rightAnchor.constraint(equalTo: self.view
                .rightAnchor, constant: -30),
            btn.bottomAnchor
                .constraint(equalTo: self.view
                    .safeAreaLayoutGuide
                    .bottomAnchor, constant: -30),
            btn.widthAnchor.constraint(equalToConstant: 68),
            btn.heightAnchor.constraint(equalToConstant: 68),
        ])
        btn.setImage(UIImage(named: "FloatingButton"),
                     for: .normal)
        btn.addAction(UIAction { [weak self] _ in
            self?.showButtonDetails()
        }, for: .touchUpInside)
        
        self.floatingButton = btn
    }
    
    private func setOverlappedButtonsView() {
        if back == nil { setBackgroundView() }
        
        let overlappedButtonsView = Main_OverlappedButtonsView(self)
        back.addSubviews(overlappedButtonsView)
        
        let heightConstraint = overlappedButtonsView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            overlappedButtonsView.rightAnchor
                                .constraint(equalTo: self.floatingButton
                                                            .rightAnchor),
            overlappedButtonsView.bottomAnchor
                                .constraint(equalTo: self.floatingButton
                                                            .topAnchor,
                                            constant: -20),
            heightConstraint,
        ])
        overlappedButtonsView.isHidden = true
        self.overlappedButtonsView = overlappedButtonsView
        self.overlappedButtonsViewHeightConstraint = heightConstraint
    }
    
    private func showButtonDetails() {
        if let back = back { back.isHidden = false }
        self.overlappedButtonsView.isHidden = false
        self.view.bringSubviewToFront(overlappedButtonsView)
        overlappedButtonsView.updateUI(isHidden: false)
        overlappedButtonsViewHeightConstraint.isActive = false
        overlappedButtonsViewHeightConstraint = overlappedButtonsView.heightAnchor.constraint(equalToConstant: 221)
        overlappedButtonsViewHeightConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, delay: 0.0) {
            self.floatingButton.transform = CGAffineTransform(rotationAngle: .pi / 4)
        }
        self.view.layoutIfNeeded()
    }
    @objc
    private func hiddenButtonsView() {
        UIView.animate(withDuration: 0.3, delay: 0.0) {
            self.floatingButton.transform = .identity
        }
        overlappedButtonsView.updateUI(isHidden: true) { [weak self] in
            self?.overlappedButtonsViewHeightConstraint.isActive = false
            self?.overlappedButtonsViewHeightConstraint = self?.overlappedButtonsView.heightAnchor.constraint(equalToConstant: 0)
            self?.overlappedButtonsViewHeightConstraint.isActive = true
            self?.overlappedButtonsView.isHidden = true
            self?.back.isHidden = true
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(touches.debugDescription)
        print(event.debugDescription)
    }
}

extension MainViewController: ButtonDelegate {
    func touched(_ obj: Any?) {
        if FirstLaunchChecker.isNotLogin, RealmController.shared.currentCardsCount >= 2 {
            let tbAlertView = TwoButtonAlertView()
            self.view.addSubviews(tbAlertView)
            NSLayoutConstraint.activate([
                tbAlertView.topAnchor.constraint(equalTo: self.view.topAnchor),
                tbAlertView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                tbAlertView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                tbAlertView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
            tbAlertView.title = "회원가입 해주세요"
            var subTitle = "비로그인 시 문장은 2개까지만 만들 수 있어요\n"
            subTitle += "그 이상은 회원가입 및 로그인을 해주세요."
            tbAlertView.subTitle = subTitle
            tbAlertView.closure = {
                let loginVC = LoginViewController()
                loginVC.modalPresentationStyle = .fullScreen
                loginVC.isShouldSkipHidden = true
                DispatchQueue.main.async { [weak self] in
                    self?.present(loginVC, animated: true)
                }
            }
            
            return
        }
        
        guard let type = obj as? Main_OverlappedButtonsType
        else { return }
        
        self.hiddenButtonsView()
        ReadTextController.shared.initialize()
        
        switch type {
        case .top:
            let vc = CameraViewController()
            vc.type = .camera
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        case .mid:
            let vc = CameraViewController()
            vc.type = .photoLibrary
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        case .bottom:
            let vc = MakeCardOnlyTextViewController()
            ReadTextController.shared.capturedImage = UIImage(named: "EmptyBookImage")
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            break
        }
    }
}
