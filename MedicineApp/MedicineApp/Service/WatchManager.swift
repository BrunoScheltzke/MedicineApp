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
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    private let database: LocalDatabaseServiceProtocol!
    
    init(database: LocalDatabaseServiceProtocol) {
        self.database = database
    }
    
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
            
            let id = userInfo[Keys.registerId] as! String
            
            guard let register = database.fetchRegister(byId: id) else {
                print("No register found from Id: \(id)")
                return
            }
            database.complete(register)

        default:
            print("Error\(#function)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("Received Message from watch")
        print(message)
        
        guard let command = message[Keys.communicationCommand] as? String else {return}

        switch command {
        case CommunicationProtocol.dailyReminders:
            print("Daily Reminders Requested")

            let result = database.fetchTodayRegisters().map { try? JSONEncoder().encode($0) }

            replyHandler([Keys.communicationCommand: CommunicationProtocol.dailyReminders, Keys.registers: result])

        default:
            print("Error\(#function)")
        }
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

