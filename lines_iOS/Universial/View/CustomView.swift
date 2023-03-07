//
//  CustomView.swift
//  lines_iOS
//
//  Created by mun on 2023/03/06.
//

import UIKit

class CustomView: UIView {
    required init?(coder: NSCoder) {
        fatalError("Required Init View")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    internal func setUI() { }
    
    init<T>(_ viewModel: T) {
        super.init(frame: .zero)
        setUI(viewModel)
    }
    
    internal func setUI<T>(_ viewModel: T) { }
}
