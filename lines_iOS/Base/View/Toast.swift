//
//  Toast.swift
//  lines_iOS
//
//  Created by mun on 2022/09/26.
//

import UIKit

class Toast {
    static var shared: Toast {
        return Toast()
    }
    
    func message(_ str: String, duration: Double = 0.7) {
        guard let top = topViewController() else { return }
        
        let label = UILabel()
        top.view.addSubviews(label)
        label.setTitle(str,
                       font: Fonts.get(size: 12, type: .bold),
                       txtColor: Colors.white)
        label.backgroundColor = Colors.white.value.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.alpha = 1.0
        label.layer.cornerRadius = 23;
        label.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: top.view.safeAreaLayoutGuide.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: top.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            label.widthAnchor.constraint(equalToConstant: label.intrinsicContentSize.width + 40),
            label.heightAnchor.constraint(equalToConstant: 46)
        ])
        
        
        UIView.animate(withDuration: duration, delay: duration, options: .curveEaseOut, animations: {
            label.transform = CGAffineTransform(translationX: 0, y: 160 + label.frame.height)
            label.alpha = 0.1
        }, completion: {(isCompleted) in
            label.removeFromSuperview()
        })
    }
}

