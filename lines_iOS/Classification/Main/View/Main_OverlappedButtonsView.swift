//
//  Main_OverlappedButtonsView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/13.
//

import UIKit

class Main_OverlappedButtonsView: UIView {
    private weak var backView: UIView!
    private weak var topBtn: UIButton!
    private weak var midBtn: UIButton!
    private weak var bottomBtn: UIButton!
    private weak var topBtnBottomAnchor: NSLayoutConstraint!
    private weak var midBtnBottomAnchor: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setBack()
        setSubButtons()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setBack()
        setSubButtons()
    }
    
    internal func updateUI(isHidden: Bool, updateDone: (() -> Void)? = nil) {
        midBtnBottomAnchor.isActive = false
        topBtnBottomAnchor.isActive = false
        
        let midMargin: CGFloat = isHidden ? 0 : -60
        let topMargin: CGFloat = isHidden ? 0 : -120
        
        midBtnBottomAnchor = midBtn.bottomAnchor.constraint(equalTo: backView.bottomAnchor,
                                                            constant: midMargin)
        topBtnBottomAnchor = topBtn.bottomAnchor.constraint(equalTo: backView.bottomAnchor,
                                                            constant: topMargin)
        midBtnBottomAnchor.isActive = true
        topBtnBottomAnchor.isActive = true
        
        
        UIView.animate(withDuration: 0.8, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in updateDone?() })
    }
}

extension Main_OverlappedButtonsView {
    private func setBack() {
        let view = UIView()
        self.addSubviews(view)
        view.backgroundColor = .brown
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.leftAnchor.constraint(equalTo: self.leftAnchor),
            view.rightAnchor.constraint(equalTo: self.rightAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        backView = view
    }
    
    private func setSubButtons() {
        let topBtn = UIButton()
        let midBtn = UIButton()
        let bottomBtn = UIButton()
        
        backView.addSubviews(bottomBtn, midBtn, topBtn)
        let topBtnBottomAnchor = topBtn.bottomAnchor.constraint(equalTo: backView.bottomAnchor)
        let midBtnBottomAnchor = bottomBtn.bottomAnchor.constraint(equalTo: backView.bottomAnchor)
        
        NSLayoutConstraint.activate([
            topBtnBottomAnchor,
            topBtn.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            topBtn.widthAnchor.constraint(equalToConstant: 208),
            
            midBtnBottomAnchor,
            midBtn.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            midBtn.widthAnchor.constraint(equalToConstant: 208),
            
            bottomBtn.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
            bottomBtn.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            
            bottomBtn.widthAnchor.constraint(equalToConstant: 221),
        ])
        [topBtn, midBtn, bottomBtn].forEach {
            $0.backgroundColor = Colors.beige.value
            $0.heightAnchor.constraint(equalToConstant: 52).isActive = true
            $0.setTitle(font: Fonts.get(size: 16, type: .bold), txtColor: .black)
            $0.layer.cornerRadius = 26
        }
        topBtn.setTitle("사진 촬영으로 문장 기록")
        midBtn.setTitle("사진 앨범에서 문장 기록")
        bottomBtn.setTitle("텍스트 입력으로 문장 기록")
        
        self.topBtn = topBtn
        self.midBtn = midBtn
        self.bottomBtn = bottomBtn
        
        self.topBtnBottomAnchor = topBtnBottomAnchor
        self.midBtnBottomAnchor = midBtnBottomAnchor
    }
}
