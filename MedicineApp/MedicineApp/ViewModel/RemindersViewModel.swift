//
//  RemindersViewModel.swift
//  PillApp
//
//  Created by Bruno Scheltzke on 03/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import Foundation

class RemindersViewModel {
    // Outputs
    var reminderCellVMsByDate: [[ReminderCellViewModel]] = []
    var sectionNames: [Int]
    let title: String
    
    private let database: LocalDatabaseServiceProtocol
    private let delegate: RemindersViewModelDelegate
    
    init(database: LocalDatabaseServiceProtocol, delegate: RemindersViewModelDelegate) {
        self.database = database
        self.delegate = delegate
        
        title = "Today"
        sectionNames = []
        setupReminders()
    }
    
    private func setupReminders() {
        reminderCellVMsByDate = []
        let reminders = database.fetchAllReminders().map { Reminder($0) }
        
        //group by date()
        let cal = Calendar(identifier: .gregorian)
        var weekday = cal.component(.weekday, from: Date())
        
        var temp0 = [Int: [ReminderCellViewModel]]()
        reminders.forEach { reminder in
            let reminderVM = ReminderCellViewModel(reminder: reminder)
            if reminder.frequency.contains(Frequency.everyday) {
                Frequency.allCases.filter { $0 != Frequency.currentDayOnly &&  $0 != Frequency.everyday }.forEach({ frequency in
                    if temp0.keys.contains(frequency.weekday()) {
                        temp0[frequency.weekday()]!.append(reminderVM)
                    } else {
                        temp0[frequency.weekday()] = [reminderVM]
                    }
                })
            } else if reminder.frequency.contains(Frequency.currentDayOnly) {
                if temp0.keys.contains(weekday) {
                    temp0[weekday]!.append(reminderVM)
                } else {
                    temp0[weekday] = [reminderVM]
                }
            } else {
                reminder.frequency.forEach({ frequency in
                    if temp0.keys.contains(frequency.weekday()) {
                        temp0[frequency.weekday()]!.append(reminderVM)
                    } else {
                        temp0[frequency.weekday()] = [reminderVM]
                    }
                })
            }
        }
        
        let sorted = Array(temp0.keys).sorted(by: <)
        var sortedBasedOnToday: [Int] = []
        
        for _ in 1...7 {
            if weekday > 7 {
                weekday = weekday - 7
            }
            
            if sorted.contains(weekday) {
                sortedBasedOnToday.append(weekday)
            }
            
            weekday += 1
        }
        
        sortedBasedOnToday.forEach { day in
            if let value = temp0[day] {
                reminderCellVMsByDate.append(value)
                sectionNames.append(day)
            }
        }
    }
    
    // Inputs
    func addReminder() {
        delegate.didAskToAddReminder()
    }
    
    func updateReminders() {
        setupReminders()
    }
}

protocol RemindersViewModelDelegate {
    func didAskToAddReminder()
}
