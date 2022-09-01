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
        if let data = data.imageData {
            imageView.image = UIImage(data: data)
        }
    }
}
