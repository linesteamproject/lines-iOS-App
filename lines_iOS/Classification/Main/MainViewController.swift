//
//  MainViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation
import UIKit

class MainViewController: ScrollViewController {
    private weak var headerView: Main_HeaderView!
    override var topViewHeight: CGFloat {
        get { return 56 }
        set { }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFloatingButton()
        setUI()
    }
    
    private func setUI() {
        setHeaderView()
        setContentView()
    }
    
    override func setTopView() {
        let topView = Main_TopView()
        self.view.addSubViews(topView)
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
        self.view.addSubViews(mainMenuButton)
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
        self.contentView.addSubViews(headerView)
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
        let mainListView = Main_ListView(width: viewWidth,
                                               datas: (1 ... 6).compactMap {
            return UIImage(named: String(format: "Card%d", $0))})
        self.contentView.addSubViews(mainListView)
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
                .constraint(lessThanOrEqualToConstant: 1000)
        ])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let crntVal = (scrollView.contentOffset.y - Double(39)) / Double(100)
        let alphaVal = crntVal < 0 ? 0 : (crntVal > 1 ? 1 : crntVal)

        self.topView.alpha = alphaVal
    }
}

extension MainViewController {
    private func setFloatingButton() {
        let btn = UIButton()
        self.view.addSubViews(btn)
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
        btn.addAction(UIAction { _ in
            let vc = CameraViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }, for: .touchUpInside)
    }
}
