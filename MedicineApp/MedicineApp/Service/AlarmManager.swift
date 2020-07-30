//
//  AlarmManager.swift
//  MedicineApp
//
//  Created by Bruno Scheltzke on 30/07/20.
//  Copyright © 2020 Bruno Scheltzke. All rights reserved.
//

import Foundation
import EventKit

class AlarmManager: NotificationServiceProtocol {
    
    let eventStore: EKEventStore
    
    init() {
        self.eventStore = EKEventStore()
    }
    
    func setup(_ reminder: Reminder) -> [String] {
        return []
    }
    
    func requestAuthorization(completion: @escaping (NotifiationResult) -> Void) {
        eventStore.requestAccess(to: EKEntityType.event) { (accessGranted, error) in
            if let error = error {
                completion(.error(error))
            } else {
                completion(.granted(accessGranted))
            }
        }
    }
    
    private func getAuthorizationStatus() -> EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: EKEntityType.event)
    }
    
}
