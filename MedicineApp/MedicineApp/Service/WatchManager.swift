//
//  WatchManager.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 07/10/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchManager: NSObject, WCSessionDelegate {
    static let shared = WatchManager()
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Received application context from Watch")
        print(applicationContext)
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print("Received User Info from Watch")
        print(userInfo)
        
        guard let command = userInfo[Keys.communicationCommand] as? String else {return}
        
        switch command {
        case CommunicationProtocol.checkedReminder:
            print("User checked a reminder from Watch")
            
            let taken = userInfo[Keys.medicineTaken] as! Bool
            let idStr = userInfo[Keys.reminderId] as! String
            
            guard let idUrl = URL(string: idStr) else {
                print("Reminder Id: \(idStr) was not able to be converted into CoreData Object Id")
                return
            }
            
            //            guard let reminder = CoreDataManager.shared.fetchReminder(by: idUrl) else {
            //                print("No reminder found from Id: \(idStr)")
            //                return
            //            }
            //            let date = userInfo[Keys.date] as? Date ?? Date()
            //
            //            CoreDataManager.shared.createRegister(date: date, reminder: reminder, taken: taken)
        //
        default:
            print("Error\(#function)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("Received Message from watch")
        print(message)
        
        //        guard let command = message[Keys.communicationCommand] as? String else {return}
        //
        //        switch command {
        //        case CommunicationProtocol.dailyReminders:
        //            print("Daily Reminders Requested")
        //
        //            let result = CoreDataManager.shared.fetchTodaysReminders()
        //
        //            let reminders = result.0 ?? []
        //            let registers = result.1 ?? []
        //
        //            var remindersDict: [[String: Any]] = []
        //            reminders.forEach({ (reminder) in remindersDict.append(CoreDataManager.shared.toDictionary(reminder))
        //            })
        //
        //            var registerDict: [[String: Any]] = []
        //            registers.forEach({ (register) in registerDict.append(CoreDataManager.shared.toDictionary(register))
        //            })
        //
        //            replyHandler([Keys.communicationCommand: CommunicationProtocol.dailyReminders, Keys.reminders: remindersDict, Keys.registers: registerDict])
        //
        //        default:
        //            print("Error\(#function)")
        //        }
    }
    
    func updateApplicationContext(context: [String: Any]) throws {
        do {
            try session?.updateApplicationContext(context)
        } catch {
            throw error
        }
    }
    
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
    
    // MARK: Delegate unused methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if error != nil {
            print("Error to connect session: \(String(describing: error!))")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {}
}

