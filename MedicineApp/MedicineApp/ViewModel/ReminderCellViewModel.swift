//
//  MedicineCellViewModel.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 03/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import UIKit

class ReminderCellViewModel {
    let date: Date
    let name: String
    let quantity: Int
    let color: UIColor
    var medicineButtonIsEnabled: Bool = false
    var medicineButtonTitle: String = ""
    
    private var register: Register
    private let database: LocalDatabaseServiceProtocol
    
    init(register: Register, database: LocalDatabaseServiceProtocol) {
        self.database = database
        self.date = register.date
        self.name = register.reminder.medicine.name
        self.quantity = register.reminder.quantity
        self.color = .red
        self.register = register
        
        setupButton()
    }
    
    private func setupButton() {
        let today = Date()
        let shouldTakeToday = register.date.startOfDay() == today.startOfDay()
        
        if shouldTakeToday {
            medicineButtonIsEnabled = !register.taken
            medicineButtonTitle = register.taken ? "Already taken" : "Take"
        } else {
            medicineButtonIsEnabled = false
            medicineButtonTitle = "Not today"
        }
    }
    
    func takeMedicine() {
        database.complete(register)
    }
}
