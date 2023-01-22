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
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            backImageView.widthAnchor.constraint(equalToConstant: 345),
            contentsLabel.topAnchor.constraint(equalTo: backImageView.topAnchor,
                                       constant: 51),
            contentsLabel.leftAnchor.constraint(equalTo: backImageView.leftAnchor,
                                        constant: 41),
            contentsLabel.rightAnchor.constraint(equalTo: backImageView.rightAnchor,
                                         constant: -41),
            contentsLabel.bottomAnchor.constraint(equalTo: backImageView.bottomAnchor,
                                          constant: -81),
        ])
    }
}

