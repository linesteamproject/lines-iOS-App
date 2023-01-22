//
//  MakeCardOnlyTextViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/09/10.
//

import UIKit

class MakeCardOnlyTextViewController: MakeCardViewController {
    private weak var okButton: OkButton!
    override var noticeStr: String {
        get { return "기록하고 싶은 문장을 직접 입력해 주세요." }
        set { }
    }
    
    override func setContentView() {
        let cardContentView = MakeCard_ContentView(ReadTextController.shared.readText)
        self.contentView.addSubviews(cardContentView)
        NSLayoutConstraint.activate([
            cardContentView.topAnchor.constraint(equalTo: nextTopAnchor),
            cardContentView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            cardContentView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            cardContentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 274),
        ])
        cardContentView.isTxtViewEmptyClosure = { [weak self] isEmptyContent in
            self?.okButton.isEnabled = !isEmptyContent
            if isEmptyContent {
                self?.okButton.backgroundColor = Colors.beigeInactive.value
            } else {
                self?.okButton.backgroundColor = Colors.beige.value
            }
        }
        self.cardContentView = cardContentView
        self.nextTopAnchor = cardContentView.bottomAnchor
    }
    
    override func setBottomView() {
        let okButton = OkButton()
        self.view.addSubviews(okButton)
        NSLayoutConstraint.activate([
            okButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -34 + -20),
            okButton.leftAnchor.constraint(equalTo: self.view.leftAnchor,
                                          constant: 20),
            okButton.rightAnchor.constraint(equalTo: self.view.rightAnchor,
                                           constant: -20),
            okButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        okButton.setTitle("다음 단계",
                          font: Fonts.get(size: 18, type: .bold),
                          txtColor: .black,
                          backColor: .beigeInactive)
        okButton.addAction(UIAction { [weak self] _ in
            ReadTextController.shared.readText = self?.cardContentView.txtView.text ?? ""
            let vc = MakeCard_DetailViewController()
            vc.modalPresentationStyle = .fullScreen
            self?.navigationController?.pushViewController(vc, animated: false)
        }, for: .touchUpInside)
        okButton.isEnabled = false
        okButton.layer.cornerRadius = 10
        okButton.layer.masksToBounds = true
        
        self.okButton = okButton
    }
}
