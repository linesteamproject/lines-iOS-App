//
//  MakeCard_StickerSetView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/21.
//

import UIKit

class MakeCard_StickerSetView: UIView {
    private weak var nextTopAnchor: NSLayoutYAxisAnchor!
    internal var colorBtnClosure: ((MakeCard_StickerBackColorType?) -> Void)?
    internal var leftBtnClosure: (() -> Void)?
    internal var rightBtnClosure: (() -> Void)?
    
    private var proportionBtns = [MakeCard_SelectProportionButtonView]()
    deinit { proportionBtns.removeAll() }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        setButtons()
        setLine()
        setColorsButton()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func setButtons() {
        let label = UILabel()
        self.addSubviews(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 19),
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            label.widthAnchor.constraint(equalToConstant: 28),
            label.heightAnchor.constraint(equalToConstant: 22)
        ])
        label.setTitle("비율",
                       font: Fonts.get(size: 16, type: .regular),
                       txtColor: .white)
        
        let leftBtn = MakeCard_SelectProportionButtonView()
        let rightBtn = MakeCard_SelectProportionButtonView()
        self.addSubviews(leftBtn, rightBtn)
        NSLayoutConstraint.activate([
            leftBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            leftBtn.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 35),
            leftBtn.widthAnchor.constraint(equalToConstant: 120),
            leftBtn.heightAnchor.constraint(equalToConstant: 34),
            
            rightBtn.topAnchor.constraint(equalTo: leftBtn.topAnchor),
            rightBtn.leftAnchor.constraint(equalTo: leftBtn.rightAnchor),
            rightBtn.widthAnchor.constraint(equalToConstant: 120),
            rightBtn.heightAnchor.constraint(equalToConstant: 34),
        ])
        
        leftBtn.type = .one2one
        rightBtn.type = .three2Four
        leftBtn.isSelected = true
        rightBtn.isSelected = false
        leftBtn.addAction(UIAction { [weak self] _ in
            rightBtn.isSelected = false
            leftBtn.isSelected = true
            self?.leftBtnClosure?()
        }, for: .touchUpInside)
        rightBtn.addAction(UIAction { [weak self] _ in
            rightBtn.isSelected = true
            leftBtn.isSelected = false
            self?.rightBtnClosure?()
        }, for: .touchUpInside)
        
        let subLabel = UILabel()
        self.addSubviews(subLabel)
        NSLayoutConstraint.activate([
            subLabel.topAnchor.constraint(equalTo: leftBtn.bottomAnchor, constant: 4),
            subLabel.leftAnchor.constraint(equalTo: leftBtn.leftAnchor),
            subLabel.heightAnchor.constraint(equalToConstant: 21)
        ])
        subLabel.setTitle("*SNS 게시글 업로드 등",
                          font: Fonts.get(size: 12, type: .bold),
                          txtColor: .gray)
        
        self.nextTopAnchor = subLabel.bottomAnchor
    }
    
    private func setLine() {
        let line = UIView()
        self.addSubviews(line)
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: nextTopAnchor, constant: 12),
            line.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            line.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
        line.backgroundColor = Colors.gray.value
        self.nextTopAnchor = line.bottomAnchor
    }
    
    private func setColorsButton() {
        let colorSetView = MakeCard_StickerBackColorSetView()
        self.addSubviews(colorSetView)
        NSLayoutConstraint.activate([
            colorSetView.topAnchor.constraint(equalTo: nextTopAnchor,
                                              constant: 18),
            colorSetView.leftAnchor.constraint(equalTo: self.leftAnchor,
                                              constant: 20),
            colorSetView.rightAnchor.constraint(equalTo: self.rightAnchor,
                                               constant: -20),
            colorSetView.heightAnchor.constraint(equalToConstant: 39),
        ])
        colorSetView.colorBtnClosure = { [weak self] type in
            self?.colorBtnClosure?(type)
        }
        self.nextTopAnchor = colorSetView.bottomAnchor
    }
}
