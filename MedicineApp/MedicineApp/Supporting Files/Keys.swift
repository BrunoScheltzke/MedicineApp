//
//  Keys.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 07/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import Foundation

struct CommunicationProtocol {
    static let notification = "notification"
    static let dailyReminders = "dailyReminders"
    static let medicineLeft = "medicineLeft"
    static let checkedReminder = "checkedReminder"
}

struct Keys {
    static let reminderId = "reminderId"
    static let registerId = "registerId"
    static let date = "date"
    static let medicineTaken = "medicineTaken"
    static let communicationCommand = "command"
    static let reminders = "reminders"
    static let registers = "registers"
    
    struct Reminder {
        static let id = "id"
        static let date = "date"
        static let dosage = "dosage"
        static let frequency = "frequency"
        static let quantity = "quantity"
        static let medicine = "medicine"
        static let tableName = "ReminderCoreData"
        static let notifications = "Notifications"
    }
    
    struct Register {
        static let id = "id"
        static let date = "date"
        static let taken = "taken"
        static let reminder = "reminder"
        static let tableName = "RegisterCoreData"
    }
    
    struct Medicine {
        static let id = "id"
        static let brand = "brand"
        static let dosage = "dosage"
        static let name = "name"
        static let unit = "unit"
        static let tableName = "MedicineCoreData"
    }
}
