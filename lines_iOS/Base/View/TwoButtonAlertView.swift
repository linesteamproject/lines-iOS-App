//
//  TwoButtonAlertView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/21.
//

import UIKit

class TwoButtonAlertView: AlertView {
    private var nextTopAnchor: NSLayoutYAxisAnchor!
    internal var closure: (() -> Void)?
    override func addtionalUI() {
        contentsView.heightAnchor
                    .constraint(lessThanOrEqualToConstant: 186).isActive = true
        setTitleView()
        setSubTitleView()
        setButtons()
    }
    
    private func setTitleView() {
        let title = UILabel()
        self.addSubviews(title)
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: contentsView.centerXAnchor),
            title.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 15),
            title.heightAnchor.constraint(equalToConstant: 56)
        ])
        title.setTitle("문장 기록 나가기", font: Fonts.get(size: 22, type: .regular),
                       txtColor: .black)
        self.nextTopAnchor = title.bottomAnchor
        
        let button = UIButton()
        self.addSubviews(button)
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            button.rightAnchor.constraint(equalTo: contentsView.rightAnchor,
                                          constant: -25),
            button.widthAnchor.constraint(equalToConstant: 20),
            button.heightAnchor.constraint(equalToConstant: 20)
        ])
        button.setImage(UIImage(named: "IconX")?
                            .withTintColor(Colors.black.value),
                        for: .normal)
        button.addAction(UIAction { [weak self] _ in
            self?.removeFromSuperview()
            self?.closure?()
        }, for: .touchUpInside)
    }
    
    private func setSubTitleView() {
        let line = UIView()
        self.addSubviews(line)
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: nextTopAnchor),
            line.leftAnchor.constraint(equalTo: contentsView.leftAnchor),
            line.rightAnchor.constraint(equalTo: contentsView.rightAnchor),
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
        line.backgroundColor = Colors.black.value.withAlphaComponent(0.2)
        
        let label = UILabel()
        self.addSubviews(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: line.topAnchor, constant: 20),
            label.leftAnchor.constraint(equalTo: contentsView.leftAnchor, constant: 51),
            label.rightAnchor.constraint(equalTo: contentsView.rightAnchor, constant: -51),
            label.heightAnchor.constraint(lessThanOrEqualToConstant: 42),
        ])
        let str = "문장 기록 페이지에서 나가시겠습니까?\n진행중이던 내용이 모두 버려집니다."
        label.numberOfLines = 0
        label.setTitleHasLineSpace(str,
                                   lineSpaceVal: 10,
                                   font: Fonts.get(size: 14, type: .regular),
                                   color: .black, textAlignment: .center)
        
        self.nextTopAnchor = label.bottomAnchor
    }
    
    private func setButtons() {
        let leftButton = UIButton()
        let rightButton = UIButton()
        self.addSubviews(leftButton, rightButton)
        
        
        NSLayoutConstraint.activate([
            leftButton.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor),
            leftButton.leftAnchor.constraint(equalTo: contentsView.leftAnchor),
            leftButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 158),
            leftButton.heightAnchor.constraint(equalToConstant: 48),
            
            rightButton.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor),
            rightButton.rightAnchor.constraint(equalTo: contentsView.rightAnchor),
            rightButton.leftAnchor.constraint(equalTo: leftButton.rightAnchor),
            rightButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        let leftBtnWidthAnchor = leftButton.widthAnchor
        rightButton.widthAnchor.constraint(equalTo: leftBtnWidthAnchor).isActive = true
        
        leftButton.setTitle("취소",
                            font: Fonts.get(size: 18, type: .bold),
                            txtColor: .black)
        rightButton.setTitle("확인",
                             font: Fonts.get(size: 18, type: .bold),
                             txtColor: .highlight)
        leftButton.addAction(UIAction { [weak self] _ in
            self?.removeFromSuperview()
        }, for: .touchUpInside)
        rightButton.addAction(UIAction { [weak self] _ in
            self?.removeFromSuperview()
            self?.closure?()
        }, for: .touchUpInside)
    }
}
