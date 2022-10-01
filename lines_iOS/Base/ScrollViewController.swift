//
//  ScrollViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/08/07.
//

import Foundation
import UIKit

class ScrollViewController: ViewController {
    internal weak var topView: TopView!
    internal var topViewHeight: CGFloat = 56
    internal weak var scrollView: UIScrollView!
    internal weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTopView()
        setScrollView()
        setAdditionalUI()
    }
    
    internal func setTopView() {
        let topView = TopView()
        self.view.addSubviews(topView)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            topView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            topView.heightAnchor.constraint(equalToConstant: topViewHeight)
        ])
        self.topView = topView
    }
    
    private func setScrollView() {
        let scrollView = UIScrollView()
        self.view.addSubviews(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        
        let scrollContentView = UIView()
        scrollView.addSubviews(scrollContentView)
        NSLayoutConstraint.activate([
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            scrollContentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        scrollView.delegate = self
        self.scrollView = scrollView
        self.contentView = scrollContentView
    }
    
    internal func setAdditionalUI() { }
}

extension ScrollViewController: UIScrollViewDelegate { }
