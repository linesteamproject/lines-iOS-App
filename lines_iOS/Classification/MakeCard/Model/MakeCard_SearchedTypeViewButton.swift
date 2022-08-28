//
//  MakeCard_BackColorButton.swift
//  lines_iOS
//
//  Created by mun on 2022/08/28.
//

import UIKit

class MakeCard_SearchedTypeViewButton: UIButton {
    var type: MakeCard_SearchButtonType? {
        didSet { updateUI() }
    }
    
    override var isSelected: Bool {
        didSet { setSelected() }
    }
    
    private func updateUI() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 19
        self.setTitle(type?.rawValue,
                      font: Fonts.get(size: 16, type: .bold),
                      txtColor: .beige)
    }
    
    private func setSelected() {
        if isSelected {
            self.backgroundColor = Colors.black.value
            self.layer.borderColor = Colors.beige.value.cgColor
        } else {
            self.backgroundColor = Colors.clear.value
            self.layer.borderColor = Colors.clear.value.cgColor
        }
    }
}
