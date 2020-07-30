//
//  ReminderItemTableViewCell.swift
//  PillApp
//
//  Created by Bruno Scheltzke on 03/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import UIKit

class ReminderItemTableViewCell: UITableViewCell {
    
    var viewModel: ReminderCellViewModel! {
        didSet {
            viewModel.delegate = self
            
            colorView.backgroundColor = viewModel.color
            medicineLabel.text = viewModel.name
            quantityLabel.text = viewModel.quantity
            timeLabel.text = viewModel.date
            setupButton()
            medicineTakenButton.isHidden = viewModel.medicineButtonIsHidden
        }
    }
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var medicineLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var medicineTakenButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func takeMedicine(_ sender: Any) {
        viewModel.takeMedicine()
    }
    
    fileprivate func setupButton() {
        colorView.backgroundColor = viewModel.color
        medicineTakenButton.setTitle(viewModel.medicineButtonTitle, for: .normal)
        medicineTakenButton.isEnabled = viewModel.medicineButtonIsEnabled
        
        medicineTakenButton.backgroundColor = viewModel.color
        medicineTakenButton.isHidden = viewModel.medicineButtonIsHidden
    }
}

extension ReminderItemTableViewCell: ReminderCellDelegate {
    func didUpdateRegister() {
        setupButton()
    }
}
