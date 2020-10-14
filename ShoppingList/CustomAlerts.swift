//
//  CustomAlerts.swift
//  ShoppingList
//
//  Created by Tales Conrado on 14/10/20.
//

import UIKit

class CustomAlerts {
    static let shared = CustomAlerts()
    
    func startLoadingAlert(presenter: UIViewController, with message: String, spinning: Bool = true) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        if spinning == true {
            loadingIndicator.startAnimating()
        }
        alert.view.addSubview(loadingIndicator)
        presenter.present(alert, animated: true, completion: nil)
    }
    
    func simpleAlert(presenter: UIViewController, with message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Ok", style: .default) {
            (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(confirm)
        presenter.present(alert, animated: true, completion: nil)
    }
}
