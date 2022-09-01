//
//  MakeCard_SelectProportionButtonView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/21.
//

import UIKit

class MakeCard_SelectProportionButtonView: UIButton {
    private weak var imgView: UIImageView!
    private weak var label: UILabel!
    private weak var subLabel: UILabel!
    
    internal var type: MakeCard_StickerRatioType? {
        didSet { setConstraints() }
    }
    internal override var isSelected: Bool {
        didSet { updateUI() }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func setUI() {
        let imgView = UIImageView()
        let label = UILabel()
        self.addSubviews(imgView, label)
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: self.topAnchor),
            imgView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imgView.widthAnchor.constraint(equalToConstant: 25),
            imgView.heightAnchor.constraint(equalToConstant: 34),
            
            label.centerYAnchor.constraint(equalTo: imgView.centerYAnchor),
            label.leftAnchor.constraint(equalTo: imgView.rightAnchor,
                                        constant: 8)
        ])
        imgView.contentMode = .scaleAspectFit
        imgView.isUserInteractionEnabled = false
        label.isUserInteractionEnabled = false
        self.imgView = imgView
        self.label = label
    }
    
    private func setConstraints() {
        guard let type = type else { return }
        imgView.image = UIImage(named: type.imgName + "Inactive")
    }
    
    private func updateUI() {
        guard let type = type else { return }
        if isSelected {
            self.label.setTitle(type.title,
                                font: Fonts.get(size: 16,
                                                 type: .regular),
                                 txtColor: .white)
            imgView.image = UIImage(named: type.imgName + "Active")
            
        } else {
            self.label.setTitle(type.title,
                                font: Fonts.get(size: 16,
                                                 type: .regular),
                                 txtColor: .gray)
            imgView.image = UIImage(named: type.imgName + "Inactive")
        }
    }
}
