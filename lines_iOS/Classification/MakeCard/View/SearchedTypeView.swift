//
//  SearchedTypeView.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation
import UIKit

class BackColorButton: UIButton {
    override var isSelected: Bool {
        didSet { setColor() }
    }
    private func setColor() {
        if isSelected {
            self.setTitleColor(Colors.white.value,
                               for: .normal)
            self.backgroundColor = .systemBlue
        } else {
            self.setTitleColor(Colors.black.value,
                               for: .normal)
            self.backgroundColor = .clear
        }
    }
}
class SearchedTypeView: UIView {
    private weak var textField: UITextField!
    internal var typeClosure: ((ButtonType) -> Void)?
    internal var searchClosure: ((String?) -> Void)?
    internal var buttons = [BackColorButton]()
    internal var searchedTxt: String? {
        didSet { textField.text = searchedTxt }
    }
    private weak var stackView: UIStackView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStackView()
        setTextFieldView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setStackView() {
        let stackView = UIStackView()
        self.addSubviews(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                           constant: 20),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor,
                                            constant: 20),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor,
                                             constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 60),
        ])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        ButtonType.allCases.forEach { type in
            let btn = BackColorButton()
            stackView.addArrangedSubview(btn)
            btn.isSelected = false
            btn.setTitle(type.rawValue,
                         for: .normal)
            btn.titleLabel?.setTitle(font: .systemFont(ofSize: 16),
                                     txtColor: .black)
            btn.addAction(UIAction { [weak self] _ in
                self?.buttons.forEach { $0.isSelected = false }
                btn.isSelected = true
                self?.typeClosure?(type)
            }, for: .touchUpInside)
            
            buttons.append(btn)
        }
        
        self.stackView = stackView
    }
    
    private func setTextFieldView() {
        let textField = UITextField()
        self.addSubviews(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            textField.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            textField.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1)
        ])
        textField.textColor = .black
        self.textField = textField
        
        let line = UIView()
        self.addSubviews(line)
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: textField.bottomAnchor),
            line.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            line.rightAnchor.constraint(equalTo: textField.rightAnchor),
            line.heightAnchor.constraint(equalToConstant: 1),
        ])
        line.backgroundColor = .gray.withAlphaComponent(0.7)
        
        let btn = UIButton()
        self.addSubviews(btn)
        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: textField.topAnchor),
            btn.leftAnchor.constraint(equalTo: textField.rightAnchor, constant: 8),
            btn.widthAnchor.constraint(equalToConstant: 40),
            btn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            btn.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
        ])
        btn.setTitle("검색", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 12
        btn.backgroundColor = .purple
        btn.addAction(UIAction { [weak self] _ in
            self?.searchClosure?(textField.text)
            self?.endEditing(true)
        }, for: .touchUpInside)
    }
}
