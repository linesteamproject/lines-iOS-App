//
//  ImageCollectionViewCell.swift
//  lines_iOS
//
//  Created by mun on 2022/08/13.
//

import UIKit

class ImageListCellView: UIView {
    internal var cardTouchedClosure: ((CardModel) -> Void)?
    init(_ data: CardModel) {
        super.init(frame: .zero)
        setUI(data)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUI(_ data: CardModel) {
        let imageView = UIImageView()
        self.addSubviews(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        let contentsLabel = UILabel()
        let bookInfoLabel = UILabel()
        let topConstant: CGFloat
        let leftRightConstant: CGFloat
        let bottomConstant: CGFloat
        let bookInfoBottomConstant: CGFloat
        if data.ratioType == .one2one {
            topConstant = 35
            leftRightConstant = 32.5
            bottomConstant = -41
            bookInfoBottomConstant = -25.16
        } else {
            topConstant = 40
            leftRightConstant = 37
            bottomConstant = -59.33
            bookInfoBottomConstant = -34.67
        }
        
        imageView.addSubviews(contentsLabel, bookInfoLabel)
        NSLayoutConstraint.activate([
            contentsLabel.topAnchor.constraint(equalTo: imageView.topAnchor,
                                               constant: topConstant),
            contentsLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor,
                                                constant: leftRightConstant),
            contentsLabel.rightAnchor.constraint(equalTo: imageView.rightAnchor,
                                                 constant: -leftRightConstant),
            contentsLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor,
                                                 constant: bottomConstant),
            
            bookInfoLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor,
                                                  constant: bookInfoBottomConstant),
            bookInfoLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 54),
            bookInfoLabel.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: -54),
        ])
        let font = 폰트(rawValue: data.font ?? 폰트.나눔명조.rawValue) ?? .나눔명조
        contentsLabel.setTitleHasLineSpace(data.lineValue,
                                           lineSpaceVal: 3,
                                           font: Fonts.get(size: 7.4, font: font),
                                           color: .black,
                                           textAlignment: .center)
        contentsLabel.textAlignment = .center
        contentsLabel.numberOfLines = 0
        
        var bookInfo = data.bookName ?? ""
        bookInfo += ","
        bookInfo += data.authorName ?? ""
        bookInfoLabel.setTitle(bookInfo,
                               font: Fonts.getNanum(size: 5.18),
                               txtColor: .gray777777)
        bookInfoLabel.textAlignment = .center
        bookInfoLabel.numberOfLines = 2
        if let ratio = data.ratioType?.imgName,
            let color = data.colorImageName {
            imageView.image = UIImage(named: ratio + color)
        }
        
        let button = UIButton()
        self.addSubviews(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: imageView.topAnchor),
            button.leftAnchor.constraint(equalTo: imageView.leftAnchor),
            button.rightAnchor.constraint(equalTo: imageView.rightAnchor),
            button.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
        ])
        button.addAction(UIAction { [weak self] _ in
            self?.cardTouchedClosure?(data)
        }, for: .touchUpInside)
    }
}
