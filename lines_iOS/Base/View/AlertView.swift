//
//  AlertView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/13.
//

import UIKit

class AlertView: UIView {
    private weak var back: UIView!
    internal weak var contentsView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBackUI()
        setContentsView()
        addtionalUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func setBackUI() {
        let back = UIView()
        self.addSubviews(back)
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: self.topAnchor),
            back.leftAnchor.constraint(equalTo: self.leftAnchor),
            back.rightAnchor.constraint(equalTo: self.rightAnchor),
            back.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        back.backgroundColor = Colors.black.value.withAlphaComponent(0.4)
        self.back = back
    }
    
    private func setContentsView() {
        let contentsView = UIView()
        back.addSubviews(contentsView)
        NSLayoutConstraint.activate([
            contentsView.topAnchor
                        .constraint(equalTo: back.topAnchor,
                                              constant: 221),
            contentsView.leftAnchor
                        .constraint(equalTo: back.leftAnchor,
                                    constant: 30),
            contentsView.rightAnchor
                        .constraint(equalTo: back.rightAnchor,
                                    constant: -30),
        ])
        contentsView.layer.cornerRadius = 10
        contentsView.backgroundColor = Colors.white.value
        self.contentsView = contentsView
    }
    internal func addtionalUI() {}
}
