//
//  Main_TopView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/13.
//

import UIKit

class Main_TopView: TopView {
    override func setUI() {
        let logoImgView = UIImageView(image: UIImage(named: "Logo"))
        self.addSubViews(logoImgView)
        NSLayoutConstraint.activate([
            logoImgView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImgView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            logoImgView.widthAnchor.constraint(equalToConstant: 64),
            logoImgView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
