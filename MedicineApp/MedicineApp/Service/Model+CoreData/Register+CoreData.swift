//
//  Register+CoreData.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 08/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import Foundation

extension Register {
    init(_ register: RegisterCoreData) {
        self.reminder = Reminder(register.reminder!)
        self.date = register.date!
        self.taken = register.taken
        self.id = register.objectID.uriRepresentation().absoluteString
    }
}
