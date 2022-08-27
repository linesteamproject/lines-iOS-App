//
//  StickerBackColorButton.swift
//  lines_iOS
//
//  Created by mun on 2022/08/23.
//

import UIKit

class StickerBackColorButton: UIButton {
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.layer.borderColor = Colors.white.value.cgColor
                self.layer.borderWidth = 2
            } else {
                self.layer.borderWidth = 0
            }
        }
    }
    var type: StickerBackType! {
        didSet { self.backgroundColor = type.color }
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
    }
}
