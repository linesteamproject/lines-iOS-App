//
//  SplashViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/09/26.
//

import UIKit
import SnapKit

class SplashViewController: ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let startVc = StartViewController()
        startVc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75,
                                      execute: { [weak self] in
            self?.present(startVc, animated: false)
        })
    }
    
    private func setUI() {
        let imgView = UIImageView()
        self.view.addSubview(imgView)
        imgView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        let randomVal = Int(Date().timeIntervalSince1970) % 4 + 1
        let imgName = String(format: "Splash%d", randomVal)
        imgView.image = UIImage(named: imgName)
    }
}
