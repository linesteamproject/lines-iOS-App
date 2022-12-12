//
//  PopUpViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/12/12.
//

import UIKit

class PopUpViewController: ViewController {
    internal var back: UIView!
    internal var closeClosure: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackView()
        setAdditionalUI()
    }
    
    private func setBackView() {
        let back = UIView()
        self.view.backgroundColor = Colors.clear.value
        self.view.addSubviews(back)
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: self.view.topAnchor),
            back.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            back.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            back.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        back.backgroundColor = Colors.black.value.withAlphaComponent(0.5)
        self.back = back
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(self.handleTap(_:)))
        self.back.addGestureRecognizer(tap)
    }
    
    @objc
    private func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        closeClosure?()
    }
    internal func setAdditionalUI() { }
}
