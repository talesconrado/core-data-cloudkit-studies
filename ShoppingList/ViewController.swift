//
//  ViewController.swift
//  ShoppingList
//
//  Created by Tales Conrado on 14/10/20.
//

import UIKit

class ViewController: UIViewController {
    
    let contentView: View = {
        let view = View()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    override func loadView() {
        view = contentView
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Compras"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
    }
    
    @objc func addItem() {
        
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    
}

