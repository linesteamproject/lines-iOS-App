//
//  MakeCard_NoticeView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/13.
//

import UIKit

class MakeCard_NoticeView: UIView {
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
        
        let label = UILabel()
        self.addSubviews(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: imgView.topAnchor),
            label.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 18),
            label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -44),
            label.bottomAnchor.constraint(equalTo: imgView.bottomAnchor)
        ])
        label.numberOfLines = 0
        label.setTitle("인식한 문장을 확인해 주세요.\n줄바꿈, 오타 등을 직접 수정해 주세요.",
                       font: Fonts.get(size: 16, type: .regular),
                       txtColor: .white)
    }
}
