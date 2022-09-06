//
//  ImageCollectionViewCell.swift
//  lines_iOS
//
//  Created by mun on 2022/08/13.
//

import UIKit

class ImageListCellView: UIView {
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
        contentsLabel.setTitle(data.lineValue,
                               font: Fonts.get(size: 7.4,
                                               type: .regular),
                               txtColor: .black)
        contentsLabel.numberOfLines = 0
        
        var bookInfo = data.bookName ?? ""
        bookInfo += ","
        bookInfo += data.authorName ?? ""
        bookInfoLabel.setTitle(bookInfo,
                               font: Fonts.get(size: 5.18,
                                               type: .regular),
                               txtColor: .gray777777)
        bookInfoLabel.textAlignment = .center
        bookInfoLabel.numberOfLines = 0 
        if let imgName = data.backImageName {
            imageView.image = UIImage(named: imgName)
        }
    }
}
