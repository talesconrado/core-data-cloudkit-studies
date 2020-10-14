//
//  View.swift
//  ShoppingList
//
//  Created by Tales Conrado on 14/10/20.
//

import UIKit

class View: UIView {
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.tableFooterView = UIView()
        
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupTableView() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            tableView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
        ])
    }
}

