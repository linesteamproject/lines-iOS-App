//
//  Main_MenuButton.swift
//  lines_iOS
//
//  Created by mun on 2022/08/13.
//

import UIKit

class Main_MenuButton: UIButton {
    internal var closure: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(UIImage(named: "MenuButton"),
                        for: .normal)
        self.addAction(UIAction { [weak self] _ in
            //Menu Button 열었을 때
            self?.closure?()
        }, for: .touchUpInside)
    }
    required init?(coder: NSCoder) { fatalError() }
    
}
