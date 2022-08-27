//
//  ImageAlertView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/13.
//

import UIKit

class ImageAlertView: AlertView {
    private var nextTopAnchor: NSLayoutYAxisAnchor!
    private var imageView: UIImageView!
    internal var image: UIImage? {
        didSet { imageView.image = self.image }
    }
    override func addtionalUI() {
        setTitleView()
        setImageView()
    }
    private func setTitleView() {
        let title = UILabel()
        self.addSubviews(title)
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: contentsView.centerXAnchor),
            title.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 15),
            title.heightAnchor.constraint(equalToConstant: 56)
        ])
        title.setTitle("사진 보기", font: Fonts.get(size: 22, type: .regular),
                       txtColor: .black)
        self.nextTopAnchor = title.bottomAnchor
        
        let button = UIButton()
        self.addSubviews(button)
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            button.rightAnchor.constraint(equalTo: contentsView.rightAnchor,
                                          constant: -25),
            button.widthAnchor.constraint(equalToConstant: 20),
            button.heightAnchor.constraint(equalToConstant: 20)
        ])
        button.setImage(UIImage(named: "IconX")?
                            .withTintColor(Colors.black.value),
                        for: .normal)
        button.addAction(UIAction { [weak self] _ in
            self?.removeFromSuperview()
        }, for: .touchUpInside)
    }
    
    private func setImageView() {
        let imageView = UIImageView()
        self.addSubviews(imageView)
        NSLayoutConstraint.activate([
            contentsView.heightAnchor.constraint(lessThanOrEqualToConstant: 300),
            
            imageView.topAnchor.constraint(equalTo: nextTopAnchor, constant: 15),
            imageView.leftAnchor.constraint(equalTo: contentsView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentsView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor),
        ])
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFit
        self.imageView = imageView
    }
}
