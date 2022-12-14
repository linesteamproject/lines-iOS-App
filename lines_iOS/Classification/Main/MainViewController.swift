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
        gradient.locations = [0.0, 1.0]
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
                .constraint(equalTo: contentView.leftAnchor, constant: 38),
            headerView.rightAnchor
                .constraint(equalTo: contentView.rightAnchor, constant: -38),
            headerView.heightAnchor
                .constraint(greaterThanOrEqualToConstant: 140)
        ])
        headerView.animationPlay()
        self.headerView = headerView
    }

    private func setContentView() {
        self.mainListView?.subviews.forEach {
            $0.removeFromSuperview()
        }
        self.mainListView?.removeFromSuperview()
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
        mainListView.backgroundColor = .clear
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
                guard FirstLaunchChecker.isNotLogin else {
                    AFHandler.logout {
                        guard $0 else { return }
                        
                        UserData.accessToken = ""
                        UserData.refreshToken = ""
                        
                        let vc = LoginViewController()
                        vc.modalPresentationStyle = .fullScreen
                        getAppDelegate()?.setRootViewController(vc)
                    }
                    return
                }
                
                let loginVC = LoginViewController()
                loginVC.modalPresentationStyle = .fullScreen
                loginVC.isShouldSkipHidden = true
                DispatchQueue.main.async { [weak self] in
                    self?.present(loginVC, animated: true)
                }
                break
            case .readyToBe:
                let webVc = UserAgreementWebViewController()
                webVc.urlStr = "https://fuzzy-moat-e98.notion.site/6bde97207a66495583edb318d689ea62"
                DispatchQueue.main.async {
                    self?.present(webVc, animated: true)
                }
            
                break
            }
        }
        menuView.closeClosure = { [weak self] in
            self?.hiddenMenuView()
        }
        
        menuView.resignClosure = { [weak self] in
            AFHandler.resign {
                guard $0 else { return }
                
                UserData.accessToken = ""
                UserData.refreshToken = ""
                FirstLaunchChecker.isDataSaved = false
                FirstLaunchChecker.isOnBoardingShown = false
                
                let vc = SplashViewController()
                vc.modalPresentationStyle = .fullScreen
                DispatchQueue.main.async {
                    getAppDelegate()?.setRootViewController(vc)
                }
            }
        }
        
        if let info: [String: Any] = Bundle.main.infoDictionary,
           let currentVersion: String
            = info["CFBundleShortVersionString"] as? String {
            menuView.version = "?????? " + currentVersion
        }
        self.view.bringSubviewToFront(menuView)
        self.menuView = menuView
    }
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self
            
            let bodyString = """
                                 ????????? ????????? ??????????????????.
                                 
                                 
                                 -------------------
                                 
                                 Device OS : \(UIDevice.current.systemVersion)
                                 
                                 -------------------
                                 """
            
            composeViewController.setToRecipients(["gjansdyd@gmail.com"])
            composeViewController.setSubject("<Lines> ?????? ??? ??????")
            composeViewController.setMessageBody(bodyString, isHTML: false)
            
            self.present(composeViewController, animated: true, completion: nil)
        } else {
            print("?????? ????????? ??????")
            let sendMailErrorAlert = UIAlertController(title: "?????? ?????? ??????", message: "????????? ???????????? 'Mail' ?????? ???????????????. App Store?????? ?????? ?????? ??????????????? ????????? ????????? ???????????? ?????? ??????????????????.", preferredStyle: .alert)
            let goAppStoreAction = UIAlertAction(title: "App Store??? ????????????", style: .default) { _ in
                // ??????????????? ????????????(Mail)
                if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            let cancleAction = UIAlertAction(title: "??????", style: .destructive, handler: nil)
            
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
        self.menuView.backgroundColor = .clear
        UIView.animate(withDuration: 0.3,
                       delay: 0.2,
                       options: .curveEaseInOut,
                       animations: {
            self.menuView.transform = CGAffineTransform.identity
            
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
            tbAlertView.title = "???????????? ????????????"
            var subTitle = "???????????? ??? ????????? 2???????????? ?????? ??? ?????????\n"
            subTitle += "??? ????????? ???????????? ??? ???????????? ????????????."
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
