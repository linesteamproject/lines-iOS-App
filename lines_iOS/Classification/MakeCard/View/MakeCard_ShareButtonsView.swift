//
//  MakeCard_ShareButtonsView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/29.
//

import UIKit

class MakeCard_ShareButtonsView: UIView {
    internal var shareInstaClosure: (() -> Void)?
    internal var downloadClosure: (() -> Void)?
    internal var shareAnotherClosure: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func setUI() {
        let back = UIView()
        self.addSubviews(back)
        NSLayoutConstraint.activate([
            back.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            back.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            back.widthAnchor.constraint(equalToConstant: 239),
            back.heightAnchor.constraint(equalToConstant: 83),
        ])
        
        var leftAnchor = back.leftAnchor
        var leftConst: CGFloat = 0
        MakeCard_ShareButtonsType.allCases.forEach {
            let btn = UIButton()
            back.addSubviews(btn)
            
            NSLayoutConstraint.activate([
                btn.widthAnchor.constraint(equalToConstant: 63),
                btn.leftAnchor.constraint(equalTo: leftAnchor, constant: leftConst),
                btn.topAnchor.constraint(equalTo: self.topAnchor),
                btn.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
            btn.setImage(UIImage(named: $0.imgName), for: .normal)
            switch $0 {
            case .insta:
                leftAnchor = btn.rightAnchor
                leftConst = 25
                btn.addAction(UIAction { [weak self] _ in
                    self?.shareInstaClosure?()
                }, for: .touchUpInside)
            case .save:
                leftAnchor = btn.rightAnchor
                leftConst = 25
                btn.addAction(UIAction { [weak self] _ in
                    self?.downloadClosure?()
                }, for: .touchUpInside)
            case .shareExt:
                btn.rightAnchor.constraint(equalTo: back.rightAnchor).isActive = true
                btn.addAction(UIAction { [weak self] _ in
                    self?.shareAnotherClosure?()
                }, for: .touchUpInside)
            }
        }
    }
}
