//
//  ExternUIImagePickerController.swift
//  lines_iOS
//
//  Created by mun on 2022/08/13.
//

import UIKit

class ExternUIImagePickerController: UIImagePickerController {
    private weak var backView: UIView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let back = UIView()
        self.view.addSubviews(back)
        NSLayoutConstraint.activate([
            back.topAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                     constant: 53),
            back.leftAnchor
                .constraint(equalTo: self.view.leftAnchor),
            back.rightAnchor
                .constraint(equalTo: self.view.rightAnchor),
            back.heightAnchor
                .constraint(lessThanOrEqualToConstant: 125)
        ])
        back.backgroundColor = Colors.gray222222.value
        self.backView = back
        
        let titleLabel = UILabel()
        let subLabel = UILabel()
        back.addSubviews(titleLabel, subLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: back.topAnchor, constant: 15),
            titleLabel.leftAnchor.constraint(equalTo: back.leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: back.rightAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            subLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subLabel.leftAnchor.constraint(equalTo: back.leftAnchor, constant: 20),
            subLabel.rightAnchor.constraint(equalTo: back.rightAnchor, constant: -20),
            subLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 63),
            subLabel.bottomAnchor.constraint(equalTo: back.bottomAnchor, constant: -15)
        ])
        
        [titleLabel, subLabel].forEach {
            $0.numberOfLines = 0
        }
        titleLabel.textAlignment = .center
        titleLabel.setTitle("기록할 문장을 촬영해주세요 📸",
                            font: Fonts.get(size: 16, type: .bold),
                            txtColor: .white)
        var subTxt = "문장을 인식합니다."
        subTxt += "원활한 인식을 위해 한번에 한 페이지 안에서만 촬영해주세요."
        subTxt += "촬영 후 기록할 문장만을 오려낼 수 있어요."
        subLabel.setTitle(subTxt,
                          font: Fonts.get(size: 14, type: .regular),
                          txtColor: .white)
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            UIView.animate(withDuration: 3.6,
//                           delay: 1.4,
//                           options: .curveEaseOut,
//                           animations: { [ weak self] in
//                self?.backView.isHidden = true
//            }, completion: { [weak self] _ in
//                self?.backView.removeFromSuperview()
//            })
//        }
//    }
}
