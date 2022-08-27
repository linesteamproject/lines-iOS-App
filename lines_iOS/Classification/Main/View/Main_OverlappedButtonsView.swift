//
//  Main_OverlappedButtonsView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/13.
//

import UIKit

enum Main_OverlappedButtonsType {
    case top
    case mid
    case bottom
}

protocol ButtonDelegate: AnyObject {
    func touched(_ obj: Any?)
}
class Main_OverlappedButtonsView: UIView {
    private weak var backView: UIView!
    private weak var topBtn: UIButton!
    private weak var midBtn: UIButton!
    private weak var bottomBtn: UIButton!
    private weak var topBtnBottomAnchor: NSLayoutConstraint!
    private weak var midBtnBottomAnchor: NSLayoutConstraint!

    internal var delegate: ButtonDelegate
    init(_ delegate: ButtonDelegate) {
        self.delegate = delegate
        
        super.init(frame: .zero)
        setBack()
        setSubButtons()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
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
            topBtn.rightAnchor.constraint(equalTo: backView.rightAnchor),
            topBtn.widthAnchor.constraint(equalToConstant: 208),
            
            midBtnBottomAnchor,
            midBtn.rightAnchor.constraint(equalTo: backView.rightAnchor),
            midBtn.widthAnchor.constraint(equalToConstant: 208),
            bottomBtn.leftAnchor.constraint(equalTo: backView.leftAnchor),
            bottomBtn.rightAnchor.constraint(equalTo: backView.rightAnchor),
            bottomBtn.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
            
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
        topBtn.addAction(UIAction {[ weak self] _ in
            self?.delegate.touched(Main_OverlappedButtonsType.top)
        }, for: .touchUpInside)
        midBtn.addAction(UIAction {[ weak self] _ in
            self?.delegate.touched(Main_OverlappedButtonsType.mid)
        }, for: .touchUpInside)
        bottomBtn.addAction(UIAction {[ weak self] _ in
            self?.delegate.touched(Main_OverlappedButtonsType.bottom)
        }, for: .touchUpInside)
        self.topBtn = topBtn
        self.midBtn = midBtn
        self.bottomBtn = bottomBtn
        
        self.topBtnBottomAnchor = topBtnBottomAnchor
        self.midBtnBottomAnchor = midBtnBottomAnchor
    }
}
