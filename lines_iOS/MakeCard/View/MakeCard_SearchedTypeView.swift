//
//  MakeCard_SearchedTypeView.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import UIKit

class MakeCard_SearchedTypeView: UIView {
    private weak var textField: UITextField!
    internal var typeClosure: ((MakeCard_SearchButtonType) -> Void)?
    internal var searchClosure: (() -> Void)?
    internal var buttons = [MakeCard_SearchedTypeViewButton]()
    internal var delegate: UITextFieldDelegate?
    internal var searchedTxt: String? {
        didSet { textField.text = searchedTxt }
    }
    private weak var stackView: UIStackView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Colors.gray222222.value
        setStackView()
        setTextFieldView()
    }
    
    required init?(coder: NSCoder) { super.init(coder: coder) }
    deinit { buttons.removeAll() }
    
    private func setStackView() {
        let stackView = UIStackView()
        self.addSubviews(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor,
                                           constant: 18),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor,
                                            constant: 20),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor,
                                             constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 38),
        ])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        MakeCard_SearchButtonType.allCases.forEach { type in
            let btn = MakeCard_SearchedTypeViewButton()
            stackView.addArrangedSubview(btn)
            btn.type = type
            btn.isSelected = type == .bookName
            btn.setTitle(type.rawValue,
                         for: .normal)
            btn.titleLabel?.setTitle(font: Fonts.get(size: 16,
                                                     type: .bold),
                                     txtColor: .beige)
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
            textField.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            textField.heightAnchor.constraint(equalToConstant: 25),
            textField.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                              constant: -29)
        ])
        textField.font = Fonts.get(size: 18, type: .regular)
        textField.textColor = Colors.white.value
        textField.returnKeyType = .done
        textField.delegate = self.delegate
        self.textField = textField
        
        let line = UIView()
        self.addSubviews(line)
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: textField.bottomAnchor,
                                      constant: 8),
            line.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            line.rightAnchor.constraint(equalTo: textField.rightAnchor),
            line.heightAnchor.constraint(equalToConstant: 1),
        ])
        line.backgroundColor = Colors.beige.value
        
        let btn = UIButton()
        self.addSubviews(btn)
        NSLayoutConstraint.activate([
            btn.leftAnchor.constraint(equalTo: textField.rightAnchor,
                                      constant: 10),
            btn.widthAnchor.constraint(equalToConstant: 66),
            btn.heightAnchor.constraint(equalToConstant: 44),
            btn.rightAnchor.constraint(equalTo: self.rightAnchor,
                                       constant: -20),
            btn.bottomAnchor.constraint(equalTo: line.bottomAnchor),
        ])
        btn.setTitle("검색", font: Fonts.get(size: 16, type: .bold),
                     txtColor: .black, backColor: .beige)
        btn.layer.cornerRadius = 22
        btn.addAction(UIAction { [weak self] _ in
            ReadTextController.shared.searchModel.updateStr(textField.text)
            self?.searchClosure?()
            self?.endEditing(true)
        }, for: .touchUpInside)
    }
}
