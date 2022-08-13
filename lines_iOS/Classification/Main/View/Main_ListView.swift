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
    private var obj = MainListViewObj()
    init(width: CGFloat, datas: [UIImage?]?) {
        self.cellWidth = (width - 15) / 2
        super.init(frame: .zero)
        
        setTitle(datas?.count ?? 0)
        setListView(datas)
    }
    required init?(coder: NSCoder) { fatalError() }
    private func setTitle(_ count: Int) {
        let label = UILabel()
        self.addSubViews(label)
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
        label.setTitle(String(format: "기록한 문장 %d개", count),
                       font: Fonts.get(size: 16, type: .bold),
                       txtColor: .gold)
        self.nextTopAnchor = label.bottomAnchor
    }
    private func setListView(_ datas: [UIImage?]?) {
        let back = UIView()
        self.addSubViews(back)
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: nextTopAnchor,
                                      constant: 12),
            back.leftAnchor.constraint(equalTo: self.leftAnchor),
            back.rightAnchor.constraint(equalTo: self.rightAnchor),
            back.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        obj.lTopAnc = back.topAnchor
        obj.rTopAnc = back.topAnchor
        datas?.enumerated().forEach { idx, data in
            guard let data = data else { return }
            
            let cellHeight = self.cellWidth * data.size.height / data.size.width
            print("munyong > \(cellWidth), \(cellHeight)")
            let cellView = ImageListCellView(data)
            back.addSubViews(cellView)
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
        
            guard idx + 1 == datas?.count ?? 0 else { return }
            
            if obj.lHeight > obj.rHeight {
                obj.lTopAnc.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
            } else {
                obj.rTopAnc.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
            }
        }
    }
}
