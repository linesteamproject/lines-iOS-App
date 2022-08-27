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
                .constraint(lessThanOrEqualToConstant: 93)
        ])
        back.backgroundColor = Colors.gray222222.value
        self.backView = back
        
        let label = UILabel()
        back.addSubviews(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: back.topAnchor, constant: 15),
            label.leftAnchor.constraint(equalTo: back.leftAnchor, constant: 20),
            label.rightAnchor.constraint(equalTo: back.rightAnchor, constant: -20),
            label.bottomAnchor.constraint(equalTo: back.bottomAnchor, constant: -20)
        ])
        label.numberOfLines = 0
        label.setTitle("기록할 문장을 인식합니다. 원활한 문장 인식을 위해 한 페이지만 찍어주세요. 문장은 한번에 최대 {n}자 까지(평균 {n}~{n}줄) 기록 가능합니다.",
                       font: Fonts.get(size: 14, type: .regular),
                       txtColor: .white)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 3.6,
                           delay: 1.4,
                           options: .curveEaseOut,
                           animations: { [ weak self] in
                self?.backView.isHidden = true
            }, completion: { [weak self] _ in
                self?.backView.removeFromSuperview()
            })
        }
    }
}
