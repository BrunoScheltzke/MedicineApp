//
//  RegisterCell.swift
//  MedicineWatchApp Extension
//
//  Created by Bruno Scheltzke on 08/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import WatchKit

class RegisterCell: NSObject {
    @IBOutlet weak var medicineLabel: WKInterfaceLabel!
    @IBOutlet weak var quantityLabel: WKInterfaceLabel!
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    
    @IBOutlet weak var takeButton: WKInterfaceButton!
    
    var delegate: CellDelegate?
    
    var register: Register! {
        didSet {
            medicineLabel.setText(register.reminder.medicine.name)
            quantityLabel.setText("\(register.reminder.quantity), \(register.reminder.dosage)")
            dateLabel.setText(dateFormatter.string(from: register.reminder.date))
            
            let today = Date()
            let shouldTakeToday = register.date.startOfDay() == today.startOfDay()
            
            if shouldTakeToday {
                takeButton.setEnabled(!register.taken)
                let title = register.taken ? "Already taken" : "Take"
                let color: UIColor = register.taken ? .gray : .red
                takeButton.setTitle(title)
                takeButton.setBackgroundColor(color)
            } else {
                takeButton.setEnabled(false)
                takeButton.setBackgroundColor(.gray)
                takeButton.setTitle("Not today")
            }
        }
    }
    
    @IBAction func askedToTakePill() {
        delegate?.askedToTakeMedicine(for: register)
    }
}

protocol CellDelegate {
    func askedToTakeMedicine(for register: Register)
}
