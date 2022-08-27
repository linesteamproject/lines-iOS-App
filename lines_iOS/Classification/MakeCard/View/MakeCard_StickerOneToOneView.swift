//
//  MakeCard_StickerOneToOneView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/21.
//

import UIKit

class MakeCard_StickerOneToOneView: MakeCard_StickerView {
    override var imgBackName: String {
        get { return "StickerOne2OneBack" }
        set { }
    }
    override var imgName: String {
        get { return "StickerOne2One" }
        set { }
    }
    override var imgIllustName: String {
        get { return "IllustOne2One"}
        set { }
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            contentsLabel.topAnchor.constraint(equalTo: stickerFrame.topAnchor,
                                       constant: 51),
            contentsLabel.leftAnchor.constraint(equalTo: stickerFrame.leftAnchor,
                                        constant: 41),
            contentsLabel.rightAnchor.constraint(equalTo: stickerFrame.rightAnchor,
                                         constant: -41),
            contentsLabel.bottomAnchor.constraint(equalTo: stickerFrame.bottomAnchor,
                                          constant: -81),
            
            illustImageView.rightAnchor.constraint(equalTo: stickerFrame.rightAnchor,
                                                   constant: -10.86),
            illustImageView.bottomAnchor.constraint(equalTo: stickerFrame.bottomAnchor,
                                                    constant: -22.04)
        ])
    }
}

