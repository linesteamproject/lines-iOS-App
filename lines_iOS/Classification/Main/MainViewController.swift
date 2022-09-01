//
//  MainViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation
import UIKit

let realm = RealmController.shared
class MainViewController: ScrollViewController {
    private weak var headerView: Main_HeaderView!
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RealmController.shared.queue.async {
            RealmController.shared.getBookCards {
                self.mainListView?.datas = $0
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
            print("show menu")
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
            break
        }
    }
}
