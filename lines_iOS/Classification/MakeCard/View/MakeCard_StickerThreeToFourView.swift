//
//  MakeCard_StickerThreeToFourView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/21.
//

import Foundation
import UIKit

class MakeCard_StickerThreeToFourView: MakeCard_StickerView {
    override var imgBackName: String {
        get { return "StickerThree2FourBack" }
        set { }
    }
    override var imgName: String {
        get { return "StickerThree2Four" }
        set { }
    }
    override var imgIllustName: String {
        get { return "IllustThree2Four"}
        set { }
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            contentsLabel.topAnchor.constraint(equalTo: stickerFrame.topAnchor,
                                       constant: 51),
            contentsLabel.leftAnchor.constraint(equalTo: stickerFrame.leftAnchor,
                                        constant: 45),
            contentsLabel.rightAnchor.constraint(equalTo: stickerFrame.rightAnchor,
                                         constant: -45),
            contentsLabel.bottomAnchor.constraint(equalTo: stickerFrame.bottomAnchor,
                                          constant: -51),
            illustImageView.rightAnchor.constraint(equalTo: stickerFrame.rightAnchor,
                                                   constant: -40.15),
            illustImageView.bottomAnchor.constraint(equalTo: stickerFrame.bottomAnchor,
                                                    constant: -20.84)
        ])
    }
}
