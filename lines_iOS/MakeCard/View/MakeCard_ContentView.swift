//
//  MakeCard_ContentView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/13.
//

import UIKit

class MakeCard_ContentView: UIView, UITextViewDelegate {
    private weak var textCountLabel: UILabel!
    internal weak var txtView: UITextView!
    internal var isTxtViewEmptyClosure: ((Bool) -> Void)?
    init(_ text: String?) {
        super.init(frame: .zero)
        setUI(text)
    }
    required init?(coder: NSCoder) { fatalError() }
    private func setUI(_ text: String?) {
        let back = UIView()
        self.addSubviews(back)
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: self.topAnchor),
            back.leftAnchor.constraint(equalTo: self.leftAnchor,
                                       constant: 20),
            back.rightAnchor.constraint(equalTo: self.rightAnchor,
                                       constant: -20),
            back.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        back.backgroundColor = Colors.gray222222.value
        back.layer.cornerRadius = 10
        let txtView = UITextView()
        back.addSubviews(txtView)
        NSLayoutConstraint.activate([
            txtView.topAnchor.constraint(equalTo: back.topAnchor,
                                        constant: 24),
            txtView.leftAnchor.constraint(equalTo: back.leftAnchor,
                                         constant: 24),
            txtView.rightAnchor.constraint(equalTo: back.rightAnchor,
                                          constant: -24),
            txtView.heightAnchor.constraint(greaterThanOrEqualToConstant: 274),
            txtView.bottomAnchor.constraint(equalTo: back.bottomAnchor,
                                           constant: -24)
        ])
        txtView.backgroundColor = .clear
        
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let btnDoneBar = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneBtnClicked))
        toolBarKeyboard.items = [.flexibleSpace(), btnDoneBar]
        toolBarKeyboard.tintColor = Colors.beige.value
        txtView.inputAccessoryView = toolBarKeyboard
        
        if let text = text {
            txtView.text = text
            txtView.textColor = Colors.white.value
        } else {
            txtView.text = "텍스트를 입력해 주세요."
            txtView.textColor = Colors.white.value.withAlphaComponent(0.3)
        }
        txtView.font = Fonts.get(size: 20,
                                 type: .regular)
        txtView.delegate = self
        txtView.returnKeyType = .done
        self.txtView = txtView
        
        let label = UILabel()
        back.addSubviews(label)
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: txtView.bottomAnchor,
                                         constant: -24),
            label.rightAnchor.constraint(equalTo: txtView.rightAnchor,
                                        constant: -24)
        ])
        let str = String(format: "%d/%d", text?.count ?? 0, 130)
        label.setTitle(str, font: Fonts.get(size: 16, type: .regular),
                       txtColor: .gray777777)
        self.textCountLabel = label
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtView.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "텍스트를 입력해 주세요." {
            textView.text = ""
            textView.textColor = Colors.white.value
        }
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let strRange = Range(range, in: currentText)
        else { return false }
        let changed = currentText.replacingCharacters(in: strRange, with: text)
        
        guard changed.count < 130 else { return false }
        let str = String(format: "%d/%d", changed.count , 130)
        self.textCountLabel.setTitle(str)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text?.isEmpty == true {
            textView.text = "텍스트를 입력해 주세요."
            textView.textColor = Colors.white.value.withAlphaComponent(0.3)
            isTxtViewEmptyClosure?(true)
        } else {
            isTxtViewEmptyClosure?(false)
        }
        self.txtView.endEditing(true)
    }
    @objc
    private func doneBtnClicked() {
        self.txtView.endEditing(true)
    }
}
