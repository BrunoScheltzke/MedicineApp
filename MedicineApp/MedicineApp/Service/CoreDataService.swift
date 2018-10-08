//
//  CoreDataService.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 03/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import UIKit
import CoreData

protocol LocalDatabaseServiceProtocol {
    func fetchAllReminders() -> [ReminderCoreData]
    @discardableResult func createReminder(medicine: MedicineCoreData, date: Date, dosage: Dosage, frequency: [Frequency], quantity: Int32) -> ReminderCoreData
    @discardableResult func createMedicine(name: String, brand: String?, unit: Int32, dosage: Dosage) -> MedicineCoreData
    func fetchRegister(of reminder: Reminder, at date: Date) -> Register?
    @discardableResult func createRegister(for reminder: Reminder, date: Date, taken: Bool) -> Register?
    func complete(_ register: Register) -> Register
}

class CoreDataService: LocalDatabaseServiceProtocol {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var container: NSPersistentContainer! = nil
    private let notificationService: NotificationServiceProtocol
    
    init(notificationService: NotificationServiceProtocol) {
        container = appDelegate.persistentContainer
        self.notificationService = notificationService
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
        
        return Register(registerObj)
    }
    
    func complete(_ register: Register) -> Register {
        let obj = fetchRegisterCoreData(byId: register.id)
        obj?.setValue(true, forKey: Keys.Register.taken)
        
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        
        return Register(obj!)
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
    
    func fetchAllReminders() -> [ReminderCoreData] {
        let request = NSFetchRequest<ReminderCoreData>(entityName: Keys.Reminder.tableName)
        var reminders: [ReminderCoreData] = []
        
        do {
            reminders = try container.viewContext.fetch(request)
        } catch  {
            print(error)
        }
        
        return reminders
    }
    
    @discardableResult func createReminder(medicine: MedicineCoreData, date: Date, dosage: Dosage, frequency: [Frequency] = [], quantity: Int32) -> ReminderCoreData {
        let reminderObj = NSEntityDescription.insertNewObject(forEntityName: Keys.Reminder.tableName, into: container.viewContext) as! ReminderCoreData
        
        reminderObj.date = date
        reminderObj.dosage = dosage.rawValue
        reminderObj.quantity = quantity
        reminderObj.medicine = medicine
        reminderObj.frequency = NSKeyedArchiver.archivedData(withRootObject: frequency.map { $0.rawValue })
        
        let notificationIds = notificationService.setup(Reminder(reminderObj))
        reminderObj.notifications = NSKeyedArchiver.archivedData(withRootObject: notificationIds)
        
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
        
        return reminderObj
    }
    
    @discardableResult func createMedicine(name: String, brand: String?, unit: Int32, dosage: Dosage) -> MedicineCoreData {
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
        
        return medicine
    }
}
