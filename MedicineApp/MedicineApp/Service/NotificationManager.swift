//
//  NotificationManager.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 07/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import UserNotifications
import UIKit
import CoreData

struct NotificationCategoryIdentifier {
    static let medicineTaking = "TAKEMEDICINE"
}

struct NotificationActionIdentifier {
    static let yes = "Yes"
    static let no = "No"
    static let snooze = "Snooze"
}

class NotificationManager: NSObject, NotificationServiceProtocol {
    let center = UNUserNotificationCenter.current()
    
    var database: LocalDatabaseServiceProtocol!
    
    override init() {
        super.init()
        center.delegate = self
        registerCategories()
    }
    
    func requestAuthorization(completion: @escaping (NotifiationResult) -> Void) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard error == nil else {
                completion(.error(error!))
                return
            }
            
            completion(.granted(granted))
        }
    }
    
    private func registerCategories() {
        let yesAction = UNNotificationAction(identifier: NotificationActionIdentifier.yes, title: NotificationActionIdentifier.yes, options: .foreground)
        //        let snoozeAction = UNNotificationAction(identifier: NotificationActionIdentifier.snooze, title: NotificationActionIdentifier.yes, options: .foreground)
        let noAction = UNNotificationAction(identifier: NotificationActionIdentifier.no, title: NotificationActionIdentifier.no, options: .foreground)
        
        let medicineTakingCategory = UNNotificationCategory(identifier: NotificationCategoryIdentifier.medicineTaking, actions: [yesAction, noAction], intentIdentifiers: [], options: .customDismissAction)
        
        center.setNotificationCategories([medicineTakingCategory])
    }
    
    func setup(_ reminder: Reminder) -> [String] {
        
        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.body = "Remember to take \(reminder.quantity) \(reminder.dosage.rawValue) of \(reminder.medicine.name)"
        content.categoryIdentifier = NotificationCategoryIdentifier.medicineTaking
        content.userInfo = [Keys.reminderId: reminder.id]
        
        var date = DateComponents()
        //TODO: FIX THIS DISGUSTING THING WITH UTC
        date.hour = Calendar.current.component(.hour, from: reminder.date)
        date.minute = Calendar.current.component(.minute, from: reminder.date)
        
        if reminder.frequency.contains(.currentDayOnly) {
            let weekday = Calendar.current.component(.weekday, from: Date())
            date.weekday = weekday
            let notificationId = reminder.id + reminder.medicine.name + "\(weekday)"
            createNotification(date, repeats: false, id: notificationId, content: content)
            return [notificationId]
        } else if reminder.frequency.contains(.everyday) {
            var notificationIds: [String] = []
            for weekday in 1...7 {
                date.weekday = weekday
                let notificationId = reminder.id + reminder.medicine.name + "\(weekday)"
                createNotification(date, repeats: true, id: notificationId, content: content)
                notificationIds.append(notificationId)
            }
            return notificationIds
        } else {
            var notificationIds: [String] = []
            reminder.frequency.forEach { frequency in
                date.weekday = frequency.weekday()
                let notificationId = reminder.id + reminder.medicine.name + "\(frequency.weekday())"
                createNotification(date, repeats: true, id: notificationId, content: content)
                notificationIds.append(notificationId)
            }
            return notificationIds
        }
    }
    
    private func createNotification(_ date: DateComponents, repeats: Bool, id: String, content: UNMutableNotificationContent) {
        let trigger: UNCalendarNotificationTrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeats)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        center.add(request) { (error) in
            print(error ?? "Setup notification for medication")
        }
    }

    private func createLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.body = "Remember to take your medication"
        content.categoryIdentifier = NotificationCategoryIdentifier.medicineTaking
        content.userInfo = [Keys.reminderId: "x-coredata://8C1C55E8-70EA-4606-AF3C-8EEF5F1711C5/Reminder/p1"]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 11.0, repeats: false)
        
        // Create the request object.
        let request = UNNotificationRequest(identifier: "PillAlarm", content: content, trigger: trigger)
        
        center.add(request) { (error) in
            print(error ?? "")
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification response: \(response.actionIdentifier)")
        
        if response.notification.request.content.categoryIdentifier == NotificationCategoryIdentifier.medicineTaking {

            let reminderDict = response.notification.request.content.userInfo
            let id = reminderDict[Keys.reminderId] as! String

            guard let reminder = database.fetchReminder(byId: id) else {
                print("No reminder found for reminder id: \(id)")
                return
            }
            let date = Date()
            
            let register = database.getRegister(of: reminder, at: date)
            
            database.complete(register)
            
            completionHandler()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}
