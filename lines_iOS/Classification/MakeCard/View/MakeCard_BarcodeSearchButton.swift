//
//  MakeCard_BarcodeSearchButton.swift
//  lines_iOS
//
//  Created by mun on 2022/08/28.
//

import UIKit

class MakeCard_BarcodeSearchButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.borderColor = Colors.beige.value.cgColor
        self.layer.borderWidth = 1
    }
    
    private func setUI() {
        self.setTitle("바코드로 검색",
                      font: Fonts.get(size: 18,
                                      type: .bold),
                      txtColor: .beige,
                      backColor: .black)
    }
}
