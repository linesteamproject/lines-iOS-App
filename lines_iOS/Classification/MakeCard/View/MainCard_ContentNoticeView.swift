//
//  MainCard_ContentNoticeView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/14.
//

import UIKit

class MainCard_ContentNoticeView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func setUI() {
        let imgView = UIImageView(image: UIImage(named: "MarkCard_ContentNotice"))
        self.addSubviews(imgView)
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            imgView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            imgView.widthAnchor.constraint(equalToConstant: 24),
            imgView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        let label = UILabel()
        self.addSubviews(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: imgView.topAnchor),
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 60),
            label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            label.heightAnchor.constraint(lessThanOrEqualToConstant: 42),
        ])
        label.numberOfLines = 0
        let str = "문장 최대 110자까지 인식 및 저장이 가능(그 이상 넘어가는 문장은 자동 제거)"
        label.setTitle(str,
                       font: Fonts.get(size: 12, type: .bold),
                       txtColor: .white)
    }
}
