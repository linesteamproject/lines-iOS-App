//
//  ViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import UIKit

class ViewController: UIViewController {
    private weak var loadingView: UIView!
    private weak var indicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.black.value
        
        setLoadingView()
    }
    
    private func setLoadingView() {
        let back = UIView()
        self.view.addSubviews(back)
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: self.view.topAnchor),
            back.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            back.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            back.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        back.backgroundColor = Colors.black.value.withAlphaComponent(0.7)
        self.loadingView = back
        
        let indicator = UIActivityIndicatorView()
        back.addSubviews(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: back.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: back.centerYAnchor)
        ])
        self.indicator = indicator
        back.isHidden = true
    }
    
    internal func showLoadingView() {
        self.view.bringSubviewToFront(self.loadingView)
        loadingView.isHidden = false
        self.indicator.startAnimating()
    }
    
    internal func hiddenLoadingView() {
        self.loadingView.isHidden = true
        self.indicator.stopAnimating()
    }
}

