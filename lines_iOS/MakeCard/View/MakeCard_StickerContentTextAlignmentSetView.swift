//
//  MakeCard_StickerContentTextAlignmentSetView.swift
//  lines_iOS
//
//  Created by mun on 2023/01/28.
//

import UIKit


class MakeCard_StickerContentTextAlignmentSetView: UIView {
    private var btns = [MakeCard_StickerContentTextAlignmentButton]()

    internal var selectedTextAlginment: 텍스트정렬 = .중앙 {
        didSet { btns.forEach { $0.isSelected = selectedTextAlginment == $0.type }}
    }
    internal var textAlignmentClosure: ((텍스트정렬) -> Void)?
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
        label.setTitle("정렬",
                       font: Fonts.get(size: 16,
                                       type: .bold),
                       txtColor: .white)
        
        var nextLeftAnchor = self.leftAnchor
        var nextLeftMargin = 35.0+28.0
        텍스트정렬.allCases.forEach { type in
            let btn = MakeCard_StickerContentTextAlignmentButton()
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
            btn.type = type
            btn.isSelected = type == .중앙
            btn.addAction(UIAction { [weak self] _ in
                self?.btns.forEach {
                    $0.isSelected = $0.type == type }
                self?.textAlignmentClosure?(type)
            }, for: .touchUpInside)
            self.btns.append(btn)
            
            nextLeftAnchor = btn.rightAnchor
            nextLeftMargin = 10
        }
    }
}

