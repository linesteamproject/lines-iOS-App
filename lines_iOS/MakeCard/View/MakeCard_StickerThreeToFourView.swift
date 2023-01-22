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
        get { return "Three2Four" + self.color.name }
        set { }
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            backImageView.widthAnchor.constraint(equalToConstant: 345 / 4 * 3),
            contentsLabel.topAnchor.constraint(equalTo: backImageView.topAnchor,
                                       constant: 51),
            contentsLabel.leftAnchor.constraint(equalTo: backImageView.leftAnchor,
                                        constant: 45),
            contentsLabel.rightAnchor.constraint(equalTo: backImageView.rightAnchor,
                                         constant: -45),
            contentsLabel.bottomAnchor.constraint(equalTo: backImageView.bottomAnchor,
                                          constant: -51),
        ])
    }
}
