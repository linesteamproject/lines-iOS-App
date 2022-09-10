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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainListView.datas?.removeAll()
        
        RealmController.shared.queue.async {
            RealmController.shared.getBookCards { cards in
                DispatchQueue.main.async {
                    self.mainListView?.datas = cards
                    FirstLaunchChecker.isDataSaved = cards.count > 0 
                }
            }
        }
    }
    
    override func setTopView() {
        let topView = Main_TopView()
        self.view.addSubviews(topView)
        NSLayoutConstraint.activate([
            topView.topAnchor
                    .constraint(equalTo: self.view.topAnchor,
                                constant: 35),
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
        scrollView.bounces = false
        
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
            case .feedback:
                self?.sendEmail()
                break
            case .logout:
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
        
        self.view.layoutIfNeeded()
    }
    @objc
    private func hiddenButtonsView() {
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
        guard let type = obj as? Main_OverlappedButtonsType
        else { return }
        
        switch type {
        case .top:
            let vc = CameraViewController()
            vc.type = .camera
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async { [weak self] in
                self?.present(vc, animated: true)
            }
        case .mid:
            let vc = CameraViewController()
            vc.type = .photoLibrary
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async { [weak self] in
                self?.present(vc, animated: true)
            }
        case .bottom:
            let vc = MakeCardViewController()
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(vc, animated: false)
            }
            break
        }
    }
}
