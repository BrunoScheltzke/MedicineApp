//
//  CoreDataService.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 03/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import UIKit
import CoreData

class CoreDataService: LocalDatabaseServiceProtocol {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var container: NSPersistentContainer! = nil
    private let notificationService: NotificationServiceProtocol
    var listener: RegisterListener?
    
    init(notificationService: NotificationServiceProtocol) {
        container = appDelegate.persistentContainer
        self.notificationService = notificationService
    }
    
    func getRegister(of reminder: Reminder, at date: Date) -> Register {
        if let register = fetchRegister(of: reminder, at: date) {
            return register
        } else {
            return createRegister(for: reminder, date: date, taken: false)!
        }
    }
    
    func fetchRegister(of reminder: Reminder, at date: Date) -> Register? {
        let request = NSFetchRequest<RegisterCoreData>(entityName: Keys.Register.tableName)
        
        guard let reminderObj = fetchReminderCoreData(byId: reminder.id) else { return nil }
        request.predicate = NSPredicate(format: "(\(Keys.Register.reminder) == %@) AND (\(Keys.Register.date) >= %@) AND (\(Keys.Register.date) =< %@)", reminderObj, date.startOfDay() as NSDate, date.endOfDay() as NSDate)
        
        var registers: [RegisterCoreData] = []
        
        do {
            registers = try container.viewContext.fetch(request)
        } catch  {
            print(error)
        }
        
        if let register = registers.first {
            return Register(register)
        } else {
            return nil
        }
    }
    
    @discardableResult func createRegister(for reminder: Reminder, date: Date, taken: Bool) -> Register? {
        let registerObj = NSEntityDescription.insertNewObject(forEntityName: Keys.Register.tableName, into: container.viewContext) as! RegisterCoreData
        
        guard let reminderObj = fetchReminderCoreData(byId: reminder.id) else { return nil }
        
        registerObj.reminder = reminderObj
        registerObj.date = date
        registerObj.taken = taken
        
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        
        let register = Register(registerObj)
        
        if register.date.startOfDay() == Date().startOfDay() {
            listener?.updatedTodayRegisters(fetchTodayRegisters())
        }
        
        return register
    }
    
    @discardableResult func complete(_ register: Register) -> Register {
        let obj = fetchRegisterCoreData(byId: register.id)
        obj?.setValue(true, forKey: Keys.Register.taken)
        
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        
        let register = Register(obj!)
        
        if register.date.startOfDay() == Date().startOfDay() {
            listener?.updatedTodayRegisters(fetchTodayRegisters())
        }
        
        return register
    }
    
    func fetchReminder(byId id: String) -> Reminder? {
        if let reminder = fetchReminderCoreData(byId: id) {
            return Reminder(reminder)
        }
        return nil
    }
    func fetchRegister(byId id: String) -> Register? {
        if let register = fetchRegisterCoreData(byId: id) {
            return Register(register)
        }
        return nil
    }
    
    func fetchTodayRegisters() -> [Register] {
        let reminders = fetchAllReminders()
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        
        let todayReminders = reminders.filter { reminder -> Bool in
            reminder.frequency.map {$0.weekday()}.contains(weekday) ||
            reminder.frequency.contains(.everyday) ||
            (reminder.frequency.contains(.currentDayOnly) &&  reminder.date.startOfDay() == today.startOfDay())
        }
        
        return todayReminders.map { getRegister(of: $0, at: today) }
    }
    
    private func fetchRegisterCoreData(byId id: String) -> RegisterCoreData? {
        guard let url = URL(string: id), let reminderObjId = container.viewContext
            .persistentStoreCoordinator?
            .managedObjectID(forURIRepresentation: url) else {
                return nil
        }
        
        return container.viewContext.object(with: reminderObjId) as? RegisterCoreData
    }
    
    private func fetchReminderCoreData(byId id: String) -> ReminderCoreData? {
        guard let url = URL(string: id), let reminderObjId = container.viewContext
                                    .persistentStoreCoordinator?
                                    .managedObjectID(forURIRepresentation: url) else {
            return nil
        }
        
        return container.viewContext.object(with: reminderObjId) as? ReminderCoreData
    }
    
    private func fetchMedicineCoreData(byId id: String) -> MedicineCoreData? {
        guard let url = URL(string: id), let medicineObjId = container.viewContext
            .persistentStoreCoordinator?
            .managedObjectID(forURIRepresentation: url) else {
                return nil
        }
        
        return container.viewContext.object(with: medicineObjId) as? MedicineCoreData
    }
    
    func fetchAllReminders() -> [Reminder] {
        let request = NSFetchRequest<ReminderCoreData>(entityName: Keys.Reminder.tableName)
        var reminders: [ReminderCoreData] = []
        
        do {
            reminders = try container.viewContext.fetch(request)
        } catch  {
            print(error)
        }
        
        return reminders.map{ Reminder($0) }
    }
    
    @discardableResult func createReminder(medicine: Medicine, date: Date, dosage: Dosage, frequency: [Frequency] = [], quantity: Int32) -> Reminder {
        let reminderObj = NSEntityDescription.insertNewObject(forEntityName: Keys.Reminder.tableName, into: container.viewContext) as! ReminderCoreData
        
        let medicineObj = fetchMedicineCoreData(byId: medicine.id)!
        
        reminderObj.date = date
        reminderObj.dosage = dosage.rawValue
        reminderObj.quantity = quantity
        reminderObj.medicine = medicineObj
        reminderObj.frequency = NSKeyedArchiver.archivedData(withRootObject: frequency.map { $0.rawValue })
        
        let notificationIds = notificationService.setup(Reminder(reminderObj))
        reminderObj.notifications = NSKeyedArchiver.archivedData(withRootObject: notificationIds)
        
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        
        return Reminder(reminderObj)
    }
    
    @discardableResult func createMedicine(name: String, brand: String?, unit: Int32, dosage: Dosage) -> Medicine {
        let medicine = NSEntityDescription.insertNewObject(forEntityName: Keys.Medicine.tableName,
                                                           into: container.viewContext) as! MedicineCoreData
        medicine.name = name
        medicine.brand = brand
        medicine.unit = unit
        medicine.dosage = dosage.rawValue
        
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        
        return Medicine(medicine)
    }
}
