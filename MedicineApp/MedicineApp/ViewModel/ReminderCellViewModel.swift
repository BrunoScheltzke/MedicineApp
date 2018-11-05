//
//  MedicineCellViewModel.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 03/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import UIKit

class ReminderCellViewModel {
    let date: String
    let name: String
    let quantity: String
    var color: UIColor
    var medicineButtonIsEnabled: Bool = false
    var medicineButtonTitle: String = ""
    var medicineButtonIsHidden: Bool = false
    
    private var register: Register {
        didSet {
            setupButton()
        }
    }
    private let database: LocalDatabaseServiceProtocol
    var delegate: ReminderCellDelegate?
    
    init(register: Register, database: LocalDatabaseServiceProtocol) {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "HH:mm"
        
        self.database = database
        self.date = dateFormatterGet.string(from: register.date)
        self.name = register.reminder.medicine.name
        self.quantity = "\(register.reminder.quantity) \(register.reminder.dosage.rawValue)"
        
        self.color = register.taken ? #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1) : #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
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
            medicineButtonIsHidden = true
            self.color = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        }
    }
    
    func takeMedicine() {
        self.register = database.complete(register)
        self.color = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        delegate?.didUpdateRegister()
    }
}

protocol ReminderCellDelegate {
    func didUpdateRegister()
}
