//
//  MakeCard_StickerContentFontSetView.swift
//  lines_iOS
//
//  Created by mun on 2023/01/22.
//

import UIKit

class MakeCard_StickerContentFontSetView: UIView {
    private var btns = [MakeCard_StickerContentFontButton]()
    internal var selectedFont: 폰트! {
        didSet {
            self.btns.forEach {
                $0.isSelected = $0.font == selectedFont }
        }
    }
    internal var fontBtnClosure: ((폰트) -> Void)?
    deinit {
        btns.forEach { $0.removeFromSuperview() }
        btns.removeAll()
    }
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        let label = UILabel()
        self.addSubviews(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leftAnchor.constraint(equalTo: self.leftAnchor),
        ])
        label.setTitle("서체",
                       font: Fonts.get(size: 16,
                                       type: .bold),
                       txtColor: .white)
        
        var nextLeftAnchor = self.leftAnchor
        var nextLeftMargin = 35.0+28.0
        폰트.allCases.forEach { font in
            let btn = MakeCard_StickerContentFontButton()
            self.addSubviews(btn)
            NSLayoutConstraint.activate([
                btn.topAnchor.constraint(equalTo: self.topAnchor,
                                        constant: 18),
                btn.leftAnchor.constraint(equalTo: nextLeftAnchor,
                                          constant: nextLeftMargin),
                btn.widthAnchor.constraint(equalToConstant: 39),
                btn.heightAnchor.constraint(equalToConstant: 39),
                btn.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                           constant: -18),
            ])
            btn.font = font
            btn.isSelected = font == 폰트.나눔명조
            btn.addAction(UIAction { [weak self] _ in
                self?.btns.forEach {
                    $0.isSelected = $0.font == font }
                self?.fontBtnClosure?(font)
            }, for: .touchUpInside)
            self.btns.append(btn)
            
            nextLeftAnchor = btn.rightAnchor
            nextLeftMargin = 10
        }
    }
}
