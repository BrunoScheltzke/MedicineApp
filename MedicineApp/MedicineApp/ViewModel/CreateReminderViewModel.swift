//
//  CreateReminderViewModel.swift
//  PillApp
//
//  Created by Bruno Scheltzke on 04/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import Foundation

class CreateReminderViewModel {
    private let delegate: CreateReminderViewModelProtocol
    let database: LocalDatabaseServiceProtocol
    
    init(delegate: CreateReminderViewModelProtocol, database: LocalDatabaseServiceProtocol) {
        self.delegate = delegate
        self.database = database
    }
    
    func leave() {
        delegate.didAskToDismiss()
    }
    
    func createReminder(forMedicineName medicine: String, date: Date, dosage: Dosage, frequency: [Frequency], quantity: Int) {
        let medicine = database.createMedicine(name: medicine, brand: nil, unit: 0, dosage: dosage)
        database.createReminder(medicine: medicine, date: date, dosage: dosage, frequency: frequency, quantity: Int32(quantity))
    }
}

protocol CreateReminderViewModelProtocol {
    func didAskToDismiss()
}
