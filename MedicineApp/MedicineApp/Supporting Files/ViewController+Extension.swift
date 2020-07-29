//
//  ViewController+Extension.swift
//  MedicineApp
//
//  Created by VM on 28/07/20.
//  Copyright © 2020 Bruno Scheltzke. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func present(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.view.tintColor = .systemBlue
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func present(error: Error) {
        present(message: error.localizedDescription)
    }
    
    func addHideKeyboardOnTouch() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
