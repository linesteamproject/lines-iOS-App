//
//  StartViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/08/05.
//

import Foundation
import UIKit
import RxSwift
import SnapKit

class StartViewController: ViewController {
    private let disposeBag = DisposeBag()
    
    private weak var contentsImgView: UIImageView!
    private weak var indicator: UIPageControl!
    private lazy var startButton: UIButton = {
        let btn = UIButton()
        self.view.addSubview(btn)
        btn.snp.makeConstraints({ make in
            make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        })
        btn.setTitle("시작하기",
                     font: Fonts.get(size: 18, type: .bold),
                     txtColor: .black,
                     backColor: .beige)
        btn.layer.cornerRadius = 10
        btn.alpha = 0
        btn.addAction(UIAction { [weak self] _ in
            FirstLaunchChecker.isOnBoardingShown = true
            self?.goToVC(vc: LoginViewController())
        }, for: .touchUpInside)
        
        return btn
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard FirstLaunchChecker.isNotLogin else {
            //로그인을 했다면? refresh하고 메인 보내기
            
            NetworkService().refresh()
                .observeOn(MainScheduler.instance)
                .subscribe(onError: { [weak self] err in
                        print(err.localizedDescription)
                        self?.goToVC(vc: LoginViewController())
                    }, onCompleted: {
                    let vc = MainViewController()
                    vc.modalPresentationStyle = .fullScreen
                    getAppDelegate()?.setRootViewController(vc)
                }).disposed(by: disposeBag)
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
            self.goToVC(vc: LoginViewController())
            return
        }
        
        self.view.backgroundColor = Colors.black.value
        setScrollView()
    }
    
    private func setScrollView() {
        let backgroundView = UIImageView(image: UIImage(named: "OnboardingBackground"))
        self.view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        let viewWidth = UIScreen.main.bounds.width
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        scrollView.backgroundColor = .clear
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        let scrollContentsView = UIView()
        scrollView.addSubview(scrollContentsView)
        scrollContentsView.snp.makeConstraints({ make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(viewWidth * 4)
            make.height.equalTo(self.view.snp.height)
        })
        scrollContentsView.backgroundColor = .clear
        OnBardingImageType.allCases.enumerated().forEach { idx, type in
            let contentsImgView = UIImageView(image: UIImage(named: type.imgName))
            scrollContentsView.addSubview(contentsImgView)
            contentsImgView.snp.makeConstraints({ make in
                make.top.bottom.equalTo(scrollView)
                make.left.equalTo(scrollContentsView).inset(Double(idx) * viewWidth)
                make.width.equalTo(viewWidth)
                
                guard type == .OnBoarding4 else { return }
                make.right.equalTo(scrollContentsView)
            })
            contentsImgView.contentMode = .scaleAspectFit
            contentsImgView.isUserInteractionEnabled = true
            self.contentsImgView = contentsImgView
        }
        
        let indicator = UIPageControl()
        self.view.addSubview(indicator)
        indicator.snp.makeConstraints({ make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(110)
            make.centerX.equalTo(self.view)
        })
        
        indicator.numberOfPages = 4
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
        
        guard let onBoardingImgType = OnBardingImageType(rawValue: indicator.currentPage+1),
              onBoardingImgType == .OnBoarding4
        else {
            self.startButton.alpha = 0.0
            return
        }
        
        self.contentsImgView.bringSubviewToFront(self.startButton)
        UIView.animate(withDuration: 1.0) {
            self.startButton.alpha = 1.0
        }
    }
}
