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
                       txtColor: Colors.white,
                       backColor: Colors.gray1E1E1E)
        label.textAlignment = .center
        label.alpha = 1.0
        label.layer.cornerRadius = 14;
        label.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: top.view.safeAreaLayoutGuide.centerXAnchor),
            label.topAnchor.constraint(equalTo: top.view.centerYAnchor, constant: -23),
            label.widthAnchor.constraint(equalToConstant: label.intrinsicContentSize.width + 40),
            label.heightAnchor.constraint(equalToConstant: 46)
        ])
        
        
        UIView.animate(withDuration: duration, delay: duration, options: .curveEaseOut, animations: {
            label.alpha = 0
        }, completion: {(isCompleted) in
            label.removeFromSuperview()
        })
    }
}

