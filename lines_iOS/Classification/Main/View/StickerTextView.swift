//
//  StickerTextView.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import UIKit

class StickerTextView: UIView {
    internal weak var backView: UIView!
    internal weak var stickerView: UIView!
    private weak var label: UILabel!
    internal var str: String? {
        didSet { label.setTitle(str) }
    }
    internal var closure: (() -> Void)?
    init(_ size: CGSize) {
        super.init(frame: .zero)
        setUI(size)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func setUI(_ size: CGSize) {
        let back = UIView()
        self.addSubViews(back)
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: self.topAnchor),
            back.leftAnchor.constraint(equalTo: self.leftAnchor),
            back.rightAnchor.constraint(equalTo: self.rightAnchor),
            back.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        back.backgroundColor = Colors.black.value.withAlphaComponent(0.7)
        self.backView = back
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(close))
        back.addGestureRecognizer(gesture)
        
        let stickerView = UIView()
        back.addSubViews(stickerView)
        NSLayoutConstraint.activate([
            stickerView.centerXAnchor.constraint(equalTo: back.centerXAnchor),
            stickerView.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            stickerView.widthAnchor.constraint(equalToConstant: size.width),
            stickerView.heightAnchor.constraint(equalToConstant: size.height),
        ])
        self.stickerView = stickerView
        
        let stickerBack = UIColor.random()
        stickerView.backgroundColor = stickerBack
        
        let label = UILabel()
        stickerView.addSubViews(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: stickerView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: stickerView.centerYAnchor),
            label.topAnchor.constraint(equalTo: stickerView.topAnchor, constant: 40),
            label.leftAnchor.constraint(equalTo: stickerView.leftAnchor, constant: 20),
            label.rightAnchor.constraint(equalTo: stickerView.rightAnchor, constant: -20),
            label.bottomAnchor.constraint(equalTo: stickerView.bottomAnchor, constant: -40),
        ])
//        label.setTitle(font: .italicSystemFont(ofSize: 13),
//                       txtColor: stickerBack.getContrast())
        label.numberOfLines = 0
        self.label = label
    }
    
    @objc
    private func close() {
        self.removeFromSuperview()
        self.closure?()
    }
}

