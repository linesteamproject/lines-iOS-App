//
//  OneButtonAlertView.swift
//  lines_iOS
//
//  Created by mun on 2022/09/03.
//

import UIKit

class OneButtonAlertView: AlertView {
    private var nextTopAnchor: NSLayoutYAxisAnchor!
    private weak var titleLabel: UILabel!
    private weak var subTitleLabel: UILabel!
    internal var closure: (() -> Void)?
    internal var title: String? {
        didSet { titleLabel.setTitle(title) }
    }
    internal var subTitle: String? {
        didSet { subTitleLabel.setTitle(subTitle) }
    }
    override func addtionalUI() {
        contentsView.heightAnchor
                    .constraint(lessThanOrEqualToConstant: 300).isActive = true
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
            title.heightAnchor.constraint(greaterThanOrEqualToConstant: 26)
        ])
        title.numberOfLines = 0
        title.setTitle(font: Fonts.get(size: 22, type: .regular),
                       txtColor: .black)
        self.titleLabel = title
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
        label.numberOfLines = 0
        label.setTitleHasLineSpace(lineSpaceVal: 10,
                                   font: Fonts.get(size: 14, type: .regular),
                                   color: .black, textAlignment: .center)
        self.subTitleLabel = label
        self.nextTopAnchor = label.bottomAnchor
    }
    
    private func setButtons() {
        let okButton = UIButton()
        self.addSubviews(okButton)
        
        
        NSLayoutConstraint.activate([
            okButton.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor),
            okButton.leftAnchor.constraint(equalTo: contentsView.leftAnchor),
            okButton.rightAnchor.constraint(equalTo: contentsView.rightAnchor),
            okButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        okButton.setTitle("확인",
                             font: Fonts.get(size: 18, type: .bold),
                             txtColor: .highlight)
        okButton.addAction(UIAction { [weak self] _ in
            self?.removeFromSuperview()
            self?.closure?()
        }, for: .touchUpInside)
    }
}
