//
//  ShadowView.swift
//  MedicineApp
//
//  Created by VM on 29/07/20.
//  Copyright © 2020 Bruno Scheltzke. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
    }
    
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    @IBInspectable
    var radius: CGFloat = 2
    
    func setupShadow(offset: CGSize = CGSize(width: 0, height: 4)) {
        self.layer.cornerRadius = radius
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.1
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
}
