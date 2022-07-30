//
//  MainViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation
import UIKit

class MainViewController: ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFloatingButton()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let text = ReadTextController.shared.readText {
            showText(text)
        }
    }
    private func showText(_ text: String) {
        let ptView = StickerTextView(CGSize(width: 300,
                                            height: 339))
        self.view.addSubViews(ptView)
        NSLayoutConstraint.activate([
            ptView.topAnchor.constraint(equalTo: self.view.topAnchor),
            ptView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            ptView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            ptView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        ptView.str = text
        ptView.closure = {
            ReadTextController.shared.readText = nil
        }
    }
}

extension MainViewController {
    private func setFloatingButton() {
        let btn = UIButton()
        self.view.addSubViews(btn)
        NSLayoutConstraint.activate([
            btn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            btn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            btn.widthAnchor.constraint(equalToConstant: 120),
            btn.heightAnchor.constraint(equalToConstant: 90),
        ])
        btn.setTitle("텍스트 인식", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.addAction(UIAction { _ in
            let vc = CameraViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }, for: .touchUpInside)
    }
}
