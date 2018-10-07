//
//  MedicineCellViewModel.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 03/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import UIKit

class ReminderCellViewModel {
    var date: Date
    var name: String
    var quantity: Int
    var color: UIColor
    
    init(reminder: Reminder) {
        date = reminder.date
        name = reminder.medicine.name
        quantity = reminder.quantity
        color = .red
    }
}
