//
//  MakeCard_StickerContentTextAlignmentButton.swift
//  lines_iOS
//
//  Created by mun on 2023/01/29.
//

import UIKit

class MakeCard_StickerContentTextAlignmentButton: UIButton {
    internal var type: 텍스트정렬 = .중앙
    override var isSelected: Bool {
        didSet { updateUI() }
    }
    private func updateUI() {
        if isSelected {
            self.setBackgroundImage(UIImage(named: type.inactiveImgName),
                                    for: .normal)
        } else {
            self.setBackgroundImage(UIImage(named: type.activeImgName),
                                    for: .normal)
        }
    }
}
