//
//  Main_LeftView.swift
//  lines_iOS
//
//  Created by mun on 2022/09/10.
//

import UIKit

enum Main_MenuType: CaseIterable {
    case userAgreement
    case privacyWay
    case readyToBe
    case feedback
    case logout
    var title: String {
        switch self {
        case .userAgreement:
            return "이용약관"
        case .privacyWay:
            return "개인정보처리방침"
        case .readyToBe:
            return "준비중인 기능"
        case .feedback:
            return "의견 및 피드백"
        case .logout:
            if FirstLaunchChecker.isNotLogin {
                return "로그인"
            }
            return "로그아웃"
        }
    }
}

class Main_MenuView: UIView {
    private weak var versionLabel: UILabel!
    internal var cellBtnClosure: ((Main_MenuType) -> Void)?
    internal var closeClosure: (() -> Void)?
    internal var resignClosure: (() ->  Void)?
    internal var version: String? {
        didSet { versionLabel.setTitle(version) }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setUI() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
        
        let listView = UIView()
        self.addSubviews(listView)
        NSLayoutConstraint.activate([
            listView.topAnchor.constraint(equalTo: self.topAnchor),
            listView.leftAnchor.constraint(equalTo: self.leftAnchor),
            listView.rightAnchor.constraint(equalTo: self.rightAnchor,
                                           constant: -135),
            listView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        listView.backgroundColor = Colors.black.value
        
        var nextTopAnchor: NSLayoutYAxisAnchor = listView.topAnchor
        var topConst: CGFloat = 70
        Main_MenuType.allCases.forEach { type in
            let cellButton = UIButton()
            listView.addSubviews(cellButton)
            NSLayoutConstraint.activate([
                cellButton.topAnchor.constraint(equalTo: nextTopAnchor, constant: topConst),
                cellButton.leftAnchor.constraint(equalTo: listView.leftAnchor),
                cellButton.rightAnchor.constraint(equalTo: listView.rightAnchor),
                cellButton.heightAnchor.constraint(equalToConstant: 46),
            ])
            cellButton.setTitle(type.title,
                                font: Fonts.get(size: 16, type: .bold),
                                txtColor: .white)
            cellButton.addAction(UIAction { [weak self] _ in
                self?.cellBtnClosure?(type)
            }, for: .touchUpInside)
            nextTopAnchor = cellButton.bottomAnchor
            topConst = 0
        }
        
        let xButton = UIButton()
        listView.addSubviews(xButton)
        NSLayoutConstraint.activate([
            xButton.topAnchor.constraint(equalTo: listView.topAnchor,
                                         constant: 12),
            xButton.rightAnchor.constraint(equalTo: listView.rightAnchor,
                                           constant: -12),
            xButton.widthAnchor.constraint(equalToConstant: 30),
            xButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        xButton.setImage(UIImage(named: "IconX"), for: .normal)
        xButton.addAction(UIAction { [weak self] _ in
            self?.closeClosure?()
        }, for: .touchUpInside)
        
        let versionLabel = UILabel()
        listView.addSubviews(versionLabel)
        NSLayoutConstraint.activate([
            versionLabel.bottomAnchor.constraint(equalTo: listView.bottomAnchor,
                                          constant: -40),
            versionLabel.centerXAnchor.constraint(equalTo: listView.centerXAnchor),
        ])
        
        versionLabel.setTitle(font: Fonts.get(size: 12, type: .regular),
                       txtColor: .gray777777)
        self.versionLabel = versionLabel
        
        let resignLabel = UILabel()
        listView.addSubviews(resignLabel)
        NSLayoutConstraint.activate([
            resignLabel.bottomAnchor.constraint(equalTo: versionLabel.topAnchor,
                                          constant: -20),
            resignLabel.centerXAnchor.constraint(equalTo: listView.centerXAnchor),
        ])
        resignLabel.setTitle(font: Fonts.get(size: 14, type: .regular),
                             txtColor: .gray777777)
        resignLabel.setUnderline("회원탈퇴")
        
        let resignBtn = UIButton()
        listView.addSubviews(resignBtn)
        NSLayoutConstraint.activate([
            resignBtn.topAnchor.constraint(equalTo: resignLabel.topAnchor),
            resignBtn.leftAnchor.constraint(equalTo: resignLabel.leftAnchor),
            resignBtn.rightAnchor.constraint(equalTo: resignLabel.rightAnchor),
            resignBtn.bottomAnchor.constraint(equalTo: resignLabel.bottomAnchor),
        ])
        resignBtn.addAction(UIAction { [weak self] _ in
            self?.resignClosure?()
        }, for: .touchUpInside)
        
        if FirstLaunchChecker.isNotLogin {
            resignLabel.isHidden = true
            resignBtn.isHidden = true
        }
    }
    
    @objc
    private func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        closeClosure?()
    }
}
