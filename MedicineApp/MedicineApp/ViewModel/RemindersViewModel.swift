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
    var sectionNames: [String]
    let title: String
    
    private let database: LocalDatabaseServiceProtocol
    private let delegate: RemindersViewModelDelegate
    
    init(database: LocalDatabaseServiceProtocol, delegate: RemindersViewModelDelegate) {
        self.database = database
        self.delegate = delegate
        
        title = "Medicines"
        sectionNames = []
        setupReminders()
    }
    
    var temp = [Int: [ReminderCellViewModel]]()
    
    private func helper(_ reminder: Reminder, date: Date, weekday: Int) {
        if let register = database.fetchRegister(of: reminder, at: date) {
            let registerVM = ReminderCellViewModel(register: register, database: database)
            if temp.keys.contains(weekday) {
                temp[weekday]!.append(registerVM)
            } else {
                temp[weekday] = [registerVM]
            }
        } else {
            let register = database.createRegister(for: reminder, date: date, taken: false)!
            
            let registerVM = ReminderCellViewModel(register: register, database: database)
            if temp.keys.contains(weekday) {
                temp[weekday]!.append(registerVM)
            } else {
                temp[weekday] = [registerVM]
            }
        }
    }
    
    private func setupReminders() {
        //pegar os reminders
        //pra cada reminder
        //ver se nao é currentdayonly expired
        //pra cada frequencia ver se tem register
        //se nao tiver cria
        
        reminderCellVMsByDate = []
        let reminders = database.fetchAllReminders()
        
        //group by date()
        var weekday = calendar.component(.weekday, from: Date())
        let today = Date()
        temp = [Int: [ReminderCellViewModel]]()
        
        reminders.forEach { reminder in
            if reminder.frequency.contains(Frequency.currentDayOnly) {
                if reminder.date.startOfDay() != today.startOfDay() {
                    //delete
                } else {
                    helper(reminder, date: today, weekday: weekday)
                }
            } else if reminder.frequency.contains(Frequency.everyday) {
                Frequency.allCases.filter { $0 != Frequency.currentDayOnly &&  $0 != Frequency.everyday }.forEach({ frequency in
                    let date = weekday == frequency.weekday() ? today : getDateForFutureWeekday(weekday: frequency.weekday())
                    helper(reminder, date: date, weekday: frequency.weekday())
                })
            } else {
                reminder.frequency.forEach({ frequency in
                    let date = weekday == frequency.weekday() ? today : getDateForFutureWeekday(weekday: frequency.weekday())
                    helper(reminder, date: date, weekday: frequency.weekday())
                })
            }
        }
        
        let sorted = Array(temp.keys).sorted(by: <)
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
            if let value = temp[day] {
                reminderCellVMsByDate.append(value)
                var dayInWeek = ""
                switch day {
                case 1: dayInWeek = "Sunday"
                case 2: dayInWeek = "Monday"
                case 3: dayInWeek = "Tuesday"
                case 4: dayInWeek = "Wednesday"
                case 5: dayInWeek = "Thursday"
                case 6: dayInWeek = "Friday"
                case 7: dayInWeek = "Saturday"
                default: dayInWeek = ""
                }
                sectionNames.append(dayInWeek)
            }
        }
    }
    
    private func getDateForFutureWeekday(weekday: Int) -> Date {
        return calendar.nextDate(after: Date(), matching: DateComponents(weekday: weekday), matchingPolicy: .nextTime)!
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
