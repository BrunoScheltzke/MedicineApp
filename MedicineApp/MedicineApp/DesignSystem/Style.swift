//
//  Style.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 30/07/20.
//  Copyright © 2020 Bruno Scheltzke. All rights reserved.
//

import UIKit

public enum DefaultStyle {

    public enum Colors {

        static let calendar: UIColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        
        public static let label: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.label
            } else {
                return .black
            }
        }()
        
        public static let background: UIColor = {
            if #available(iOS 13.0, *) {
                return .systemBackground
            } else {
                return .white
            }
        }()
        
        public static var tint: UIColor = {
            if #available(iOS 13, *) {
                return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                    if UITraitCollection.userInterfaceStyle == .dark {
                        /// Return the color for Dark Mode
                        return .white
                    } else {
                        /// Return the color for Light Mode
                        return .black
                    }
                }
            } else {
                /// Return a fallback color for iOS 12 and lower.
                return .black
            }
        }()
        
    }
}

public let Style = DefaultStyle.self
