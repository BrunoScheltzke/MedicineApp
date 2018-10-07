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
            colorView.backgroundColor = viewModel.color
            medicineLabel.text = viewModel.name
            quantityLabel.text = "\(viewModel.quantity)"
            timeLabel.text = "\(viewModel.date)"
        }
    }
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var medicineLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
