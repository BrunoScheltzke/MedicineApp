//
//  Medicine+CoreData.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 06/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import Foundation

extension Medicine {
    init(_ medicine: MedicineCoreData) {
        self.id = medicine.objectID.uriRepresentation().absoluteString
        self.name = medicine.name!
        self.unit = Int(medicine.unit)
        self.dosage = Dosage(rawValue: medicine.dosage!)!
        self.brand = medicine.brand
    }
}
