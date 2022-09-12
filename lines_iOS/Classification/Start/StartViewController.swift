//
//  StartViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/08/05.
//

import Foundation
import UIKit

class StartViewController: ViewController {
    private weak var thirdImageBackView: UIView!
    private weak var indicator: UIPageControl!
    private lazy var startButton: UIButton = {
        let btn = UIButton()
        self.view.addSubviews(btn)
        NSLayoutConstraint.activate([
            btn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20 + -37),
            btn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            btn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            btn.heightAnchor.constraint(equalToConstant: 50)
        ])
        btn.setTitle("시작하기",
                     font: Fonts.get(size: 18, type: .bold),
                     txtColor: .black,
                     backColor: .beige)
        btn.layer.cornerRadius = 10
        btn.addAction(UIAction {[ weak self ] _ in
            FirstLaunchChecker.isOnBoardingShown = true
            
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            self?.present(loginVC, animated: true)
        }, for: .touchUpInside)
        btn.alpha = 0
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !FirstLaunchChecker.isNotLogin {
            //로그인을 했다면? refresh하고 메인 보내기
            AFHandler.refresh {
                guard let accessToken = $0?.accessToken,
                      let refreshToken = $0?.refreshToken
                else { return }
                
                UserData.accessToken = accessToken
                UserData.refreshToken = refreshToken
                
                let vc = MainViewController()
                vc.modalPresentationStyle = .fullScreen
                getAppDelegate()?.setRootViewController(vc)
            }
            return
        }
        
        // 데이터가 있는가?
        guard !FirstLaunchChecker.isDataSaved else {
            let vc = MainViewController()
            vc.modalPresentationStyle = .fullScreen
            getAppDelegate()?.setRootViewController(vc)
            return
        }
        
        // 온보딩을 봤는가?
        guard !FirstLaunchChecker.isOnBoardingShown else {
            let vc = LoginViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            return
        }
        
        self.view.backgroundColor = Colors.black.value
        setScrollView()
    }
    
    private func setScrollView() {
        let backgroundView = UIImageView(image: UIImage(named: "OnboardingBackground"))
        self.view.addSubviews(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        
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
        scrollView.backgroundColor = .clear
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        let scrollContentsView = UIView()
        scrollView.addSubviews(scrollContentsView)
        NSLayoutConstraint.activate([
            scrollContentsView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContentsView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            scrollContentsView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor),
            scrollContentsView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContentsView.widthAnchor.constraint(equalToConstant: viewWidth * 3)
        ])
        scrollContentsView.backgroundColor = .clear
        
        (1 ... 3).forEach {
            let imgBackView = UIView()
            scrollContentsView.addSubviews(imgBackView)
            NSLayoutConstraint.activate([
                imgBackView.topAnchor.constraint(equalTo: scrollContentsView.topAnchor),
                imgBackView.leftAnchor.constraint(equalTo: scrollContentsView.leftAnchor,
                                             constant: viewWidth * CGFloat($0 - 1)),
                imgBackView.widthAnchor.constraint(equalToConstant: viewWidth),
                imgBackView.bottomAnchor.constraint(equalTo: scrollContentsView.bottomAnchor),
            ])
            imgBackView.backgroundColor = .clear
            imgBackView.isUserInteractionEnabled = true
            
            let contentsImgView = UIImageView(image: UIImage(named: String(format: "OnBoarding%d", $0)))
            imgBackView.addSubviews(contentsImgView)
            NSLayoutConstraint.activate([
                contentsImgView.leftAnchor.constraint(equalTo: imgBackView.leftAnchor,
                                                      constant: 74),
                contentsImgView.rightAnchor.constraint(equalTo: imgBackView.rightAnchor,
                                                       constant: -74),
                contentsImgView.topAnchor.constraint(equalTo: imgBackView.topAnchor,
                                                    constant: 193 + 37),
            ])
            contentsImgView.contentMode = .scaleAspectFit
            contentsImgView.isUserInteractionEnabled = true
            guard $0 == 3 else { return }
            
            imgBackView.rightAnchor.constraint(equalTo: scrollContentsView.rightAnchor).isActive = true
            self.thirdImageBackView = imgBackView
        }
        
        let indicator = UIPageControl()
        self.view.addSubviews(indicator)
        NSLayoutConstraint.activate([
            indicator.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -110),
            indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        indicator.numberOfPages = 3
        indicator.currentPage = 0
        indicator.currentPageIndicatorTintColor = Colors.beige.value
        indicator.pageIndicatorTintColor = Colors.white.value.withAlphaComponent(0.3)
        self.indicator = indicator
    }
}

extension StartViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        indicator.currentPage = value
        if indicator.currentPage == 2 {
            DispatchQueue.main.async {
                self.thirdImageBackView.bringSubviewToFront(self.startButton)
                UIView.animate(withDuration: 1.0) {
                    self.startButton.alpha = 1.0
                }
            }
        } else {
            self.startButton.alpha = 0.0
        }
    }
}
