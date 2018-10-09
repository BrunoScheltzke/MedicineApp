//
//  Frequency.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 07/08/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import Foundation

enum Frequency: String, CaseIterable, Codable {
    case everyday = "Everyday"
    case everySunday = "Every sunday"
    case everyMonday = "Every monday"
    case everyTuesday = "Every tuesday"
    case everyWednesday = "Every wednesday"
    case everyThursday = "Every thursday"
    case everyFriday = "Every friday"
    case everySaturday = "Every saturday"
    case currentDayOnly = "Current day only"
    
    func weekday() -> Int {
        switch self {
        case .everySunday: return 1
        case .everyMonday: return 2
        case .everyTuesday: return 3
        case .everyWednesday: return 4
        case .everyThursday: return 5
        case .everyFriday: return 6
        case .everySaturday: return 7
        default: return 0
        }
    }
}
