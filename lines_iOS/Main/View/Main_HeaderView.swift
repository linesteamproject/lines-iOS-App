//
//  Main_HeaderView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/07.
//

import Foundation
import UIKit
import Lottie

class Main_HeaderView: UIView {
    private weak var animationView: AnimationView!
    internal func animationPlay() {
        animationView?.play()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func setUI() {
        let animationView = AnimationView(name: "Main_Lottie")
        let headerImgView = UIImageView(image: UIImage(named: "HeaderImage"))
        let bookImgView = UIImageView(image: UIImage(named: "Book"))
        self.addSubviews(headerImgView, bookImgView, animationView)
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: self.topAnchor, constant: 9),
            animationView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18),
            animationView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18),
            animationView.heightAnchor.constraint(equalToConstant: getWidth(140)),
            
            headerImgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 69.63),
            headerImgView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 104),
            headerImgView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -104),
            headerImgView.heightAnchor.constraint(equalToConstant: getWidth(53.37)),
            headerImgView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -26),
            
            bookImgView.topAnchor.constraint(equalTo: headerImgView.bottomAnchor, constant: -17),
            bookImgView.centerXAnchor.constraint(equalTo: headerImgView.centerXAnchor),
        ])
        animationView.respectAnimationFrameRate = true
        animationView.backgroundColor = .clear
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit // 애니메이션뷰의 콘텐트모드 설정
        animationView.play()
        headerImgView.contentMode = .scaleAspectFit
        self.animationView = animationView
    }
    
    private func getWidth(_ width: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.width*width/375
    }
}
