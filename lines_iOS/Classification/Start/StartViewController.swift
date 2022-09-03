//
//  StartViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/08/05.
//

import Foundation
import UIKit

class StartViewController: ViewController {
    private var crntPage: Int = 0
    private weak var thirdImageView: UIImageView!
    private weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.black.value
        setScrollView()
    }
    
    private func setScrollView() {
        let viewWidth = UIScreen.main.bounds.width
        let scrollView = UIScrollView()
        self.view.addSubviews(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)
        ])
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        let scrollContentsView = UIView()
        scrollView.addSubviews(scrollContentsView)
        NSLayoutConstraint.activate([
            scrollContentsView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentsView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            scrollContentsView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            scrollContentsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentsView.widthAnchor.constraint(equalToConstant: viewWidth * 3)
        ])
        
        (1 ... 3).forEach {
            let imgView = UIImageView(image: UIImage(named: String(format: "OnBoarding%d", $0)))
            scrollContentsView.addSubviews(imgView)
            NSLayoutConstraint.activate([
                imgView.topAnchor.constraint(equalTo: scrollContentsView.topAnchor),
                imgView.leftAnchor.constraint(equalTo: scrollContentsView.leftAnchor,
                                             constant: viewWidth * CGFloat($0 - 1)),
                imgView.widthAnchor.constraint(equalToConstant: viewWidth),
                imgView.bottomAnchor.constraint(equalTo: scrollContentsView.bottomAnchor),
            ])
            imgView.isUserInteractionEnabled = true
            guard $0 == 3 else { return }
            
            imgView.rightAnchor.constraint(equalTo: scrollContentsView.rightAnchor).isActive = true
            self.thirdImageView = imgView
        }
    }
    
    private func setStartButton() {
        guard startButton == nil else { return }
        
        let btn = UIButton()
        self.thirdImageView.addSubviews(btn)
        NSLayoutConstraint.activate([
            btn.bottomAnchor.constraint(equalTo: self.thirdImageView.bottomAnchor, constant: -171),
            btn.leftAnchor.constraint(equalTo: self.thirdImageView.leftAnchor, constant: 20),
            btn.rightAnchor.constraint(equalTo: self.thirdImageView.rightAnchor, constant: -20),
            btn.heightAnchor.constraint(equalToConstant: 50)
        ])
        btn.setTitle("시작하기",
                     font: Fonts.get(size: 18, type: .bold),
                     txtColor: .black,
                     backColor: .beige)
        btn.layer.cornerRadius = 10
        btn.addAction(UIAction {[ weak self ] _ in
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            self?.present(loginVC, animated: true)
        }, for: .touchUpInside)
        btn.alpha = 0
        self.startButton = btn
    }
}

extension StartViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.crntPage = value
        if crntPage == 2 {
            DispatchQueue.main.async {
                self.setStartButton()
                UIView.animate(withDuration: 1.0) {
                    self.startButton.alpha = 1.0
                }
            }
        }
    }
}
