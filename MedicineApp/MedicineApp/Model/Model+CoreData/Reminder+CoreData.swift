//
//  Reminder+CoreData.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 06/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import Foundation

extension Reminder {
    init(_ reminder: ReminderCoreData) {
        let dosageStr = reminder.dosage!
        let frequencyData = reminder.frequency!
        let medicineCoreData = reminder.medicine!
        
        if let notificationsData = reminder.notifications {
            self.notifications = NSKeyedUnarchiver.unarchiveObject(with: notificationsData) as! [String]
        } else {
            self.notifications = []
        }
        
        self.date = reminder.date!
        self.id = reminder.objectID.uriRepresentation().absoluteString
        self.medicine = Medicine(medicineCoreData)
        self.dosage = Dosage(rawValue: dosageStr)!
        self.quantity = Int(reminder.quantity)
        let frequencies = NSKeyedUnarchiver.unarchiveObject(with: frequencyData) as! [String]
        
        self.frequency = frequencies.map { Frequency(rawValue: $0)! }
    }
}
