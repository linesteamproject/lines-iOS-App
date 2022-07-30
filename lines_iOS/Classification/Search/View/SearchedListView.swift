//
//  SearchedListView.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation
import UIKit

class SearchedListView: UIView {
    private weak var tableView: UITableView!
    internal var list: [String] = [] {
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
        self.addSubViews(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BasicTableViewCell.self,
                           forCellReuseIdentifier: BasicTableViewCell.id)
        self.tableView = tableView
    }
}

extension SearchedListView: UITableViewDelegate,
                            UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableViewCell.id,
                                                       for: indexPath) as? BasicTableViewCell
        else { return UITableViewCell() }
        
        cell.data = list[indexPath.item]
        return cell
    }
}

class BasicTableViewCell: UITableViewCell {
    private weak var label: UILabel!
    internal var data: String? {
        didSet { label.setTitle(data) }
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
        
        let label = UILabel()
        self.contentView.addSubViews(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        label.setTitle(font: .systemFont(ofSize: 12),
                       txtColor: .black)
        self.label = label
    }
}

