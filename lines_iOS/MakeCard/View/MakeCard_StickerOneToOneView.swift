//
//  MakeCard_StickerOneToOneView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/21.
//

import UIKit

class MakeCard_StickerOneToOneView: MakeCard_StickerView {
    override var imgBackName: String {
        get { return "One2One" + self.color.name }
        set { }
    }
    override var bookInfoBottomConstant: CGFloat {
        get { return -54.31 }
        set { }
    }
    override func setConstraints() {
        NSLayoutConstraint.activate([
            backImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-30),
            backImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-30),
            contentsLabel.topAnchor.constraint(equalTo: backImageView.topAnchor,
                                       constant: 77),
            contentsLabel.leftAnchor.constraint(equalTo: backImageView.leftAnchor,
                                        constant: 70),
            contentsLabel.rightAnchor.constraint(equalTo: backImageView.rightAnchor,
                                         constant: -70),
            contentsLabel.bottomAnchor.constraint(equalTo: backImageView.bottomAnchor,
                                          constant: -88),
        ])
    }
}

