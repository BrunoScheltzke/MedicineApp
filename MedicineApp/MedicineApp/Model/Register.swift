//
//  Register.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 07/08/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import Foundation

struct Register {
    var reminder: Reminder
    var date: Date
    var taken: Bool
    var id: String
    
    init(_ dict: [String: Any]) {
        self.reminder = dict[Keys.Register.reminder] as! Reminder
        self.date = dict[Keys.Register.date] as! Date
        self.taken = dict[Keys.Register.taken] as! Bool
        self.id = dict[Keys.Register.id] as! String
    }
}
