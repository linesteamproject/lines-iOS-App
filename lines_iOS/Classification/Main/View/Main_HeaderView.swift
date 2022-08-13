//
//  Main_HeaderView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/07.
//

import Foundation
import UIKit

class Main_HeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func setUI() {
        let imgView = UIImageView(image: UIImage(named: "HeaderImage"))
        self.addSubViews(imgView)
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 39.06),
            imgView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -43.5),
            imgView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 98.43),
            imgView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -67)
        ])
        imgView.contentMode = .scaleAspectFit
    }
}
