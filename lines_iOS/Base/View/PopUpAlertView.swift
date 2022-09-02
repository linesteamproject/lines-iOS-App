//
//  PopUpAlertView.swift
//  lines_iOS
//
//  Created by mun on 2022/09/03.
//

import UIKit

class PopUpAlertView: UIView {
    private weak var contentsView: UIView!
    private weak var titleLabel: UILabel!
    private weak var subTitleLabel: UILabel!
    internal var title: String? {
        didSet { titleLabel.setTitle(title, font: Fonts.get(size: 16, type: .medium),
                                     txtColor: .black) }
    }
    internal var subTitle: String? {
        didSet { subTitleLabel.setTitleHasLineSpace(subTitle,
                                                    font: Fonts.get(size: 12, type: .light),
                                                    color: .gray,
                                                    textAlignment: .center) }
    }
    internal var cancelBtnClosure: (() -> Void)?
    internal var okBtnClosure: (() -> Void)?
    init(height: CGFloat) {
        super.init(frame: .zero)
        
        setBackground()
        setContentsUI(height)
        setTitleLabel()
        setSubTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setBackground() {
        self.backgroundColor = Colors.black.value.withAlphaComponent(0.4)
    }
    
    private func setContentsUI(_ height: CGFloat) {
        let view = UIView()
        self.addSubviews(view)
        
        let topConst: CGFloat = (UIScreen.main.bounds.height / 2) - (height / 2)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: topConst),
            view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: height)
        ])
        view.backgroundColor = Colors.white.value
        view.layer.cornerRadius = 8
        contentsView = view
    }
    
    private func setTitleLabel() {
        let title = UILabel()
        self.contentsView.addSubviews(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 16),
            title.centerXAnchor.constraint(equalTo: contentsView.centerXAnchor),
            title.leftAnchor.constraint(equalTo: contentsView.leftAnchor, constant: 16),
            title.rightAnchor.constraint(equalTo: contentsView.rightAnchor, constant: -16),
        ])
        
        title.numberOfLines = 0
        title.textAlignment = .center
        title.setTitle(font: Fonts.get(size: 16, type: .medium),
                       txtColor: .black)
        self.titleLabel = title
    }
    
    private func setSubTitleLabel() {
        let sub = UILabel()
        self.contentsView.addSubviews(sub)
        NSLayoutConstraint.activate([
            sub.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 52),
            sub.centerXAnchor.constraint(equalTo: contentsView.centerXAnchor),
            sub.leftAnchor.constraint(equalTo: contentsView.leftAnchor, constant: 42.5),
            sub.rightAnchor.constraint(equalTo: contentsView.rightAnchor, constant: -42.5),
        ])
        
        sub.numberOfLines = 0
        sub.textAlignment = .center
        self.subTitleLabel = sub
    }
    
    internal func setOkButton(str: String, backColor: UIColor? = nil) {
        let button = UIButton()
        self.contentsView.addSubviews(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 20),
            button.leftAnchor.constraint(equalTo: contentsView.leftAnchor, constant: 16),
            button.rightAnchor.constraint(equalTo: contentsView.rightAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])
        button.layer.cornerRadius = 16
        button.backgroundColor = backColor ?? Colors.beige.value
        button.setTitle(str, font: Fonts.get(size: 16, type: .bold), txtColor: .black)
        button.addAction(UIAction { [weak self] _ in
            self?.removeFromSuperview()
            self?.okBtnClosure?()
        }, for: .touchUpInside)
    }
    
    internal func setCancelOkButton(cancel: String, ok: String) {
        let cancelButton = UIButton()
        let okButton = UIButton()
        self.contentsView.addSubviews(cancelButton, okButton)
        [cancelButton, okButton].forEach {
            $0.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 20).isActive = true
            $0.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor, constant: -16).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 48).isActive = true
        }
        
        NSLayoutConstraint.activate([
            cancelButton.leftAnchor.constraint(equalTo: contentsView.leftAnchor, constant: 16),
            cancelButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 144),
            okButton.leftAnchor.constraint(equalTo: cancelButton.rightAnchor, constant: 8),
            okButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            okButton.rightAnchor.constraint(equalTo: contentsView.rightAnchor, constant: -16),
        ])
        
        cancelButton.setTitle(cancel, font: Fonts.get(size: 16, type: .bold),
                              txtColor: .white, backColor: .gray)
        okButton.setTitle(cancel, font: Fonts.get(size: 16, type: .bold),
                          txtColor: .black, backColor: .beige)
        
        cancelButton.isUserInteractionEnabled = true
        cancelButton.addAction(UIAction { [weak self] _ in
            self?.removeFromSuperview()
            self?.cancelBtnClosure?()
        }, for: .touchUpInside)
        
        okButton.addAction(UIAction { [weak self] _ in
            self?.removeFromSuperview()
            self?.okBtnClosure?()
        }, for: .touchUpInside)
    }
}
