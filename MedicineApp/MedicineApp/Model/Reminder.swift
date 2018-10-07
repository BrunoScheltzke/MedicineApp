//
//  Reminder.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 07/08/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import Foundation

struct Reminder {
    var id: String
    var medicine: Medicine
    var dosage: Dosage
    var quantity: Int
    var date: Date
    var frequency: [Frequency]
    var notifications: [String]
}

extension Reminder {
    init(_ dictionary: [String: Any]) {
        self.id = dictionary[Keys.Reminder.id] as! String
        self.medicine = Medicine(dictionary[Keys.Reminder.medicine] as! [String: Any])
        self.dosage = Dosage(rawValue: dictionary[Keys.Reminder.dosage] as! String)!
        self.quantity = dictionary[Keys.Reminder.quantity] as! Int
        self.date = dictionary[Keys.Reminder.date] as! Date
        self.frequency = []
        //        self.frequency = Frequency(rawValue: dictionary[Keys.Reminder.frequency] as! String)!
        self.notifications = dictionary[Keys.Reminder.notifications] as! [String]
    }
}
