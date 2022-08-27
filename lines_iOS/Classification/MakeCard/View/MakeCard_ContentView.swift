//
//  MakeCard_ContentView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/13.
//

import UIKit

class MakeCard_ContentView: UIView, UITextViewDelegate {
    private weak var txtView: UITextView!
    
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
        txtView.text = text
        txtView.font = Fonts.get(size: 20,
                                 type: .regular)
        txtView.textColor = Colors.white.value
        self.txtView = txtView
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtView.endEditing(true)
    }
}
