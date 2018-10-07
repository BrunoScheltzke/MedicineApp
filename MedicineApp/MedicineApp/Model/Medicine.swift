//
//  Medicine.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 07/08/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import Foundation

struct Medicine {
    var id: String
    var name: String
    var unit: Int
    var dosage: Dosage
    var brand: String?
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary[Keys.Medicine.id] as! String
        self.name = dictionary[Keys.Medicine.name] as! String
        self.unit = dictionary[Keys.Medicine.unit] as! Int
        self.dosage = Dosage(rawValue: dictionary[Keys.Medicine.dosage] as! String)!
        self.brand = dictionary[Keys.Medicine.brand] as? String ?? nil
    }
    
    init(id: String, name: String, unit: Int, dosage: Dosage, brand: String?) {
        self.id = id
        self.name = name
        self.unit = unit
        self.dosage = dosage
        self.brand = brand
    }
}
