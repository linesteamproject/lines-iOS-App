//
//  MakeCard_StickerContentFontButton.swift
//  lines_iOS
//
//  Created by mun on 2023/01/22.
//

import UIKit

class MakeCard_StickerContentFontButton: UIButton {
    internal var font: 폰트 = .나눔명조 {
        didSet { setUI() }
    }
    private func setUI() {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
    
    override var isSelected: Bool {
        didSet { updateUI() }
    }
    
    private func updateUI() {
        if isSelected {
            self.layer.borderWidth = 2
            self.layer.borderColor = Colors.white.value.cgColor
            self.setTitleColor(Colors.white.value.withAlphaComponent(1.0),
                               for: .normal)
        } else {
            self.layer.borderWidth = 1
            self.layer.borderColor = Colors.white.value.withAlphaComponent(0.5).cgColor
            self.setTitle("글",
                          font: self.font.val,
                          txtColor: .white)
            self.setTitleColor(Colors.white.value.withAlphaComponent(0.5),
                               for: .normal)
        }
    }
}
