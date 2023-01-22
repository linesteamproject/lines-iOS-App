//
//  MakeCard_StickerBackColorSetView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/23.
//

import UIKit

class MakeCard_StickerBackColorSetView: UIView {
    internal var colorBtnClosure: ((MakeCard_StickerBackColorType?) -> Void)?
    private var btns = [MakeCard_StickerBackColorButton]()
    deinit { btns.removeAll() }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        setUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func setUI() {
        let label = UILabel()
        self.addSubviews(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leftAnchor.constraint(equalTo: self.leftAnchor),
            label.widthAnchor.constraint(equalToConstant: 28),
            label.heightAnchor.constraint(equalToConstant: 22),
        ])
        label.setTitle("배경",
                       font: Fonts.get(size: 16, type: .regular),
                       txtColor: .white)
        var nxtLeftAnchor = label.rightAnchor
        var nxtConst: CGFloat = 35
        MakeCard_StickerBackColorType.allCases.forEach { type in
            let btn = MakeCard_StickerBackColorButton()
            self.addSubviews(btn)
            NSLayoutConstraint.activate([
                btn.topAnchor.constraint(equalTo: self.topAnchor),
                btn.leftAnchor.constraint(equalTo: nxtLeftAnchor, constant: nxtConst),
                btn.widthAnchor.constraint(equalToConstant: 39),
                btn.heightAnchor.constraint(equalToConstant: 39),
                btn.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
            
            btn.type = type
            btn.isSelected = btn.type == .black
            btn.addAction( UIAction { [weak self] _ in
                self?.btns.forEach { $0.isSelected = false }
                if let idx = self?.btns.firstIndex(where: { $0.type == type }) {
                    self?.btns[idx].isSelected = true
                }
                
                self?.colorBtnClosure?(type)
            }, for: .touchUpInside)
            
            self.btns.append(btn)
            nxtLeftAnchor = btn.rightAnchor
            nxtConst = 10
        }
    }
}

