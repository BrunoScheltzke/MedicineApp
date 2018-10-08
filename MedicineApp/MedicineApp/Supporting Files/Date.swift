//
//  Date.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 07/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import Foundation

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE"
    return formatter
}()

let calendar = Calendar.current

extension Date {
    
    func startOfDay() -> Date {
        return calendar.startOfDay(for: self)
    }
    
    func endOfDay() -> Date {
        return calendar.startOfDay(for: self.adding(days: 1))
    }
    
    func adding(days: Int) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
}
