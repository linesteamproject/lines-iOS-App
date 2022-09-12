//
//  MakeCard_SearchedListView.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation
import UIKit

class MakeCard_SearchedListView: UIView {
    private weak var tableView: UITableView!
    internal weak var delegate: ButtonDelegate?
    internal var isLoading: Bool = false
    internal var pageClosure: (() -> Void)?
    internal var list: [BookDocu] = [] {
        didSet { tableView.reloadData() }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func setUI() {
        self.backgroundColor = .clear
        
        let tableView = UITableView()
        self.addSubviews(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MakeCard_BasicTableViewCell.self,
                           forCellReuseIdentifier: MakeCard_BasicTableViewCell.id)
        self.tableView = tableView
    }
}

extension MakeCard_SearchedListView: UITableViewDelegate,
                            UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MakeCard_BasicTableViewCell.id,
                                                       for: indexPath) as? MakeCard_BasicTableViewCell
        else { return UITableViewCell() }
        
        cell.bookDocu = list[indexPath.item]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.touched(list[indexPath.item])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.tableView.contentOffset.y > tableView.contentSize.height-tableView.bounds.size.height
        else { return }
        
        guard !isLoading else { return }
        self.pageClosure?()
        isLoading = true
    }
}

class MakeCard_BasicTableViewCell: UITableViewCell {
    private weak var imgView: UIImageView!
    private weak var label: UILabel!
    internal var bookDocu: BookDocu? {
        didSet {
            guard let bookDocu = bookDocu else {
                return
            }

            if let urlStr = bookDocu.thumbnail {
                imgView.load(urlStr: urlStr)
            }
            label.setTitle(bookDocu.bookName + bookDocu.authorsStr)
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func setUI() {
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        let imgView = UIImageView()
        let label = UILabel()
        self.contentView.addSubviews(imgView, label)
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                        constant: 12),
            imgView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor,
                                         constant: 20),
            imgView.widthAnchor.constraint(equalToConstant: 44),
            imgView.heightAnchor.constraint(equalToConstant: 59),
            imgView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                           constant: -12),
            
            
            label.leftAnchor.constraint(equalTo: imgView.rightAnchor,
                                        constant: 15),
            label.rightAnchor.constraint(equalTo: self.contentView.rightAnchor,
                                         constant: -20),
            label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        ])
        label.numberOfLines = 0
        label.setTitle(font: Fonts.get(size: 16,
                                       type: .regular),
                       txtColor: .white)
        self.label = label
        self.imgView = imgView
    }
}

