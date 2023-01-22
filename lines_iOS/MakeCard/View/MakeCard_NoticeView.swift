//
//  MakeCard_NoticeView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/13.
//

import UIKit

class MakeCard_NoticeView: UIView {
    private weak var label: UILabel!
    internal var noticeStr: String? {
        didSet { label.setTitle(noticeStr) }
    }
    var showImgClosure: ((UIImage?) -> Void)?
    init(_ image: UIImage?) {
        super.init(frame: .zero)
        setUI(image)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setUI(_ image: UIImage?) {
        let imgView = UIImageView(image: image)
        self.addSubviews(imgView)
        NSLayoutConstraint.activate([
            imgView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imgView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            imgView.widthAnchor.constraint(equalToConstant: 57),
            imgView.heightAnchor.constraint(equalToConstant: 57)
        ])
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = 10
        imgView.layer.borderColor = Colors.white.value.withAlphaComponent(0.2).cgColor
        imgView.layer.borderWidth = 1
        
        let magnifier = UIImageView(image: UIImage(named: "Magnifier"))
        self.addSubviews(magnifier)
        NSLayoutConstraint.activate([
            magnifier.rightAnchor.constraint(equalTo: imgView.rightAnchor, constant: -4),
            magnifier.bottomAnchor.constraint(equalTo: imgView.bottomAnchor, constant: -4),
            magnifier.widthAnchor.constraint(equalToConstant: 23),
            magnifier.heightAnchor.constraint(equalToConstant: 23),
        ])
        let button = UIButton()
        self.addSubviews(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: imgView.topAnchor),
            button.leftAnchor.constraint(equalTo: imgView.leftAnchor),
            button.rightAnchor.constraint(equalTo: imgView.rightAnchor),
            button.bottomAnchor.constraint(equalTo: imgView.bottomAnchor)
        ])
        button.addAction(UIAction { [weak self] _ in
            self?.showImgClosure?(image)
        }, for: .touchUpInside)
        if image == UIImage(named: "EmptyBookImage") {
            button.isUserInteractionEnabled = false
            magnifier.isHidden = true
        }
        let label = UILabel()
        self.addSubviews(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 31.5),
            label.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 18),
            label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -44),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -31.5)
        ])
        label.numberOfLines = 0
        label.setTitle(font: Fonts.get(size: 16, type: .regular),
                       txtColor: .white)
        self.label = label
    }
}
