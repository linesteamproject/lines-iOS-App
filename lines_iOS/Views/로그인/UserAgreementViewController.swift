//
//  UserAgreementViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/09/09.
//

import UIKit

class UserAgreementViewController: ViewController {
    private var cellSubViews = [UserAgreement_CellView]()
    internal var joinViewModel: JoinViewModel!
    internal var isShouldSkipHidden: Bool = false
    private var checkedArr = [false, false] {
        didSet {
            let isEnabled = checkedArr[UserAgreementType.service.rawValue]
                            && checkedArr[UserAgreementType.privacyInfo.rawValue]
            bottomButton.isEnabled = isEnabled
            bottomButton.backgroundColor = isEnabled ? Colors.beige.value : Colors.beigeInactive.value
        }
    }
    
    private weak var bottomButton: OkButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTopView()
        setListView()
        setBottomView()
        
        self.checkedArr = [true, true]
    }
    
    private func setTopView() {
        let topView = UserAgreement_TopView()
        let line = UIView()
        self.view.addSubviews(topView, line)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            topView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            topView.heightAnchor.constraint(equalToConstant: 56),
            
            line.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            line.leftAnchor.constraint(equalTo: topView.leftAnchor),
            line.rightAnchor.constraint(equalTo: topView.rightAnchor),
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
        line.backgroundColor = Colors.white.value.withAlphaComponent(0.2)
        topView.rightButtonClosure = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    private func setListView() {
        var nxtTopAnchor: NSLayoutYAxisAnchor = self.view.topAnchor
        var topConst: CGFloat = 20 + 56 + 37
        UserAgreementType.allCases.forEach { type in
            let cellView: UserAgreement_CellView
            switch type {
            case .service:
                cellView = UserAgreement_CellView(title: type.title,
                                                  subTitle: type.subTitle,
                                                  rightClosure: { [weak self] in
                    self?.goToWebVC(type)
                },
                                                  checkClosure: { [weak self] isChecked in
                    self?.checkedArr[UserAgreementType.service.rawValue] = isChecked
                })
            case .privacyInfo:
                cellView = UserAgreement_CellView(title: type.title,
                                                  subTitle: type.subTitle,
                                                  rightClosure: { [weak self] in
                    self?.goToWebVC(type)
                },
                                                  checkClosure: { [weak self] isChecked in
                    self?.checkedArr[UserAgreementType.privacyInfo.rawValue] = isChecked
                })
            }
            self.view.addSubviews(cellView)
            NSLayoutConstraint.activate([
                cellView.topAnchor.constraint(equalTo: nxtTopAnchor, constant: topConst),
                cellView.leftAnchor.constraint(equalTo: self.view.leftAnchor,
                                              constant: 20),
                cellView.rightAnchor.constraint(equalTo: self.view.rightAnchor,
                                               constant: -20),
                cellView.heightAnchor.constraint(equalToConstant: 60)
            ])
            cellSubViews.append(cellView)
            nxtTopAnchor = cellView.bottomAnchor
            topConst = 0
        }
    }
    
    private func goToWebVC(_ type: UserAgreementType) {
        let webVc = UserAgreementWebViewController()
        webVc.urlStr = type.urlStr
        DispatchQueue.main.async {
            self.present(webVc, animated: true)
        }
    }
    
    private func setBottomView() {
        let bottomButton = OkButton()
        self.view.addSubviews(bottomButton)
        NSLayoutConstraint.activate([
            bottomButton.bottomAnchor
                        .constraint(equalTo: self.view.safeAreaLayoutGuide
                                                      .bottomAnchor,
                                    constant: -20),
            bottomButton.leftAnchor.constraint(equalTo: self.view.leftAnchor,
                                               constant: 20),
            bottomButton.rightAnchor.constraint(equalTo: self.view.rightAnchor,
                                               constant: -20),
            bottomButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        bottomButton.layer.masksToBounds = true
        bottomButton.layer.cornerRadius = 10
        bottomButton.setTitle("다음 단계",
                              font: Fonts.get(size: 18, type: .bold),
                              txtColor: .black,
                              backColor: .beigeInactive)
        bottomButton.addAction(UIAction { [weak self] _ in
            guard let vm = self?.joinViewModel else {
                goToMain()
                return
            }
            goToMain()
            func goToMain() {
                let vc = MainViewController()
                vc.modalPresentationStyle = .fullScreen
                if self?.isShouldSkipHidden == true {
                    vc.justNowLogin = true
                }
                getAppDelegate()?.setRootViewController(vc)
            }
        }, for: .touchUpInside)
        bottomButton.isEnabled = false
        self.bottomButton = bottomButton
    }
}
