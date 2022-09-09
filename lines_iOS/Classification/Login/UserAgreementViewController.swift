//
//  UserAgreementViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/09/09.
//

import UIKit

enum UserAgreementType: Int, CaseIterable {
    case service = 0
    case privacyInfo
    case age
    case marketing
    
    var title: String {
        switch self {
        case .service:
            return "서비스 이용약관 동의"
        case .privacyInfo:
            return "개인정보 수집 및 이용 동의"
        case .age:
            return "만 14세 이상 확인"
        case .marketing:
            return "마케팅 이메일 수신 동의(선택)"
        }
    }
    var subTitle: String {
        switch self {
        case .service, .privacyInfo, .age:
            return "(필수)"
        case .marketing:
            return ""
        }
    }
    var rightContent: String? {
        switch self {
        case .service, .privacyInfo:
            return "내용보기"
        default: return nil
        }
    }
}
class UserAgreementViewController: ScrollViewController {
    private weak var cellTitleView: UserAgreement_CellView!
    private var cellSubViews = [UserAgreement_CellView]()
    private var checkedArr = [false, false, false, false] {
        didSet {
            let isEnabled = checkedArr[UserAgreementType.service.rawValue]
                            && checkedArr[UserAgreementType.privacyInfo.rawValue]
                            && checkedArr[UserAgreementType.age.rawValue]
                
            cellTitleView.isSelected = !checkedArr.contains(false)
            bottomButton.isEnabled = isEnabled
            bottomButton.backgroundColor = isEnabled ? Colors.beige.value : Colors.beigeInactive.value
        }
    }
    private weak var bottomButton: OkButton!
    override func setTopView() {
        let topView = UserAgreement_TopView()
        let line = UIView()
        self.view.addSubviews(topView, line)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 35),
            topView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            topView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            topView.heightAnchor.constraint(equalToConstant: topViewHeight),
            
            line.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            line.leftAnchor.constraint(equalTo: topView.leftAnchor),
            line.rightAnchor.constraint(equalTo: topView.rightAnchor),
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
        line.backgroundColor = Colors.white.value.withAlphaComponent(0.2)
        topView.rightButtonClosure = { [weak self] in
            self?.dismiss(animated: true)
        }
        self.topView = topView
    }
    
    override func setAdditionalUI() {
        setListView()
        setBottomView()
    }
    
    private func setListView() {
        let back = UIView()
        self.contentView.addSubviews(back)
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                     constant: 20),
            back.leftAnchor.constraint(equalTo: self.contentView.leftAnchor,
                                      constant: 20),
            back.rightAnchor.constraint(equalTo: self.contentView.rightAnchor,
                                       constant: -20),
            back.heightAnchor.constraint(greaterThanOrEqualToConstant: 301),
            back.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                        constant: -263)
        ])
        
        let cellTitleView = UserAgreement_CellView(title: "전체동의",
                                                   rightClosure: nil,
                                                   checkClosure: { [weak self] isChecked in
            self?.cellSubViews.enumerated().forEach { idx, view in
                view.isSelected = isChecked
                self?.checkedArr[idx] = isChecked
            }
        })
        back.addSubviews(cellTitleView)
        NSLayoutConstraint.activate([
            cellTitleView.topAnchor.constraint(equalTo: back.topAnchor),
            cellTitleView.leftAnchor.constraint(equalTo: back.leftAnchor),
            cellTitleView.rightAnchor.constraint(equalTo: back.rightAnchor),
            cellTitleView.heightAnchor.constraint(equalToConstant: 60),
        ])
        cellTitleView.isSelected = false
        self.cellTitleView = cellTitleView
        
        let line = UIView()
        back.addSubviews(line)
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: cellTitleView.bottomAnchor),
            line.leftAnchor.constraint(equalTo: back.leftAnchor),
            line.rightAnchor.constraint(equalTo: back.rightAnchor),
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
        line.backgroundColor = Colors.white.value.withAlphaComponent(0.2)
        
        var nxtTopAnchor: NSLayoutYAxisAnchor = line.bottomAnchor
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
            case .age:
                cellView = UserAgreement_CellView(title: type.title,
                                                  subTitle: type.subTitle,
                                                  rightClosure: nil,
                                                  checkClosure: { [weak self] isChecked in
                    self?.checkedArr[UserAgreementType.age.rawValue] = isChecked
                })
            case .marketing:
                cellView = UserAgreement_CellView(title: type.title,
                                                  subTitle: type.subTitle,
                                                  rightClosure: nil,
                                                  checkClosure: { [weak self] isChecked in
                    self?.checkedArr[UserAgreementType.marketing.rawValue] = isChecked
                })
            }
            back.addSubviews(cellView)
            NSLayoutConstraint.activate([
                cellView.topAnchor.constraint(equalTo: nxtTopAnchor),
                cellView.leftAnchor.constraint(equalTo: back.leftAnchor),
                cellView.rightAnchor.constraint(equalTo: back.rightAnchor),
                cellView.heightAnchor.constraint(equalToConstant: 60)
            ])
            cellSubViews.append(cellView)
            nxtTopAnchor = cellView.bottomAnchor
        }
    }
    
    private func goToWebVC(_ type: UserAgreementType) {
        let webVc = UIViewController()
//            webVc = type
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
            self?.present(vc, animated: true)
        }, for: .touchUpInside)
        bottomButton.isEnabled = false
        self.bottomButton = bottomButton
    }
}
