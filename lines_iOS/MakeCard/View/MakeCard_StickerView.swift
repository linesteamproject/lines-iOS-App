//
//  MakeCard_StickerView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/21.
//

import UIKit

class MakeCard_StickerView: UIView {
    internal weak var backImageView: UIImageView!
    internal weak var contentsLabel: UILabel!
    internal weak var bookInfoLabel: UILabel!
    
    internal var imgBackName: String = ""
    internal var bookInfoStr: String? {
        didSet { bookInfoLabel.setTitle(bookInfoStr) }
    }
    internal var color: MakeCard_StickerBackColorType! {
        didSet {
            backImageView.image = UIImage(named: imgBackName)
            self.backgroundColor = color.color
        }
    }
    init(_ text: String?) {
        super.init(frame: .zero)
        
        setStickerFrame()
        setText(text)
        setConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    private func setStickerFrame() {
        let back = UIImageView()
        self.addSubviews(back)
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: self.topAnchor),
            back.heightAnchor.constraint(equalToConstant: 345),
            back.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            back.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        back.contentMode = .scaleAspectFit
        self.backImageView = back

        let bookInfo = UILabel()
        back.addSubviews(bookInfo)
        NSLayoutConstraint.activate([
            bookInfo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bookInfo.widthAnchor.constraint(equalToConstant: 110),
            bookInfo.heightAnchor.constraint(greaterThanOrEqualToConstant: 13),
            bookInfo.bottomAnchor.constraint(equalTo: back.bottomAnchor, constant: -54.31),
        ])
        bookInfo.setTitle(font: Fonts.getNanum(size: 11),
                          txtColor: .gray222222)
        bookInfo.numberOfLines = 2
        bookInfo.textAlignment = .center
        self.bookInfoLabel = bookInfo
    }
    
    private func setText(_ text: String?) {
        let label = UILabel()
        backImageView.addSubviews(label)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.setTitleHasLineSpace(text,
                                   lineSpaceVal: 3,
                                   font: Fonts.getNanum(size: 16),
                                   color: .black,
                                   textAlignment: .center)
        
        label.adjustsFontForContentSizeCategory = true
        self.contentsLabel = label
    }
    internal func setConstraints() { }
}
