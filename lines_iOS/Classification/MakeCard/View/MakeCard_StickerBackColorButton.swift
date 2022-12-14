//
//  MakeCard_StickerBackColorButton.swift
//  lines_iOS
//
//  Created by mun on 2022/08/23.
//

import UIKit

class MakeCard_StickerBackColorButton: UIButton {
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.layer.borderWidth = 2
                self.layer.borderColor = Colors.white.value.cgColor
            } else {
                self.layer.borderWidth = 1
                self.layer.borderColor = Colors.white.value.withAlphaComponent(0.3).cgColor
            }
        }
    }
    var type: MakeCard_StickerBackColorType! {
        didSet { self.backgroundColor = type.color }
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
    }
}
