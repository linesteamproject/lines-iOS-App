//
//  Main_CollectionView.swift
//  lines_iOS
//
//  Created by mun on 2022/08/13.
//

import UIKit

struct MainListViewObj {
    var lTopAnc: NSLayoutYAxisAnchor!
    var rTopAnc: NSLayoutYAxisAnchor!
    var lHeight: CGFloat = 0
    var rHeight: CGFloat = 0
    var topConst: CGFloat = 0
    var leftConst: CGFloat = 0
}

class Main_ListView: UIView {
    private let cellWidth: CGFloat
    private weak var nextTopAnchor: NSLayoutYAxisAnchor!
    private weak var label: UILabel!
    private weak var back: UIView!
    private weak var emptyView: UIImageView!
    private var obj = MainListViewObj()
    internal var datas: [CardModel?]? {
        didSet {
            label.setTitle(String(format: "기록한 문장 %d개", datas?.count ?? 0))
            datas?.isEmpty == true ? setEmptyView() : setCards()
        }
    }
    internal var cardTouchedClosure: ((CardModel) -> Void)?
    init(width: CGFloat) {
        self.cellWidth = (width - 15) / 2
        super.init(frame: .zero)
        
        setTitle()
        setListView()
    }
    required init?(coder: NSCoder) { fatalError() }
    private func setTitle() {
        let label = UILabel()
        self.addSubviews(label)
        NSLayoutConstraint.activate([
            label.topAnchor
                .constraint(equalTo: self.topAnchor),
            label.leftAnchor
                .constraint(equalTo: self.leftAnchor),
            label.rightAnchor
                .constraint(equalTo: self.rightAnchor),
            label.heightAnchor
                .constraint(equalToConstant: 22)
        ])
        label.setTitle(String(format: "기록한 문장 0개"),
                       font: Fonts.get(size: 16, type: .bold),
                       txtColor: .gold)
        self.label = label
        self.nextTopAnchor = label.bottomAnchor
    }
    
    private func setListView() {
        let back = UIView()
        self.addSubviews(back)
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: nextTopAnchor,
                                      constant: 12),
            back.leftAnchor.constraint(equalTo: self.leftAnchor),
            back.rightAnchor.constraint(equalTo: self.rightAnchor),
            back.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        obj.lTopAnc = back.topAnchor
        obj.rTopAnc = back.topAnchor
        self.back = back
    }
    
    private func setEmptyView() {
        let imgView = UIImageView(image: UIImage(named: "EmptyCardView"))
        self.back.addSubviews(imgView)
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: back.topAnchor,
                                         constant: 80),
            imgView.centerXAnchor.constraint(equalTo: back.centerXAnchor),
            imgView.widthAnchor.constraint(equalToConstant: 207),
            imgView.heightAnchor.constraint(equalToConstant: 145),
        ])
        self.emptyView = imgView
    }
    
    private func setCards() {
        self.emptyView?.removeFromSuperview()
        datas?.enumerated().forEach { idx, data in
            guard let data = data else { return }
            let cellHeight: CGFloat
            if data.ratioType == .one2one {
                cellHeight = self.cellWidth
            } else {
                cellHeight = self.cellWidth / 3 * 4
            }
            
            let cellView = ImageListCellView(data)
            back.addSubviews(cellView)
            if idx % 2 == 0 { //왼쪽
                NSLayoutConstraint.activate([
                    cellView.topAnchor.constraint(equalTo: obj.lTopAnc,
                                                  constant: obj.topConst),
                    cellView.leftAnchor.constraint(equalTo: back.leftAnchor,
                                                   constant: obj.leftConst),
                    cellView.widthAnchor.constraint(equalToConstant: cellWidth),
                    cellView.heightAnchor.constraint(equalToConstant: cellHeight),
                ])
                obj.lTopAnc = cellView.bottomAnchor
                obj.leftConst = 15
                obj.lHeight += cellHeight
            } else { //오른쪽
                NSLayoutConstraint.activate([
                    cellView.topAnchor.constraint(equalTo: obj.rTopAnc,
                                                  constant: obj.topConst),
                    cellView.widthAnchor.constraint(equalToConstant: cellWidth),
                    cellView.heightAnchor.constraint(equalToConstant: cellHeight),
                    cellView.rightAnchor.constraint(equalTo: back.rightAnchor)
                ])
                obj.rTopAnc = cellView.bottomAnchor
                obj.leftConst = 0
                obj.topConst = 15
                obj.rHeight += cellHeight
            }
        
            cellView.cardTouchedClosure = { [weak self] cardModel in
                self?.cardTouchedClosure?(cardModel)
            }
            guard idx + 1 == datas?.count ?? 0 else { return }
            
            if obj.lHeight > obj.rHeight {
                obj.lTopAnc.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
            } else {
                obj.rTopAnc.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
            }
        }
    }
}
