//
//  Main_ListSubView.swift
//  lines_iOS
//
//  Created by mun on 2022/09/01.
//

import UIKit

class Main_ListSubView: UIView {
    internal weak var stickerFrame: UIImageView!
    internal weak var contentsLabel: UILabel!
    internal weak var illustImageView: UIImageView!
    internal weak var bookInfoLabel: UILabel!
    internal var frameColor: Colors? {
        didSet { self.backgroundColor = frameColor?.value ?? Colors.clear.value }
    }
    internal var imgBackName: String = ""
    internal var imgName: String = ""
    internal var imgIllustName: String = ""
    internal var bookInfoStr: String? {
        didSet { bookInfoLabel.setTitle(bookInfoStr) }
    }
    init(_ text: String?, width: CGFloat, height: CGFloat) {
        super.init(frame: .zero)
        
        setStickerFrame(width, height)
        setText(text)
        setConstraints()
    }
    required init?(coder: NSCoder) { fatalError() }
    private func setStickerFrame(_ width: CGFloat, _ height: CGFloat) {
        let logo = UIImageView(image: UIImage(named: "LinesSmallLogo"))
        self.addSubviews(logo)
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.31),
            logo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 31),
            logo.heightAnchor.constraint(equalToConstant: 18)
        ])
        logo.contentMode = .scaleAspectFit
        
        let back = UIImageView(image: UIImage(named: imgBackName))
        let imgView = UIImageView(image: UIImage(named: imgName))
        self.addSubviews(back, imgView)
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: self.topAnchor,
                                      constant: 47.92),
            back.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            back.widthAnchor.constraint(equalToConstant: 324.24),
            back.heightAnchor.constraint(equalToConstant: 274.72),
            
            imgView.topAnchor.constraint(equalTo: self.topAnchor,
                                         constant: 35.14),
            imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imgView.widthAnchor.constraint(equalToConstant: 305.07),
            imgView.heightAnchor.constraint(equalToConstant: 293.89),
        ])
        back.contentMode = .scaleAspectFit
        imgView.contentMode = .scaleAspectFit
        self.stickerFrame = imgView
        
        let illustImgView = UIImageView(image: UIImage(named: self.imgIllustName))
        imgView.addSubviews(illustImgView)
        self.illustImageView = illustImgView
        
        let bookInfo = UILabel()
        imgView.addSubviews(bookInfo)
        NSLayoutConstraint.activate([
            bookInfo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bookInfo.widthAnchor.constraint(equalToConstant: 110),
            bookInfo.heightAnchor.constraint(greaterThanOrEqualToConstant: 13),
            bookInfo.bottomAnchor.constraint(equalTo: imgView.bottomAnchor, constant: -31),
        ])
        bookInfo.setTitle(font: Fonts.get(size: 11, type: .light),
                          txtColor: .gray222222)
        self.bookInfoLabel = bookInfo
    }
    
    private func setText(_ text: String?) {
        let label = UILabel()
        stickerFrame.addSubviews(label)
        label.numberOfLines = 0
        label.setTitle(text,
                       font: Fonts.get(size: 16,
                                       type: .regular),
                       txtColor: .black)
        label.textAlignment = .center
        
        label.adjustsFontForContentSizeCategory = true
        self.contentsLabel = label
    }
    internal func setConstraints() { }
}

