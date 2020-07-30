//
//  UIView+Extension.swift
//
//  Created by Bruno Scheltzke on 04/06/20.
//  Copyright © 2020 Bruno Scheltzke All rights reserved.
//
import UIKit

/// Tag used to remove lock view when requested
private let backgroundViewTag = 3432

extension UIView {
    /// Blocks user interaction and add an animating view to represent a loading process
    func lock() {
        if let _ = self.viewWithTag(backgroundViewTag) {
            return
        }
        
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = layer.cornerRadius
        backgroundView.isUserInteractionEnabled = true
        backgroundView.isAccessibilityElement = true
        backgroundView.accessibilityLabel = "Carregando"
        backgroundView.tag = backgroundViewTag
        backgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        backgroundView.constraintFully(to: self)
        
        let refreshControll = UIActivityIndicatorView()
        refreshControll.color = .white
        refreshControll.constraintFully(to: backgroundView)
        refreshControll.startAnimating()
    }
    
    /// Removes animating view that represents a loading process
    func unlock() {
        guard let backgroundView = self.viewWithTag(backgroundViewTag) else {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            backgroundView.alpha = 0
        }) { (_) in
            backgroundView.removeFromSuperview()
        }
    }
}

extension UIView {
    
    func constraintFully(to view: UIView, margin: CGFloat = 0) {
        constraintFully(to: view, top: margin, bottom: margin, leading: margin, trailing: margin)
    }
    
    func constraintFully(to view: UIView, top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
    }
    
}

@IBDesignable extension UIView {
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}
