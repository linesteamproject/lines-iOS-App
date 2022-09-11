//
//  UserAgreementViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/09/09.
//

import UIKit

enum UserAgreementType: Int, CaseIterable {
    case privacyInfo = 0
    case service = 1
    
    var title: String {
        switch self {
        case .service:
            return "서비스 이용약관 동의"
        case .privacyInfo:
            return "개인정보 수집 및 이용 동의"
        }
    }
    var subTitle: String {
        switch self {
        case .service, .privacyInfo:
            return "(필수)"
        }
    }
    var rightContent: String? {
        switch self {
        case .service, .privacyInfo:
            return "내용보기"
        }
    }
    var urlStr: String {
        switch self {
        case .privacyInfo:
            return "https://fuzzy-moat-e98.notion.site/ffee06c6f31c49dd91e7c85981e60cc3"
        case .service:
            return "https://fuzzy-moat-e98.notion.site/370091f86242460fbfc103b574e6407c"
        }
    }
}
class UserAgreementViewController: ViewController {
    private var cellSubViews = [UserAgreement_CellView]()
    internal var joinModel: JoinModel!
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
            topView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 35),
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
            let vc = MainViewController()
            vc.modalPresentationStyle = .fullScreen
            getAppDelegate()?.setRootViewController(vc)
//            self?.present(vc, animated: true)
        }, for: .touchUpInside)
        bottomButton.isEnabled = false
        self.bottomButton = bottomButton
    }
}
