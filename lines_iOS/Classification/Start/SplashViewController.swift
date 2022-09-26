//
//  SplashViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/09/26.
//

import UIKit

class SplashViewController: ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        let imgView = UIImageView()
        self.view.addSubviews(imgView)
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: self.view.topAnchor),
            imgView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            imgView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            imgView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        let randomVal = Int(Date().timeIntervalSince1970) % 4 + 1
        let imgName = String(format: "Splash%d", randomVal)
        imgView.image = UIImage(named: imgName)
        
        UIView.animate(withDuration: 0.7, delay: 0.3, options: .curveEaseInOut, animations: {
            imgView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            let startVc = StartViewController()
            startVc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75,
                                          execute: { [weak self] in
                self?.present(startVc, animated: false)
            })
        })
    }
}
