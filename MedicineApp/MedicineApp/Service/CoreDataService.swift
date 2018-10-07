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
}

class CoreDataService: LocalDatabaseServiceProtocol {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var container: NSPersistentContainer! = nil
    
    init() {
        container = appDelegate.persistentContainer
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
        
        let notificationIds = NotificationManager.shared.setUpReminder(reminder: Reminder(reminderObj))
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
