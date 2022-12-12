//
//  Main_PopUpAlertViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/12/12.
//

import UIKit

class Main_PopUpAlertViewController: PopUpViewController {
    private weak var alertView: UIView!
    
    override func setAdditionalUI() {
        let alertView = UIView()
        back.addSubviews(alertView)
        NSLayoutConstraint.activate([
            alertView.bottomAnchor.constraint(equalTo: back.bottomAnchor, constant: 231),
            alertView.leftAnchor.constraint(equalTo: back.leftAnchor),
            alertView.rightAnchor.constraint(equalTo: back.rightAnchor),
            alertView.heightAnchor.constraint(equalToConstant: 231)
        ])
        alertView.backgroundColor = Colors.white.value
        self.alertView = alertView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5) {
            self.alertView.transform = CGAffineTransform(translationX: 0,
                                                    y: -231)
        }
    }
}
